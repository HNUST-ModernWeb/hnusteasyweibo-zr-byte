package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UserSettings {
    private Long id;
    private Long userId;
    private Integer darkMode;
    private String fontSize;
    private Integer noImageMode;
    private Integer autoPlayVideo;
    private String notificationSettings;
    private String privacySettings;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
