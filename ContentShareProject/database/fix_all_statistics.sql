USE content_share;

-- ============================================
-- Fix ALL statistics to match actual data
-- ============================================

-- Fix article comment counts
UPDATE article a
SET a.comment_count = COALESCE((SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1), 0);

-- Fix article like counts
UPDATE article a
SET a.like_count = COALESCE((SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id), 0);

-- Fix article favorite counts  
UPDATE article a
SET a.favorite_count = COALESCE((SELECT COUNT(*) FROM favorite f WHERE f.article_id = a.id), 0);

-- Fix article forward counts
UPDATE article a
SET a.forward_count = COALESCE((SELECT COUNT(*) FROM forward fw WHERE fw.article_id = a.id), 0);

-- Fix user article counts
UPDATE user u
SET u.article_count = COALESCE((SELECT COUNT(*) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0);

-- Fix user follow counts
UPDATE user u
SET u.follow_count = COALESCE((SELECT COUNT(*) FROM follow f WHERE f.user_id = u.id), 0);

-- Fix user fans counts
UPDATE user u
SET u.fans_count = COALESCE((SELECT COUNT(*) FROM follow f WHERE f.follow_user_id = u.id), 0);

-- Fix user like counts (total likes on articles)
UPDATE user u
SET u.like_count = COALESCE((SELECT SUM(a.like_count) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0);

-- ============================================
-- Verify the fix
-- ============================================

SELECT '=== After fix verification ===' as info;

-- Show articles with their corrected stats
SELECT 
    a.id as article_id,
    a.like_count as fixed_like_count,
    a.comment_count as fixed_comment_count,
    a.favorite_count as fixed_favorite_count,
    (SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1) as actual_comments,
    (SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id) as actual_likes
FROM article a
ORDER BY a.id DESC
LIMIT 15;

SELECT '=== User statistics ===' as info;
SELECT u.id, u.username, u.nickname, u.follow_count, u.fans_count, u.article_count, u.like_count
FROM user u ORDER BY u.id;

SELECT '✅ All statistics fixed!' as result;