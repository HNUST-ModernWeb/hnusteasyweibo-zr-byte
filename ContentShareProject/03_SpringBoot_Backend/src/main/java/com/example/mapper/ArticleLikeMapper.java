package com.example.mapper;

import com.example.entity.Article;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ArticleLikeMapper {
    @Select("SELECT * FROM article_like WHERE user_id = #{userId} AND article_id = #{articleId}")
    Article findByUserAndArticle(@Param("userId") Long userId, @Param("articleId") Long articleId);

    @Select("SELECT a.* FROM article a INNER JOIN article_like al ON a.id = al.article_id WHERE al.user_id = #{userId} AND a.status = 1 ORDER BY al.create_time DESC")
    List<Article> findLikedArticles(Long userId);

    @Insert("INSERT INTO article_like (user_id, article_id, create_time) VALUES (#{userId}, #{articleId}, NOW())")
    Integer insert(@Param("userId") Long userId, @Param("articleId") Long articleId);

    @Delete("DELETE FROM article_like WHERE user_id = #{userId} AND article_id = #{articleId}")
    Integer delete(@Param("userId") Long userId, @Param("articleId") Long articleId);

    @Select("SELECT COUNT(*) FROM article_like WHERE user_id = #{userId}")
    Integer countByUserId(Long userId);
}
