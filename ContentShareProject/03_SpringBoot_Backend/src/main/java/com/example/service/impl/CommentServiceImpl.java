package com.example.service.impl;

import com.example.entity.Comment;
import com.example.entity.User;
import com.example.mapper.CommentMapper;
import com.example.mapper.UserMapper;
import com.example.mapper.ArticleMapper;
import com.example.service.CommentService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentMapper commentMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private ArticleMapper articleMapper;

    @Override
    @Transactional
    public Result<Comment> addComment(Long articleId, Long userId, Long parentId, Long replyId, String content) {
        if (articleMapper.findById(articleId) == null) {
            return Result.fail("文章不存在");
        }
        User user = userMapper.findById(userId);
        if (user == null) {
            return Result.fail("用户不存在");
        }
        Comment comment = new Comment();
        comment.setArticleId(articleId);
        comment.setUserId(userId);
        comment.setParentId(parentId != null ? parentId : 0);
        comment.setReplyId(replyId != null ? replyId : 0);
        comment.setContent(content);
        commentMapper.insert(comment);
        articleMapper.updateCommentCount(articleId, 1);
        comment.setUser(user);
        if (replyId != null && replyId > 0) {
            Comment replyComment = commentMapper.findById(replyId);
            if (replyComment != null) {
                User replyUser = userMapper.findById(replyComment.getUserId());
                comment.setReplyUsername(replyUser.getUsername());
                comment.setReplyNickname(replyUser.getNickname());
            }
        }
        return Result.success(comment);
    }

    @Override
    @Transactional
    public Result<Void> deleteComment(Long commentId, Long userId) {
        Comment comment = commentMapper.findById(commentId);
        if (comment == null) {
            return Result.fail("评论不存在");
        }
        if (!comment.getUserId().equals(userId)) {
            return Result.fail("无权限删除");
        }
        commentMapper.delete(commentId, userId);
        articleMapper.updateCommentCount(comment.getArticleId(), -1);
        return Result.success();
    }

    @Override
    public Result<List<Comment>> getArticleComments(Long articleId) {
        List<Comment> comments = commentMapper.findByArticleId(articleId);
        for (Comment comment : comments) {
            User user = userMapper.findById(comment.getUserId());
            comment.setUser(user);
        }
        return Result.success(comments);
    }

    @Override
    public Result<List<Comment>> getCommentReplies(Long commentId) {
        List<Comment> replies = commentMapper.findReplies(commentId);
        for (Comment reply : replies) {
            User user = userMapper.findById(reply.getUserId());
            reply.setUser(user);
        }
        return Result.success(replies);
    }

    @Override
    @Transactional
    public Result<Void> likeComment(Long userId, Long commentId) {
        Comment comment = commentMapper.findById(commentId);
        if (comment == null) {
            return Result.fail("评论不存在");
        }
        commentMapper.updateLikeCount(commentId, 1);
        return Result.success();
    }
}
