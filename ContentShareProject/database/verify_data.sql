USE content_share;

-- Check actual data vs cached statistics
SELECT '=== Article statistics verification ===' as info;

-- Compare article stats with actual counts
SELECT 
    a.id as article_id,
    a.content as article_content,
    a.comment_count as cached_comment_count,
    a.like_count as cached_like_count,
    a.favorite_count as cached_favorite_count,
    (SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1) as actual_comment_count,
    (SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id) as actual_like_count,
    (SELECT COUNT(*) FROM favorite f WHERE f.article_id = a.id) as actual_favorite_count
FROM article a
ORDER BY a.id DESC
LIMIT 10;

-- Check actual comments
SELECT '=== Recent comments ===' as info;
SELECT * FROM comment WHERE status = 1 ORDER BY id DESC LIMIT 20;

-- Check user count
SELECT '=== User count ===' as info;
SELECT COUNT(*) as total_users FROM user;