package com.example.mapper;

import com.example.entity.Topic;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface TopicMapper {
    @Select("SELECT * FROM topic WHERE id = #{id} AND status = 1")
    Topic findById(Long id);

    @Select("SELECT * FROM topic WHERE name = #{name} AND status = 1")
    Topic findByName(String name);

    @Select("SELECT * FROM topic WHERE status = 1 ORDER BY article_count DESC, 热度_score DESC LIMIT #{limit}")
    List<Topic> findHotTopics(Integer limit);

    @Select("SELECT * FROM topic WHERE status = 1 AND is_recommend = 1 ORDER BY 热度_score DESC")
    List<Topic> findRecommendTopics();

    @Select("SELECT * FROM topic WHERE status = 1 AND category = #{category} ORDER BY 热度_score DESC")
    List<Topic> findByCategory(String category);

    @Select("SELECT * FROM topic WHERE status = 1 AND (name LIKE CONCAT('%', #{keyword}, '%') OR description LIKE CONCAT('%', #{keyword}, '%'))")
    List<Topic> searchTopics(String keyword);

    @Insert("INSERT INTO topic (name, description, icon, cover_image, category, create_time) VALUES (#{name}, #{description}, #{icon}, #{coverImage}, #{category}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insert(Topic topic);

    @Update("UPDATE topic SET article_count = article_count + #{delta} WHERE id = #{id}")
    Integer updateArticleCount(@Param("id") Long id, @Param("delta") Integer delta);

    @Update("UPDATE topic SET participant_count = participant_count + #{delta} WHERE id = #{id}")
    Integer updateParticipantCount(@Param("id") Long id, @Param("delta") Integer delta);
}
