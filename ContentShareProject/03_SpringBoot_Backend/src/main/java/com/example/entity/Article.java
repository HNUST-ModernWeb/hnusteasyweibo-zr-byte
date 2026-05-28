package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Article {
    private Long id;
    private Long userId;
    private String content;
    private String images;
    private String video;
    private String location;
    private Double latitude;
    private Double longitude;
    private Integer articleType;
    private Long topicId;
    private String voteTitle;
    private String voteOptions;
    private LocalDateTime voteEndTime;
    private LocalDateTime activityTime;
    private String activityLocation;
    private Integer likeCount;
    private Integer commentCount;
    private Integer forwardCount;
    private Integer favoriteCount;
    private Integer shareCount;
    private Integer viewCount;
    private Integer status;
    private Integer isTop;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    private User user;
    private String topicName;
    private Boolean isLiked;
    private Boolean isFavorited;
}
