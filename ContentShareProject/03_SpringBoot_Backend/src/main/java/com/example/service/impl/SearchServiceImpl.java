package com.example.service.impl;

import com.example.entity.HotSearch;
import com.example.entity.SearchHistory;
import com.example.mapper.HotSearchMapper;
import com.example.mapper.SearchHistoryMapper;
import com.example.service.SearchService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class SearchServiceImpl implements SearchService {

    @Autowired
    private HotSearchMapper hotSearchMapper;

    @Autowired
    private SearchHistoryMapper searchHistoryMapper;

    @Override
    public Result<List<HotSearch>> getHotSearches(String category, Integer limit) {
        List<HotSearch> hotSearches;
        if (category != null && !category.isEmpty()) {
            hotSearches = hotSearchMapper.findByCategory(category, limit);
        } else {
            hotSearches = hotSearchMapper.findHotSearches(limit);
        }
        return Result.success(hotSearches);
    }

    @Override
    public Result<List<SearchHistory>> getSearchHistory(Long userId, Integer limit) {
        List<SearchHistory> histories = searchHistoryMapper.findByUserId(userId, limit);
        return Result.success(histories);
    }

    @Override
    public Result<Void> clearSearchHistory(Long userId) {
        searchHistoryMapper.deleteByUserId(userId);
        return Result.success();
    }

    @Override
    public Result<Void> deleteSearchHistory(Long userId, Long historyId) {
        searchHistoryMapper.deleteById(userId, historyId);
        return Result.success();
    }

    @Override
    public Result<Void> addSearchKeyword(String keyword, String category) {
        // 先尝试更新现有关键词的搜索次数
        int updated = hotSearchMapper.incrementSearchCount(keyword);
        
        // 如果没有找到现有关键词，则插入新的
        if (updated == 0) {
            HotSearch hotSearch = new HotSearch();
            hotSearch.setKeyword(keyword);
            hotSearch.setSearchCount(1);
            hotSearch.setCategory(category != null ? category : "real_time");
            
            // 获取当前最大排名
            List<HotSearch> existingSearches = hotSearchMapper.getAllRanked();
            int rank = existingSearches.size() + 1;
            hotSearch.setRank(rank);
            
            hotSearchMapper.insertOrUpdate(hotSearch);
        }
        return Result.success();
    }
}
