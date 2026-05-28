package com.example.mapper;

import com.example.entity.SearchHistory;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface SearchHistoryMapper {
    @Select("SELECT * FROM search_history WHERE user_id = #{userId} ORDER BY create_time DESC LIMIT #{limit}")
    List<SearchHistory> findByUserId(@Param("userId") Long userId, @Param("limit") Integer limit);

    @Insert("INSERT INTO search_history (user_id, keyword, create_time) VALUES (#{userId}, #{keyword}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insert(SearchHistory searchHistory);

    @Delete("DELETE FROM search_history WHERE user_id = #{userId}")
    Integer deleteByUserId(Long userId);

    @Delete("DELETE FROM search_history WHERE user_id = #{userId} AND id = #{id}")
    Integer deleteById(@Param("userId") Long userId, @Param("id") Long id);
}
