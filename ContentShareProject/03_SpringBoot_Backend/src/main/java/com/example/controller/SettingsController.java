package com.example.controller;

import com.example.entity.UserSettings;
import com.example.service.SettingsService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/settings")
@CrossOrigin
public class SettingsController {

    @Autowired
    private SettingsService settingsService;

    @GetMapping
    public Result<UserSettings> getUserSettings(@RequestParam Long userId) {
        return settingsService.getUserSettings(userId);
    }

    @PutMapping
    public Result<Void> updateUserSettings(@RequestBody UserSettings settings) {
        return settingsService.updateUserSettings(settings);
    }
}
