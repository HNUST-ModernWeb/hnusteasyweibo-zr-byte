package com.example.controller;

import com.example.entity.Article;
import com.example.service.ArticleService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/article")
@CrossOrigin
public class ArticleController {

    @Autowired
    private ArticleService articleService;

    @PostMapping("/publish")
    public Result<Article> publishArticle(@RequestBody Article article) {
        return articleService.publishArticle(article);
    }

    @PutMapping("/update")
    public Result<Article> updateArticle(@RequestBody Article article) {
        return articleService.updateArticle(article);
    }

    @DeleteMapping("/{articleId}")
    public Result<Void> deleteArticle(@PathVariable Long articleId, @RequestParam Long userId) {
        return articleService.deleteArticle(articleId, userId);
    }

    @GetMapping("/{articleId}")
    public Result<Article> getArticleById(@PathVariable Long articleId, @RequestParam(required = false) Long userId) {
        return articleService.getArticleById(articleId, userId);
    }

    @GetMapping("/feed/follow")
    public Result<List<Article>> getFollowFeed(@RequestParam Long userId, @RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer limit) {
        return articleService.getFollowFeed(userId, page, limit);
    }

    @GetMapping("/feed/hot")
    public Result<List<Article>> getHotFeed(@RequestParam(required = false) Long userId, @RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer limit) {
        return articleService.getHotFeed(userId, page, limit);
    }

    @GetMapping("/feed/nearby")
    public Result<List<Article>> getNearbyFeed(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer limit) {
        return articleService.getNearbyFeed(page, limit);
    }

    @GetMapping("/feed/recommend")
    public Result<List<Article>> getRecommendFeed(@RequestParam Long userId, @RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer limit) {
        return articleService.getRecommendFeed(userId, page, limit);
    }

    @GetMapping("/user/{userId}")
    public Result<List<Article>> getUserArticles(@PathVariable Long userId, @RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer limit) {
        return articleService.getUserArticles(userId, page, limit);
    }

    @GetMapping("/topic/{topicId}")
    public Result<List<Article>> getTopicArticles(@PathVariable Long topicId, @RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer limit) {
        return articleService.getTopicArticles(topicId, page, limit);
    }

    @GetMapping("/search")
    public Result<List<Article>> searchArticles(@RequestParam String keyword, @RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer limit) {
        return articleService.searchArticles(keyword, page, limit);
    }

    @PostMapping("/like/{articleId}")
    public Result<Void> likeArticle(@RequestParam Long userId, @PathVariable Long articleId) {
        return articleService.likeArticle(userId, articleId);
    }

    @DeleteMapping("/like/{articleId}")
    public Result<Void> unlikeArticle(@RequestParam Long userId, @PathVariable Long articleId) {
        return articleService.unlikeArticle(userId, articleId);
    }

    @PostMapping("/favorite/{articleId}")
    public Result<Void> favoriteArticle(@RequestParam Long userId, @PathVariable Long articleId) {
        return articleService.favoriteArticle(userId, articleId);
    }

    @DeleteMapping("/favorite/{articleId}")
    public Result<Void> unfavoriteArticle(@RequestParam Long userId, @PathVariable Long articleId) {
        return articleService.unfavoriteArticle(userId, articleId);
    }

    @GetMapping("/liked")
    public Result<List<Article>> getLikedArticles(@RequestParam Long userId) {
        return articleService.getLikedArticles(userId);
    }

    @GetMapping("/favorited")
    public Result<List<Article>> getFavoriteArticles(@RequestParam Long userId) {
        return articleService.getFavoriteArticles(userId);
    }

    @PostMapping("/forward/{articleId}")
    public Result<Void> forwardArticle(@RequestParam Long userId, @PathVariable Long articleId, @RequestParam(required = false) String content) {
        return articleService.forwardArticle(userId, articleId, content);
    }
}
