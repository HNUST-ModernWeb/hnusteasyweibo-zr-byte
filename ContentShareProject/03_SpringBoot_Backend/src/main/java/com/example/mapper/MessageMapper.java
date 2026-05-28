package com.example.mapper;

import com.example.entity.Message;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface MessageMapper {
    @Select("SELECT * FROM message WHERE id = #{id}")
    Message findById(Long id);

    @Select("SELECT * FROM message WHERE (from_user_id = #{userId} AND to_user_id = #{targetUserId}) OR (from_user_id = #{targetUserId} AND to_user_id = #{userId}) ORDER BY create_time ASC")
    List<Message> findConversation(@Param("userId") Long userId, @Param("targetUserId") Long targetUserId);

    @Insert("INSERT INTO message (from_user_id, to_user_id, content, message_type, create_time) VALUES (#{fromUserId}, #{toUserId}, #{content}, #{messageType}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insert(Message message);

    @Update("UPDATE message SET is_read = 1 WHERE to_user_id = #{userId} AND from_user_id = #{fromUserId}")
    Integer markAsRead(@Param("userId") Long userId, @Param("fromUserId") Long fromUserId);

    @Select("SELECT COUNT(*) FROM message WHERE to_user_id = #{userId} AND is_read = 0")
    Integer countUnread(Long userId);

    @Select("SELECT COUNT(*) FROM message WHERE from_user_id = #{fromUserId} AND to_user_id = #{toUserId} AND is_read = 0")
    Integer countUnreadFromUser(@Param("fromUserId") Long fromUserId, @Param("toUserId") Long toUserId);
}
