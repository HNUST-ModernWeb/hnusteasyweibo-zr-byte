package com.example.service.impl;

import com.example.entity.Message;
import com.example.entity.Conversation;
import com.example.entity.User;
import com.example.mapper.MessageMapper;
import com.example.mapper.ConversationMapper;
import com.example.mapper.UserMapper;
import com.example.service.MessageService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class MessageServiceImpl implements MessageService {

    @Autowired
    private MessageMapper messageMapper;

    @Autowired
    private ConversationMapper conversationMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    public Result<List<Conversation>> getConversations(Long userId) {
        List<Conversation> conversations = conversationMapper.findByUserId(userId);
        return Result.success(conversations);
    }

    @Override
    public Result<List<Message>> getMessages(Long userId, Long targetUserId, Integer page, Integer limit) {
        List<Message> messages = messageMapper.findConversation(userId, targetUserId);
        for (Message message : messages) {
            User fromUser = userMapper.findById(message.getFromUserId());
            User toUser = userMapper.findById(message.getToUserId());
            message.setFromUser(fromUser);
            message.setToUser(toUser);
        }
        return Result.success(messages);
    }

    @Override
    @Transactional
    public Result<Void> sendMessage(Long fromUserId, Long toUserId, String content, Integer messageType) {
        if (userMapper.findById(fromUserId) == null || userMapper.findById(toUserId) == null) {
            return Result.fail("用户不存在");
        }
        Message message = new Message();
        message.setFromUserId(fromUserId);
        message.setToUserId(toUserId);
        message.setContent(content);
        message.setMessageType(messageType != null ? messageType : 1);
        messageMapper.insert(message);

        Conversation conversation1 = new Conversation();
        conversation1.setUserId(fromUserId);
        conversation1.setTargetUserId(toUserId);
        conversation1.setLastMessageId(message.getId());
        conversation1.setLastMessageTime(message.getCreateTime());
        conversationMapper.insertOrUpdate(conversation1);

        Conversation conversation2 = new Conversation();
        conversation2.setUserId(toUserId);
        conversation2.setTargetUserId(fromUserId);
        conversation2.setLastMessageId(message.getId());
        conversation2.setLastMessageTime(message.getCreateTime());
        conversationMapper.insertOrUpdate(conversation2);

        return Result.success();
    }

    @Override
    @Transactional
    public Result<Void> markAsRead(Long userId, Long fromUserId) {
        messageMapper.markAsRead(userId, fromUserId);
        conversationMapper.updateUnreadCount(userId, fromUserId, 0);
        return Result.success();
    }

    @Override
    public Result<Integer> getUnreadCount(Long userId) {
        Integer count = messageMapper.countUnread(userId);
        return Result.success(count);
    }
}
