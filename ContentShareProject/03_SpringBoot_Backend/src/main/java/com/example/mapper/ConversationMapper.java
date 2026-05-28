package com.example.mapper;

import com.example.entity.Conversation;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ConversationMapper {
    @Select("SELECT c.*, u.* FROM conversation c LEFT JOIN user u ON c.target_user_id = u.id WHERE c.user_id = #{userId} ORDER BY c.last_message_time DESC")
    List<Conversation> findByUserId(Long userId);

    @Insert("INSERT INTO conversation (user_id, target_user_id, last_message_id, last_message_time, unread_count, create_time) VALUES (#{userId}, #{targetUserId}, #{lastMessageId}, #{lastMessageTime}, 0, NOW()) ON DUPLICATE KEY UPDATE last_message_id = #{lastMessageId}, last_message_time = #{lastMessageTime}")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insertOrUpdate(Conversation conversation);

    @Update("UPDATE conversation SET unread_count = #{unreadCount} WHERE user_id = #{userId} AND target_user_id = #{targetUserId}")
    Integer updateUnreadCount(@Param("userId") Long userId, @Param("targetUserId") Long targetUserId, @Param("unreadCount") Integer unreadCount);

    @Select("SELECT unread_count FROM conversation WHERE user_id = #{userId} AND target_user_id = #{targetUserId}")
    Integer getUnreadCount(@Param("userId") Long userId, @Param("targetUserId") Long targetUserId);
}
