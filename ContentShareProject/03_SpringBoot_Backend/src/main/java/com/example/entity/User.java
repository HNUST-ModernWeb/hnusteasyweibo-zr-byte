package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class User {
    private Long id;
    private String username;
    private String password;
    private String nickname;
    private String avatar;
    private String bio;
    private Integer gender;
    private LocalDateTime birthday;
    private String location;
    private String phone;
    private String email;
    private Integer isVerified;
    private String verifiedType;
    private Integer followCount;
    private Integer fansCount;
    private Integer articleCount;
    private Integer likeCount;
    private Integer status;
    private LocalDateTime lastLoginTime;
    private String lastLoginIp;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private Boolean isFollowing;
}
