package com.example.service.impl;

import com.example.entity.User;
import com.example.entity.Follow;
import com.example.mapper.UserMapper;
import com.example.mapper.FollowMapper;
import com.example.service.UserService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private FollowMapper followMapper;

    @Override
    @Transactional
    public Result<User> register(String username, String password, String nickname) {
        if (userMapper.findByUsername(username) != null) {
            return Result.fail("用户名已存在");
        }
        User user = new User();
        user.setUsername(username);
        user.setPassword(md5(password));
        user.setNickname(nickname != null ? nickname : username);
        user.setStatus(1);
        user.setFollowCount(0);
        user.setFansCount(0);
        user.setArticleCount(0);
        user.setLikeCount(0);
        userMapper.insert(user);
        return Result.success(user);
    }

    @Override
    public Result<User> login(String username, String password, String ip) {
        User user = userMapper.findByUsername(username);
        if (user == null) {
            return Result.fail("用户不存在");
        }
        if (!user.getPassword().equals(md5(password))) {
            return Result.fail("密码错误");
        }
        if (user.getStatus() != null && user.getStatus() != 1) {
            return Result.fail("账号已被禁用");
        }
        return Result.success(user);
    }

    private String md5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Result<User> getUserInfo(Long userId) {
        User user = userMapper.findById(userId);
        if (user == null) {
            return Result.fail("用户不存在");
        }
        // 实时计算粉丝数和关注数，确保数据一致性
        int followCount = followMapper.countFollowing(userId);
        int fansCount = followMapper.countFans(userId);
        user.setFollowCount(followCount);
        user.setFansCount(fansCount);
        return Result.success(user);
    }

    @Override
    public Result<User> updateUserInfo(User user) {
        User existingUser = userMapper.findById(user.getId());
        if (existingUser == null) {
            return Result.fail("用户不存在");
        }
        userMapper.update(user);
        return Result.success(userMapper.findById(user.getId()));
    }

    @Override
    @Transactional
    public Result<Void> updatePassword(Long userId, String oldPassword, String newPassword) {
        User user = userMapper.findById(userId);
        if (user == null) {
            return Result.fail("用户不存在");
        }
        if (!user.getPassword().equals(oldPassword)) {
            return Result.fail("原密码错误");
        }
        userMapper.updatePassword(userId, newPassword);
        return Result.success();
    }

    @Override
    public List<User> getHotUsers(Long userId, Integer limit) {
        List<User> users = userMapper.findHotUsers(limit);
        if (userId != null) {
            for (User user : users) {
                Follow follow = followMapper.findByUserAndFollowUser(userId, user.getId());
                user.setIsFollowing(follow != null);
            }
        }
        return users;
    }

    @Override
    public List<User> searchUsers(String keyword) {
        return userMapper.searchUsers(keyword);
    }

    @Override
    @Transactional
    public Result<Void> follow(Long userId, Long followUserId) {
        if (userId.equals(followUserId)) {
            return Result.fail("不能关注自己");
        }
        User followUser = userMapper.findById(followUserId);
        if (followUser == null) {
            return Result.fail("用户不存在");
        }
        Follow existingFollow = followMapper.findByUserAndFollowUser(userId, followUserId);
        if (existingFollow != null) {
            return Result.fail("已关注");
        }
        followMapper.insert(userId, followUserId, 0);
        userMapper.updateFollowCount(userId, 1);
        userMapper.updateFansCount(followUserId, 1);
        return Result.success();
    }

    @Override
    @Transactional
    public Result<Void> unfollow(Long userId, Long followUserId) {
        Follow existingFollow = followMapper.findByUserAndFollowUser(userId, followUserId);
        if (existingFollow == null) {
            return Result.fail("未关注");
        }
        followMapper.delete(userId, followUserId);
        userMapper.updateFollowCount(userId, -1);
        userMapper.updateFansCount(followUserId, -1);
        return Result.success();
    }

    @Override
    public Result<Void> setSpecialFollow(Long userId, Long followUserId, Boolean isSpecial) {
        Follow existingFollow = followMapper.findByUserAndFollowUser(userId, followUserId);
        if (existingFollow == null) {
            return Result.fail("未关注");
        }
        followMapper.updateSpecial(userId, followUserId, isSpecial ? 1 : 0);
        return Result.success();
    }

    @Override
    public Result<List<User>> getFollowingList(Long userId) {
        List<Follow> follows = followMapper.findFollowingList(userId);
        List<User> users = follows.stream()
                .map(f -> {
                    return userMapper.findById(f.getFollowUserId());
                })
                .filter(u -> u != null)
                .collect(Collectors.toList());
        return Result.success(users);
    }

    @Override
    public Result<List<User>> getFansList(Long userId) {
        List<Follow> follows = followMapper.findFansList(userId);
        List<User> users = follows.stream()
                .map(f -> {
                    return userMapper.findById(f.getUserId());
                })
                .filter(u -> u != null)
                .collect(Collectors.toList());
        return Result.success(users);
    }

    @Override
    public Result<List<User>> getSpecialFollowingList(Long userId) {
        List<Follow> follows = followMapper.findSpecialFollowingList(userId);
        List<User> users = follows.stream()
                .map(f -> {
                    return userMapper.findById(f.getFollowUserId());
                })
                .filter(u -> u != null)
                .collect(Collectors.toList());
        return Result.success(users);
    }
}
