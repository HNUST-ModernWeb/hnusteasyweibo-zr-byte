package com.example.service;

import com.example.entity.Article;
import com.example.utils.Result;
import java.util.List;

public interface ArticleService {
    Result<Article> publishArticle(Article article);
    Result<Article> updateArticle(Article article);
    Result<Void> deleteArticle(Long articleId, Long userId);
    Result<Article> getArticleById(Long articleId, Long userId);
    Result<List<Article>> getFollowFeed(Long userId, Integer page, Integer limit);
    Result<List<Article>> getHotFeed(Long userId, Integer page, Integer limit);
    Result<List<Article>> getNearbyFeed(Integer page, Integer limit);
    Result<List<Article>> getRecommendFeed(Long userId, Integer page, Integer limit);
    Result<List<Article>> getUserArticles(Long userId, Integer page, Integer limit);
    Result<List<Article>> getTopicArticles(Long topicId, Integer page, Integer limit);
    Result<List<Article>> searchArticles(String keyword, Integer page, Integer limit);
    Result<Void> likeArticle(Long userId, Long articleId);
    Result<Void> unlikeArticle(Long userId, Long articleId);
    Result<Void> favoriteArticle(Long userId, Long articleId);
    Result<Void> unfavoriteArticle(Long userId, Long articleId);
    Result<List<Article>> getLikedArticles(Long userId);
    Result<List<Article>> getFavoriteArticles(Long userId);
    Result<Void> forwardArticle(Long userId, Long articleId, String content);
}
