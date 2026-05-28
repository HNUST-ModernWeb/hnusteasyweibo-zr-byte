USE content_share;

-- Check existing users
SELECT 'Existing users:' as info;
SELECT id, username, nickname FROM user ORDER BY id;

-- Check existing articles
SELECT 'Existing articles:' as info;
SELECT COUNT(*) as total, MAX(id) as max_id FROM article WHERE status = 1;

-- Check existing comments
SELECT 'Existing comments:' as info;
SELECT COUNT(*) as total FROM comment WHERE status = 1;

-- Check existing likes
SELECT 'Existing likes:' as info;
SELECT COUNT(*) as total FROM article_like;

-- Check existing favorites
SELECT 'Existing favorites:' as info;
SELECT COUNT(*) as total FROM favorite;