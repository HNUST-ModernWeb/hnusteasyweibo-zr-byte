package com.example.service.impl;

import com.example.entity.UserSettings;
import com.example.mapper.UserSettingsMapper;
import com.example.service.SettingsService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SettingsServiceImpl implements SettingsService {

    @Autowired
    private UserSettingsMapper userSettingsMapper;

    @Override
    public Result<UserSettings> getUserSettings(Long userId) {
        UserSettings settings = userSettingsMapper.findByUserId(userId);
        if (settings == null) {
            settings = new UserSettings();
            settings.setUserId(userId);
            settings.setDarkMode(0);
            settings.setFontSize("medium");
            settings.setNoImageMode(0);
            settings.setAutoPlayVideo(1);
            userSettingsMapper.insert(settings);
        }
        return Result.success(settings);
    }

    @Override
    public Result<Void> updateUserSettings(UserSettings settings) {
        UserSettings existing = userSettingsMapper.findByUserId(settings.getUserId());
        if (existing == null) {
            userSettingsMapper.insert(settings);
        } else {
            userSettingsMapper.update(settings);
        }
        return Result.success();
    }
}
