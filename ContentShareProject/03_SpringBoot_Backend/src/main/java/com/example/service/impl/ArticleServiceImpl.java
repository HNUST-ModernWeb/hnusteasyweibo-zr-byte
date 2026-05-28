package com.example.service.impl;

import com.example.entity.Article;
import com.example.entity.Follow;
import com.example.entity.User;
import com.example.mapper.*;
import com.example.service.ArticleService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class ArticleServiceImpl implements ArticleService {

    @Autowired
    private ArticleMapper articleMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ArticleLikeMapper articleLikeMapper;

    @Autowired
    private FavoriteMapper favoriteMapper;

    @Autowired
    private FollowMapper followMapper;

    @Override
    @Transactional
    public Result<Article> publishArticle(Article article) {
        User user = userMapper.findById(article.getUserId());
        if (user == null) {
            return Result.fail("用户不存在");
        }
        articleMapper.insert(article);
        userMapper.updateArticleCount(article.getUserId(), 1);
        return Result.success(article);
    }

    @Override
    public Result<Article> updateArticle(Article article) {
        Article existing = articleMapper.findById(article.getId());
        if (existing == null) {
            return Result.fail("文章不存在");
        }
        if (!existing.getUserId().equals(article.getUserId())) {
            return Result.fail("无权限修改");
        }
        articleMapper.update(article);
        return Result.success(articleMapper.findById(article.getId()));
    }

    @Override
    @Transactional
    public Result<Void> deleteArticle(Long articleId, Long userId) {
        Article article = articleMapper.findById(articleId);
        if (article == null) {
            return Result.fail("文章不存在");
        }
        if (!article.getUserId().equals(userId)) {
            return Result.fail("无权限删除");
        }
        articleMapper.delete(articleId, userId);
        userMapper.updateArticleCount(userId, -1);
        return Result.success();
    }

    @Override
    public Result<Article> getArticleById(Long articleId, Long userId) {
        Article article = articleMapper.findById(articleId);
        if (article == null) {
            return Result.fail("文章不存在");
        }
        User user = userMapper.findById(article.getUserId());
        article.setUser(user);
        if (userId != null) {
            article.setIsLiked(articleLikeMapper.findByUserAndArticle(userId, articleId) != null);
            article.setIsFavorited(favoriteMapper.findByUserAndArticle(userId, articleId) != null);
        }
        return Result.success(article);
    }

    @Override
    public Result<List<Article>> getFollowFeed(Long userId, Integer page, Integer limit) {
        int offset = (page - 1) * limit;
        List<Article> articles = articleMapper.findFollowFeed(userId, offset, limit);
        fillArticleDetails(articles, userId);
        return Result.success(articles);
    }

    @Override
    public Result<List<Article>> getHotFeed(Long userId, Integer page, Integer limit) {
        try {
            int offset = (page - 1) * limit;
            List<Article> articles = articleMapper.findHotFeed(offset, limit);
            fillArticleDetails(articles, userId);
            return Result.success(articles);
        } catch (Exception e) {
            System.out.println("=== getHotFeed Error ===");
            e.printStackTrace();
            return Result.fail("获取热门文章失败: " + e.getMessage());
        }
    }

    @Override
    public Result<List<Article>> getNearbyFeed(Integer page, Integer limit) {
        try {
            int offset = (page - 1) * limit;
            List<Article> articles = articleMapper.findNearbyFeed(offset, limit);
            fillArticleDetails(articles, null);
            return Result.success(articles);
        } catch (Exception e) {
            System.out.println("=== getNearbyFeed Error ===");
            e.printStackTrace();
            return Result.fail("获取同城文章失败: " + e.getMessage());
        }
    }

    @Override
    public Result<List<Article>> getRecommendFeed(Long userId, Integer page, Integer limit) {
        int offset = (page - 1) * limit;
        List<Article> articles = articleMapper.findRecommendFeed(userId, offset, limit);
        fillArticleDetails(articles, userId);
        return Result.success(articles);
    }

    @Override
    public Result<List<Article>> getUserArticles(Long userId, Integer page, Integer limit) {
        int offset = (page - 1) * limit;
        List<Article> articles = articleMapper.findByUserId(userId, offset, limit);
        fillArticleDetails(articles, userId);
        return Result.success(articles);
    }

    @Override
    public Result<List<Article>> getTopicArticles(Long topicId, Integer page, Integer limit) {
        int offset = (page - 1) * limit;
        List<Article> articles = articleMapper.findByTopicId(topicId, offset, limit);
        return Result.success(articles);
    }

    @Override
    public Result<List<Article>> searchArticles(String keyword, Integer page, Integer limit) {
        int offset = (page - 1) * limit;
        List<Article> articles = articleMapper.searchArticles(keyword, offset, limit);
        return Result.success(articles);
    }

    @Override
    @Transactional
    public Result<Void> likeArticle(Long userId, Long articleId) {
        Article article = articleMapper.findById(articleId);
        if (article == null) {
            return Result.fail("文章不存在");
        }
        if (articleLikeMapper.findByUserAndArticle(userId, articleId) != null) {
            return Result.fail("已点赞");
        }
        articleLikeMapper.insert(userId, articleId);
        articleMapper.updateLikeCount(articleId, 1);
        userMapper.updateLikeCount(article.getUserId(), 1);
        return Result.success();
    }

    @Override
    @Transactional
    public Result<Void> unlikeArticle(Long userId, Long articleId) {
        Article article = articleMapper.findById(articleId);
        if (article == null) {
            return Result.fail("文章不存在");
        }
        if (articleLikeMapper.findByUserAndArticle(userId, articleId) == null) {
            return Result.fail("未点赞");
        }
        articleLikeMapper.delete(userId, articleId);
        articleMapper.updateLikeCount(articleId, -1);
        userMapper.updateLikeCount(article.getUserId(), -1);
        return Result.success();
    }

    @Override
    @Transactional
    public Result<Void> favoriteArticle(Long userId, Long articleId) {
        Article article = articleMapper.findById(articleId);
        if (article == null) {
            return Result.fail("文章不存在");
        }
        if (favoriteMapper.findByUserAndArticle(userId, articleId) != null) {
            return Result.fail("已收藏");
        }
        favoriteMapper.insert(userId, articleId);
        articleMapper.updateFavoriteCount(articleId, 1);
        return Result.success();
    }

    @Override
    @Transactional
    public Result<Void> unfavoriteArticle(Long userId, Long articleId) {
        Article article = articleMapper.findById(articleId);
        if (article == null) {
            return Result.fail("文章不存在");
        }
        if (favoriteMapper.findByUserAndArticle(userId, articleId) == null) {
            return Result.fail("未收藏");
        }
        favoriteMapper.delete(userId, articleId);
        articleMapper.updateFavoriteCount(articleId, -1);
        return Result.success();
    }

    @Override
    public Result<List<Article>> getLikedArticles(Long userId) {
        List<Article> articles = articleLikeMapper.findLikedArticles(userId);
        return Result.success(articles);
    }

    @Override
    public Result<List<Article>> getFavoriteArticles(Long userId) {
        List<Article> articles = favoriteMapper.findByUserId(userId);
        return Result.success(articles);
    }

    @Override
    @Transactional
    public Result<Void> forwardArticle(Long userId, Long articleId, String content) {
        Article article = articleMapper.findById(articleId);
        if (article == null) {
            return Result.fail("原文章不存在");
        }
        articleMapper.updateForwardCount(articleId, 1);
        return Result.success();
    }

    private void fillArticleDetails(List<Article> articles, Long userId) {
        for (Article article : articles) {
            User user = userMapper.findById(article.getUserId());
            if (user != null) {
                if (userId != null) {
                    Follow follow = followMapper.findByUserAndFollowUser(userId, user.getId());
                    user.setIsFollowing(follow != null);
                }
                article.setUser(user);
            }
            if (userId != null) {
                article.setIsLiked(articleLikeMapper.findByUserAndArticle(userId, article.getId()) != null);
                article.setIsFavorited(favoriteMapper.findByUserAndArticle(userId, article.getId()) != null);
            }
        }
    }
}
