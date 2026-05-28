package com.example.mapper;

import com.example.entity.Article;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface FavoriteMapper {
    @Select("SELECT a.* FROM article a INNER JOIN favorite f ON a.id = f.article_id WHERE f.user_id = #{userId} AND a.status = 1 ORDER BY f.create_time DESC")
    List<Article> findByUserId(Long userId);

    @Insert("INSERT INTO favorite (user_id, article_id, create_time) VALUES (#{userId}, #{articleId}, NOW())")
    Integer insert(@Param("userId") Long userId, @Param("articleId") Long articleId);

    @Delete("DELETE FROM favorite WHERE user_id = #{userId} AND article_id = #{articleId}")
    Integer delete(@Param("userId") Long userId, @Param("articleId") Long articleId);

    @Select("SELECT COUNT(*) FROM favorite WHERE user_id = #{userId}")
    Integer countByUserId(Long userId);

    @Select("SELECT COUNT(*) FROM favorite WHERE user_id = #{userId} AND article_id = #{articleId}")
    Integer findByUserAndArticle(@Param("userId") Long userId, @Param("articleId") Long articleId);
}
