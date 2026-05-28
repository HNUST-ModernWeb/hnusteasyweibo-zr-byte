package com.example.service;

import com.example.entity.UserSettings;
import com.example.utils.Result;

public interface SettingsService {
    Result<UserSettings> getUserSettings(Long userId);
    Result<Void> updateUserSettings(UserSettings settings);
}
