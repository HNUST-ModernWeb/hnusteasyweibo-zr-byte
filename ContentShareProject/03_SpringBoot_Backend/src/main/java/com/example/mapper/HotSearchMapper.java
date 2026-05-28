package com.example.mapper;

import com.example.entity.HotSearch;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface HotSearchMapper {
    @Select("SELECT * FROM hot_search WHERE is_blocked = 0 ORDER BY search_count DESC, update_time DESC LIMIT #{limit}")
    List<HotSearch> findHotSearches(Integer limit);

    @Select("SELECT * FROM hot_search WHERE category = #{category} AND is_blocked = 0 ORDER BY search_count DESC, update_time DESC LIMIT #{limit}")
    List<HotSearch> findByCategory(@Param("category") String category, @Param("limit") Integer limit);

    @Update("UPDATE hot_search SET search_count = search_count + 1, update_time = NOW() WHERE keyword = #{keyword}")
    Integer incrementSearchCount(String keyword);

    @Select("SELECT * FROM hot_search WHERE keyword = #{keyword}")
    HotSearch findByKeyword(String keyword);

    @Insert("INSERT INTO hot_search (keyword, search_count, rank, category, create_time) VALUES (#{keyword}, 1, #{rank}, #{category}, NOW()) ON DUPLICATE KEY UPDATE search_count = search_count + 1, update_time = NOW()")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    Integer insertOrUpdate(HotSearch hotSearch);

    @Update("UPDATE hot_search SET rank = #{rank} WHERE id = #{id}")
    Integer updateRank(@Param("id") Long id, @Param("rank") Integer rank);

    @Update("UPDATE hot_search SET is_blocked = 1 WHERE id = #{id}")
    Integer block(Long id);

    @Select("SELECT * FROM hot_search ORDER BY search_count DESC LIMIT 50")
    List<HotSearch> getAllRanked();
}
