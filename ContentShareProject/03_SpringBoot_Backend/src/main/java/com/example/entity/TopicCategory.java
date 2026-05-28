package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TopicCategory {
    private Long id;
    private String name;
    private String icon;
    private Integer sortOrder;
    private Integer status;
    private LocalDateTime createTime;
}
