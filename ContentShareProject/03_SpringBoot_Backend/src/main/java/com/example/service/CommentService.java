package com.example.service;

import com.example.entity.Comment;
import com.example.utils.Result;
import java.util.List;

public interface CommentService {
    Result<Comment> addComment(Long articleId, Long userId, Long parentId, Long replyId, String content);
    Result<Void> deleteComment(Long commentId, Long userId);
    Result<List<Comment>> getArticleComments(Long articleId);
    Result<List<Comment>> getCommentReplies(Long commentId);
    Result<Void> likeComment(Long userId, Long commentId);
}
