USE content_share;

-- 查看现有用户
SELECT '现有用户：' AS info;
SELECT id, username, nickname FROM user ORDER BY id;

-- 查看现有文章数量和最大ID
SELECT '现有文章：' AS info;
SELECT COUNT(*) AS total, MAX(id) AS max_id FROM article WHERE status = 1;

-- 查看现有评论
SELECT '现有评论：' AS info;
SELECT COUNT(*) AS total FROM comment WHERE status = 1;

-- 查看现有点赞
SELECT '现有点赞：' AS info;
SELECT COUNT(*) AS total FROM article_like;

-- 查看现有收藏
SELECT '现有收藏：' AS info;
SELECT COUNT(*) AS total FROM favorite;