package com.example.service;

import com.example.entity.Message;
import com.example.entity.Conversation;
import com.example.utils.Result;
import java.util.List;

public interface MessageService {
    Result<List<Conversation>> getConversations(Long userId);
    Result<List<Message>> getMessages(Long userId, Long targetUserId, Integer page, Integer limit);
    Result<Void> sendMessage(Long fromUserId, Long toUserId, String content, Integer messageType);
    Result<Void> markAsRead(Long userId, Long fromUserId);
    Result<Integer> getUnreadCount(Long userId);
}
