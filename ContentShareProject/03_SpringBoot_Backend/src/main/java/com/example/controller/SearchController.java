package com.example.controller;

import com.example.entity.HotSearch;
import com.example.entity.SearchHistory;
import com.example.service.SearchService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/search")
@CrossOrigin
public class SearchController {

    @Autowired
    private SearchService searchService;

    @GetMapping("/hot")
    public Result<List<HotSearch>> getHotSearches(@RequestParam(required = false) String category, @RequestParam(defaultValue = "20") Integer limit) {
        return searchService.getHotSearches(category, limit);
    }

    @GetMapping("/history")
    public Result<List<SearchHistory>> getSearchHistory(@RequestParam Long userId, @RequestParam(defaultValue = "20") Integer limit) {
        return searchService.getSearchHistory(userId, limit);
    }

    @DeleteMapping("/history")
    public Result<Void> clearSearchHistory(@RequestParam Long userId) {
        return searchService.clearSearchHistory(userId);
    }

    @DeleteMapping("/history/{historyId}")
    public Result<Void> deleteSearchHistory(@RequestParam Long userId, @PathVariable Long historyId) {
        return searchService.deleteSearchHistory(userId, historyId);
    }

    @PostMapping("/keyword")
    public Result<Void> addSearchKeyword(@RequestParam String keyword, @RequestParam(required = false) String category) {
        return searchService.addSearchKeyword(keyword, category);
    }
}
