package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Message {
    private Long id;
    private Long fromUserId;
    private Long toUserId;
    private String content;
    private Integer messageType;
    private Integer isRead;
    private LocalDateTime createTime;

    private User fromUser;
    private User toUser;
}
