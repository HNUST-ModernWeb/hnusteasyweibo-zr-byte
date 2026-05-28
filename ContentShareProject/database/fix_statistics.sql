USE content_share;

-- ============================================
-- 修复文章统计数据，确保与实际数据一致
-- ============================================

-- 更新文章的评论数为实际评论数量
UPDATE article a, 
(SELECT article_id, COUNT(*) AS cnt FROM comment WHERE status = 1 GROUP BY article_id) c 
SET a.comment_count = COALESCE(c.cnt, 0) 
WHERE a.id = c.article_id;

-- 更新文章的点赞数为实际点赞数量  
UPDATE article a,
(SELECT article_id, COUNT(*) AS cnt FROM article_like GROUP BY article_id) al
SET a.like_count = COALESCE(al.cnt, 0)
WHERE a.id = al.article_id;

-- 更新文章的收藏数为实际收藏数量
UPDATE article a,
(SELECT article_id, COUNT(*) AS cnt FROM favorite GROUP BY article_id) f
SET a.favorite_count = COALESCE(f.cnt, 0)
WHERE a.id = f.article_id;

-- 更新文章的转发数为实际转发数量
UPDATE article a,
(SELECT article_id, COUNT(*) AS cnt FROM forward GROUP BY article_id) fw
SET a.forward_count = COALESCE(fw.cnt, 0)
WHERE a.id = fw.article_id;

-- ============================================
-- 更新用户统计数据
-- ============================================

-- 更新用户的文章数
UPDATE user u,
(SELECT user_id, COUNT(*) AS cnt FROM article WHERE status = 1 GROUP BY user_id) a
SET u.article_count = COALESCE(a.cnt, 0)
WHERE u.id = a.user_id;

-- 更新用户的关注数
UPDATE user u,
(SELECT user_id, COUNT(*) AS cnt FROM follow GROUP BY user_id) f
SET u.follow_count = COALESCE(f.cnt, 0)
WHERE u.id = f.user_id;

-- 更新用户的粉丝数
UPDATE user u,
(SELECT follow_user_id, COUNT(*) AS cnt FROM follow GROUP BY follow_user_id) f
SET u.fans_count = COALESCE(f.cnt, 0)
WHERE u.id = f.follow_user_id;

-- 更新用户的获赞数（所有文章获得的点赞总和）
UPDATE user u,
(SELECT user_id, SUM(like_count) AS cnt FROM article WHERE status = 1 GROUP BY user_id) a
SET u.like_count = COALESCE(a.cnt, 0)
WHERE u.id = a.user_id;

-- ============================================
-- 更新话题统计数据
-- ============================================

-- 更新话题的文章数
UPDATE topic t,
(SELECT at.topic_id, COUNT(DISTINCT at.article_id) AS cnt FROM article_topic at INNER JOIN article a ON at.article_id = a.id WHERE a.status = 1 GROUP BY at.topic_id) at
SET t.article_count = COALESCE(at.cnt, 0)
WHERE t.id = at.topic_id;

-- 更新话题的参与人数
UPDATE topic t,
(SELECT at.topic_id, COUNT(DISTINCT a.user_id) AS cnt FROM article_topic at INNER JOIN article a ON at.article_id = a.id WHERE a.status = 1 GROUP BY at.topic_id) at
SET t.participant_count = COALESCE(at.cnt, 0)
WHERE t.id = at.topic_id;

-- ============================================
-- 验证修复结果
-- ============================================

SELECT '📊 修复后的文章统计：' AS '';
SELECT id, user_id, like_count, comment_count, forward_count, favorite_count 
FROM article ORDER BY id;

SELECT '👥 修复后的用户统计：' AS '';
SELECT id, username, nickname, follow_count, fans_count, article_count, like_count 
FROM user ORDER BY id;

SELECT '✅ 统计数据修复完成！' AS result;