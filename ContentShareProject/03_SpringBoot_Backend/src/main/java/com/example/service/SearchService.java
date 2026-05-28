package com.example.service;

import com.example.entity.HotSearch;
import com.example.entity.SearchHistory;
import com.example.utils.Result;
import java.util.List;

public interface SearchService {
    Result<List<HotSearch>> getHotSearches(String category, Integer limit);
    Result<List<SearchHistory>> getSearchHistory(Long userId, Integer limit);
    Result<Void> clearSearchHistory(Long userId);
    Result<Void> deleteSearchHistory(Long userId, Long historyId);
    Result<Void> addSearchKeyword(String keyword, String category);
}
