package com.example.mapper;

import com.example.entity.Article;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ArticleMapper {
    @Select("SELECT * FROM article WHERE id = #{id} AND status = 1")
    Article findById(Long id);

    @Select("SELECT * FROM article WHERE user_id = #{userId} AND status = 1 ORDER BY create_time DESC LIMIT #{offset}, #{limit}")
    List<Article> findByUserId(@Param("userId") Long userId, @Param("offset") Integer offset, @Param("limit") Integer limit);

    @Select("SELECT a.* FROM article a LEFT JOIN follow f ON a.user_id = f.follow_user_id WHERE f.user_id = #{userId} AND a.status = 1 ORDER BY a.create_time DESC LIMIT #{offset}, #{limit}")
    List<Article> findFollowFeed(@Param("userId") Long userId, @Param("offset") Integer offset, @Param("limit") Integer limit);

    @Select("SELECT * FROM article WHERE status = 1 ORDER BY like_count DESC, create_time DESC LIMIT #{offset}, #{limit}")
    List<Article> findHotFeed(@Param("offset") Integer offset, @Param("limit") Integer limit);

    @Select("SELECT * FROM article WHERE status = 1 AND location IS NOT NULL ORDER BY create_time DESC LIMIT #{offset}, #{limit}")
    List<Article> findNearbyFeed(@Param("offset") Integer offset, @Param("limit") Integer limit);

    @Select("SELECT a.* FROM article a WHERE a.status = 1 AND a.user_id != #{userId} ORDER BY like_count DESC, view_count DESC, create_time DESC LIMIT #{offset}, #{limit}")
    List<Article> findRecommendFeed(@Param("userId") Long userId, @Param("offset") Integer offset, @Param("limit") Integer limit);

    @Select("SELECT a.* FROM article a INNER JOIN article_topic at ON a.id = at.article_id WHERE at.topic_id = #{topicId} AND a.status = 1 ORDER BY a.create_time DESC LIMIT #{offset}, #{limit}")
    List<Article> findByTopicId(@Param("topicId") Long topicId, @Param("offset") Integer offset, @Param("limit") Integer limit);

    @Select("SELECT * FROM article WHERE status = 1 AND (content LIKE CONCAT('%', #{keyword}, '%')) ORDER BY create_time DESC LIMIT #{offset}, #{limit}")
    List<Article> searchArticles(@Param("keyword") String keyword, @Param("offset") Integer offset, @Param("limit") Integer limit);

    @Insert("INSERT INTO article (user_id, content, images, video, location, latitude, longitude, article_type, topic_id, vote_title, vote_options, vote_end_time, activity_time, activity_location, like_count, comment_count, forward_count, favorite_count, share_count, view_count, status, create_time) VALUES (#{userId}, #{content}, #{images}, #{video}, #{location}, #{latitude}, #{longitude}, #{articleType}, #{topicId}, #{voteTitle}, #{voteOptions}, #{voteEndTime}, #{activityTime}, #{activityLocation}, 0, 0, 0, 0, 0, 0, 1, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insert(Article article);

    @Update("UPDATE article SET content = #{content}, images = #{images}, video = #{video}, location = #{location}, update_time = NOW() WHERE id = #{id} AND user_id = #{userId}")
    Integer update(Article article);

    @Update("UPDATE article SET status = 0, update_time = NOW() WHERE id = #{id} AND user_id = #{userId}")
    Integer delete(@Param("id") Long id, @Param("userId") Long userId);

    @Update("UPDATE article SET like_count = GREATEST(like_count + #{delta}, 0) WHERE id = #{id}")
    Integer updateLikeCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Update("UPDATE article SET comment_count = GREATEST(comment_count + #{delta}, 0) WHERE id = #{id}")
    Integer updateCommentCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Update("UPDATE article SET forward_count = GREATEST(forward_count + #{delta}, 0) WHERE id = #{id}")
    Integer updateForwardCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Update("UPDATE article SET favorite_count = GREATEST(favorite_count + #{delta}, 0) WHERE id = #{id}")
    Integer updateFavoriteCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Select("SELECT COUNT(*) FROM article WHERE user_id = #{userId} AND status = 1")
    Integer countByUserId(Long userId);
}
