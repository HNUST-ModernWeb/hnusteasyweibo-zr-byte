package com.example.controller;

import com.example.entity.Comment;
import com.example.service.CommentService;
import com.example.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/comment")
@CrossOrigin
public class CommentController {

    @Autowired
    private CommentService commentService;

    @PostMapping
    public Result<Comment> addComment(@RequestParam Long articleId, @RequestParam Long userId, @RequestParam(required = false) Long parentId, @RequestParam(required = false) Long replyId, @RequestParam String content) {
        return commentService.addComment(articleId, userId, parentId, replyId, content);
    }

    @DeleteMapping("/{commentId}")
    public Result<Void> deleteComment(@PathVariable Long commentId, @RequestParam Long userId) {
        return commentService.deleteComment(commentId, userId);
    }

    @GetMapping("/article/{articleId}")
    public Result<List<Comment>> getArticleComments(@PathVariable Long articleId) {
        return commentService.getArticleComments(articleId);
    }

    @GetMapping("/{commentId}/replies")
    public Result<List<Comment>> getCommentReplies(@PathVariable Long commentId) {
        return commentService.getCommentReplies(commentId);
    }

    @PostMapping("/{commentId}/like")
    public Result<Void> likeComment(@RequestParam Long userId, @PathVariable Long commentId) {
        return commentService.likeComment(userId, commentId);
    }
}
