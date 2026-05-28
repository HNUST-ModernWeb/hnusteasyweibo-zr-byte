USE content_share;

-- ============================================
-- Reset ALL statistics to match actual data ONLY
-- ============================================

-- Fix article statistics
UPDATE article a
SET 
    comment_count = COALESCE((SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1), 0),
    like_count = COALESCE((SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id), 0),
    favorite_count = COALESCE((SELECT COUNT(*) FROM favorite f WHERE f.article_id = a.id), 0),
    forward_count = COALESCE((SELECT COUNT(*) FROM forward fw WHERE fw.article_id = a.id), 0),
    view_count = 0; -- Reset view count to 0 since we don't track actual views

-- Fix user statistics
UPDATE user u
SET 
    article_count = COALESCE((SELECT COUNT(*) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0),
    follow_count = COALESCE((SELECT COUNT(*) FROM follow f WHERE f.user_id = u.id), 0),
    fans_count = COALESCE((SELECT COUNT(*) FROM follow f WHERE f.follow_user_id = u.id), 0),
    like_count = COALESCE((SELECT SUM(a.like_count) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0);

-- Fix topic statistics
UPDATE topic t
SET 
    article_count = COALESCE((SELECT COUNT(DISTINCT at.article_id) FROM article_topic at INNER JOIN article a ON at.article_id = a.id WHERE at.topic_id = t.id AND a.status = 1), 0),
    participant_count = COALESCE((SELECT COUNT(DISTINCT a.user_id) FROM article_topic at INNER JOIN article a ON at.article_id = a.id WHERE at.topic_id = t.id AND a.status = 1), 0);

-- ============================================
-- Verify the fix
-- ============================================

SELECT '=== Final verification ===' as info;

-- Show articles with their actual stats
SELECT 
    a.id as article_id,
    a.like_count as actual_likes,
    a.comment_count as actual_comments,
    a.favorite_count as actual_favorites,
    a.forward_count as actual_forwards,
    a.view_count as views,
    (SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1) as verify_comments,
    (SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id) as verify_likes
FROM article a
ORDER BY a.id;

SELECT '=== Total counts ===' as info;
SELECT COUNT(*) as total_articles FROM article WHERE status = 1;
SELECT COUNT(*) as total_comments FROM comment WHERE status = 1;
SELECT COUNT(*) as total_likes FROM article_like;
SELECT COUNT(*) as total_favorites FROM favorite;
SELECT COUNT(*) as total_users FROM user;

SELECT '✅ All statistics reset to actual data!' as result;