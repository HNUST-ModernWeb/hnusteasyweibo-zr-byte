package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Comment {
    private Long id;
    private Long articleId;
    private Long userId;
    private Long parentId;
    private Long replyId;
    private String content;
    private Integer likeCount;
    private Integer status;
    private LocalDateTime createTime;

    private User user;
    private String replyUsername;
    private String replyNickname;
}
