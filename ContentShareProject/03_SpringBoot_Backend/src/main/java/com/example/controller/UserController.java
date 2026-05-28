package com.example.controller;

import com.example.entity.User;
import com.example.service.UserService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/user")
@CrossOrigin
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public Result<User> register(@RequestParam String username, @RequestParam String password, @RequestParam(required = false) String nickname) {
        return userService.register(username, password, nickname);
    }

    @PostMapping("/login")
    public Result<User> login(@RequestParam String username, @RequestParam String password, @RequestParam(required = false) String ip) {
        return userService.login(username, password, ip);
    }

    @GetMapping("/info/{userId}")
    public Result<User> getUserInfo(@PathVariable Long userId) {
        return userService.getUserInfo(userId);
    }

    @PutMapping("/info")
    public Result<User> updateUserInfo(@RequestBody User user) {
        return userService.updateUserInfo(user);
    }

    @PutMapping("/password")
    public Result<Void> updatePassword(@RequestParam Long userId, @RequestParam String oldPassword, @RequestParam String newPassword) {
        return userService.updatePassword(userId, oldPassword, newPassword);
    }

    @GetMapping("/hot")
    public List<User> getHotUsers(@RequestParam(required = false) Long userId, @RequestParam(defaultValue = "10") Integer limit) {
        return userService.getHotUsers(userId, limit);
    }

    @GetMapping("/search")
    public List<User> searchUsers(@RequestParam String keyword) {
        return userService.searchUsers(keyword);
    }

    @PostMapping("/follow/{followUserId}")
    public Result<Void> follow(@RequestParam Long userId, @PathVariable Long followUserId) {
        return userService.follow(userId, followUserId);
    }

    @DeleteMapping("/follow/{followUserId}")
    public Result<Void> unfollow(@RequestParam Long userId, @PathVariable Long followUserId) {
        return userService.unfollow(userId, followUserId);
    }

    @PutMapping("/follow/{followUserId}/special")
    public Result<Void> setSpecialFollow(@RequestParam Long userId, @PathVariable Long followUserId, @RequestParam Boolean isSpecial) {
        return userService.setSpecialFollow(userId, followUserId, isSpecial);
    }

    @GetMapping("/{userId}/following")
    public Result<List<User>> getFollowingList(@PathVariable Long userId) {
        return userService.getFollowingList(userId);
    }

    @GetMapping("/{userId}/fans")
    public Result<List<User>> getFansList(@PathVariable Long userId) {
        return userService.getFansList(userId);
    }

    @GetMapping("/{userId}/following/special")
    public Result<List<User>> getSpecialFollowingList(@PathVariable Long userId) {
        return userService.getSpecialFollowingList(userId);
    }
}
