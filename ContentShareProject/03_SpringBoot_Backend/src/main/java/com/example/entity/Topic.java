package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Topic {
    private Long id;
    private String name;
    private String description;
    private String icon;
    private String coverImage;
    private Integer participantCount;
    private Integer articleCount;
    private Integer 热度Score;
    private String category;
    private Integer isRecommend;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
