package com.example.service;

import com.example.entity.User;
import com.example.utils.Result;
import java.util.List;

public interface UserService {
    Result<User> register(String username, String password, String nickname);
    Result<User> login(String username, String password, String ip);
    Result<User> getUserInfo(Long userId);
    Result<User> updateUserInfo(User user);
    Result<Void> updatePassword(Long userId, String oldPassword, String newPassword);
    List<User> getHotUsers(Long userId, Integer limit);
    List<User> searchUsers(String keyword);
    Result<Void> follow(Long userId, Long followUserId);
    Result<Void> unfollow(Long userId, Long followUserId);
    Result<Void> setSpecialFollow(Long userId, Long followUserId, Boolean isSpecial);
    Result<List<User>> getFollowingList(Long userId);
    Result<List<User>> getFansList(Long userId);
    Result<List<User>> getSpecialFollowingList(Long userId);
}
