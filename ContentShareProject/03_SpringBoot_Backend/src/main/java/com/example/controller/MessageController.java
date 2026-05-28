package com.example.controller;

import com.example.entity.Message;
import com.example.entity.Conversation;
import com.example.service.MessageService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/message")
@CrossOrigin
public class MessageController {

    @Autowired
    private MessageService messageService;

    @GetMapping("/conversations")
    public Result<List<Conversation>> getConversations(@RequestParam Long userId) {
        return messageService.getConversations(userId);
    }

    @GetMapping("/conversation/{targetUserId}")
    public Result<List<Message>> getMessages(@RequestParam Long userId, @PathVariable Long targetUserId, @RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "50") Integer limit) {
        return messageService.getMessages(userId, targetUserId, page, limit);
    }

    @PostMapping
    public Result<Void> sendMessage(@RequestParam Long fromUserId, @RequestParam Long toUserId, @RequestParam String content, @RequestParam(required = false, defaultValue = "1") Integer messageType) {
        return messageService.sendMessage(fromUserId, toUserId, content, messageType);
    }

    @PutMapping("/read/{fromUserId}")
    public Result<Void> markAsRead(@RequestParam Long userId, @PathVariable Long fromUserId) {
        return messageService.markAsRead(userId, fromUserId);
    }

    @GetMapping("/unread")
    public Result<Integer> getUnreadCount(@RequestParam Long userId) {
        return messageService.getUnreadCount(userId);
    }
}
