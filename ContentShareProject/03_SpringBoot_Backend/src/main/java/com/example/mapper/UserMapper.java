package com.example.mapper;

import com.example.entity.User;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface UserMapper {
    @Select("SELECT * FROM `user` WHERE id = #{id}")
    User findById(Long id);

    @Select("SELECT * FROM `user` WHERE username = #{username}")
    User findByUsername(String username);

    @Select("SELECT * FROM `user` WHERE status = 1 ORDER BY fans_count DESC LIMIT #{limit}")
    List<User> findHotUsers(Integer limit);

    @Select("SELECT * FROM `user` WHERE status = 1 AND (username LIKE CONCAT('%', #{keyword}, '%') OR nickname LIKE CONCAT('%', #{keyword}, '%'))")
    List<User> searchUsers(String keyword);

    @Insert("INSERT INTO `user` (username, password, nickname, follow_count, fans_count, article_count, like_count, status) VALUES (#{username}, #{password}, #{nickname}, #{followCount}, #{fansCount}, #{articleCount}, #{likeCount}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insert(User user);

    @Update("UPDATE `user` SET nickname = #{nickname}, bio = #{bio}, location = #{location}, gender = #{gender}, birthday = #{birthday}, avatar = #{avatar}, update_time = NOW() WHERE id = #{id}")
    Integer update(User user);

    @Update("UPDATE `user` SET password = #{password}, update_time = NOW() WHERE id = #{id}")
    Integer updatePassword(@Param("id") Long id, @Param("password") String password);

    @Update("UPDATE `user` SET follow_count = GREATEST(follow_count + #{delta}, 0) WHERE id = #{id}")
    Integer updateFollowCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Update("UPDATE `user` SET fans_count = GREATEST(fans_count + #{delta}, 0) WHERE id = #{id}")
    Integer updateFansCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Update("UPDATE `user` SET article_count = GREATEST(article_count + #{delta}, 0) WHERE id = #{id}")
    Integer updateArticleCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Update("UPDATE `user` SET like_count = GREATEST(like_count + #{delta}, 0) WHERE id = #{id}")
    Integer updateLikeCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Update("UPDATE `user` SET last_login_time = NOW(), last_login_ip = #{ip} WHERE id = #{id}")
    Integer updateLastLogin(@Param("id") Long id, @Param("ip") String ip);

    @Select("SELECT COUNT(*) FROM `user` WHERE (username = #{username} OR email = #{email} OR phone = #{phone})")
    Integer countByUsernameEmailPhone(@Param("username") String username, @Param("email") String email, @Param("phone") String phone);
}
