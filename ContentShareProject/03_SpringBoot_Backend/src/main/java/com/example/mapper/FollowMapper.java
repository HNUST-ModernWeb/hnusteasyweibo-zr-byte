package com.example.mapper;

import com.example.entity.Follow;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface FollowMapper {
    @Select("SELECT * FROM follow WHERE user_id = #{userId} AND follow_user_id = #{followUserId}")
    Follow findByUserAndFollowUser(@Param("userId") Long userId, @Param("followUserId") Long followUserId);

    @Select("SELECT f.id as follow_id, f.user_id, f.follow_user_id, f.is_special, f.create_time, u.id, u.username, u.nickname, u.avatar, u.bio FROM follow f LEFT JOIN user u ON f.follow_user_id = u.id WHERE f.user_id = #{userId} ORDER BY f.create_time DESC")
    List<Follow> findFollowingList(Long userId);

    @Select("SELECT f.id as follow_id, f.user_id, f.follow_user_id, f.is_special, f.create_time, u.id, u.username, u.nickname, u.avatar, u.bio FROM follow f LEFT JOIN user u ON f.user_id = u.id WHERE f.follow_user_id = #{followUserId} ORDER BY f.create_time DESC")
    List<Follow> findFansList(Long followUserId);

    @Select("SELECT COUNT(*) FROM follow WHERE user_id = #{userId}")
    Integer countFollowing(Long userId);

    @Select("SELECT COUNT(*) FROM follow WHERE follow_user_id = #{followUserId}")
    Integer countFans(Long followUserId);

    @Insert("INSERT INTO follow (user_id, follow_user_id, is_special, create_time) VALUES (#{userId}, #{followUserId}, #{isSpecial}, NOW())")
    Integer insert(@Param("userId") Long userId, @Param("followUserId") Long followUserId, @Param("isSpecial") Integer isSpecial);

    @Delete("DELETE FROM follow WHERE user_id = #{userId} AND follow_user_id = #{followUserId}")
    Integer delete(@Param("userId") Long userId, @Param("followUserId") Long followUserId);

    @Update("UPDATE follow SET is_special = #{isSpecial} WHERE user_id = #{userId} AND follow_user_id = #{followUserId}")
    Integer updateSpecial(@Param("userId") Long userId, @Param("followUserId") Long followUserId, @Param("isSpecial") Integer isSpecial);

    @Select("SELECT f.*, u.* FROM follow f LEFT JOIN user u ON f.follow_user_id = u.id WHERE f.user_id = #{userId} AND f.is_special = 1 ORDER BY f.create_time DESC")
    List<Follow> findSpecialFollowingList(Long userId);
}
