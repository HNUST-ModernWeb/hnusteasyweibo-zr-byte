package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Conversation {
    private Long id;
    private Long userId;
    private Long targetUserId;
    private Long lastMessageId;
    private LocalDateTime lastMessageTime;
    private Integer unreadCount;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    private User targetUser;
    private Message lastMessage;
}
