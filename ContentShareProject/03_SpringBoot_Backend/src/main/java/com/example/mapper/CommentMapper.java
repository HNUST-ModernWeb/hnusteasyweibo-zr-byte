package com.example.mapper;

import com.example.entity.Comment;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface CommentMapper {
    @Select("SELECT * FROM comment WHERE id = #{id} AND status = 1")
    Comment findById(Long id);

    @Select("SELECT * FROM comment WHERE article_id = #{articleId} AND status = 1 AND parent_id = 0 ORDER BY create_time DESC")
    List<Comment> findByArticleId(Long articleId);

    @Select("SELECT * FROM comment WHERE parent_id = #{parentId} AND status = 1 ORDER BY create_time ASC")
    List<Comment> findReplies(Long parentId);

    @Insert("INSERT INTO comment (article_id, user_id, parent_id, reply_id, content, create_time) VALUES (#{articleId}, #{userId}, #{parentId}, #{replyId}, #{content}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insert(Comment comment);

    @Update("UPDATE comment SET status = 0 WHERE id = #{id} AND user_id = #{userId}")
    Integer delete(@Param("id") Long id, @Param("userId") Long userId);

    @Update("UPDATE comment SET like_count = like_count + #{delta} WHERE id = #{id}")
    Integer updateLikeCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Select("SELECT COUNT(*) FROM comment WHERE article_id = #{articleId} AND status = 1")
    Integer countByArticleId(Long articleId);
}
