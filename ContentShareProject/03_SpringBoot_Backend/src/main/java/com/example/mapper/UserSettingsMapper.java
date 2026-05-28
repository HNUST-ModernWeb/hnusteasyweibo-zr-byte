package com.example.mapper;

import com.example.entity.UserSettings;
import org.apache.ibatis.annotations.*;

@Mapper
public interface UserSettingsMapper {
    @Select("SELECT * FROM user_settings WHERE user_id = #{userId}")
    UserSettings findByUserId(Long userId);

    @Insert("INSERT INTO user_settings (user_id, dark_mode, font_size, no_image_mode, auto_play_video, create_time) VALUES (#{userId}, #{darkMode}, #{fontSize}, #{noImageMode}, #{autoPlayVideo}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insert(UserSettings userSettings);

    @Update("UPDATE user_settings SET dark_mode = #{darkMode}, font_size = #{fontSize}, no_image_mode = #{noImageMode}, auto_play_video = #{autoPlayVideo}, notification_settings = #{notificationSettings}, privacy_settings = #{privacySettings}, update_time = NOW() WHERE user_id = #{userId}")
    Integer update(UserSettings userSettings);
}
