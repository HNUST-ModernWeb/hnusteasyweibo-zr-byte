package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class HotSearch {
    private Long id;
    private String keyword;
    private Integer searchCount;
    private Integer rank;
    private String category;
    private Integer isBlocked;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
