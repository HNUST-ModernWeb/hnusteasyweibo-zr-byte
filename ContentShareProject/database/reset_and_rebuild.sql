USE content_share;

-- ============================================
-- Rebuild ALL statistics from actual data
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

-- ============================================
-- Add realistic comments and likes to recent articles
-- ============================================

-- Add comments to articles 1-30 (ignore duplicates)
INSERT IGNORE INTO comment (article_id, user_id, content) VALUES
-- Article 1 comments
(1, 2, 'Great photo!'),
(1, 3, 'Beautiful scenery'),
(1, 4, 'Love this!'),
-- Article 2 comments
(2, 3, 'Looks delicious!'),
(2, 5, 'Recipe please!'),
-- Article 3 comments
(3, 4, 'Interesting read'),
(3, 6, 'Good point'),
-- Article 4 comments
(4, 5, 'Very useful'),
(4, 7, 'Thanks for sharing'),
-- Article 5 comments
(5, 6, 'Going to visit!'),
(5, 8, 'Perfect timing'),
-- Article 6 comments
(6, 7, 'Love this style'),
(6, 9, 'So cute!'),
-- Article 7 comments
(7, 8, 'Beautiful makeup'),
(7, 10, 'Need this!'),
-- Article 8 comments
(8, 9, 'Great workout tips'),
(8, 2, 'Motivating!'),
-- Article 9 comments
(9, 10, 'Good job!'),
(9, 3, 'Keep going!'),
-- Article 10 comments
(10, 2, 'Beautiful sunset'),
(10, 4, 'Stunning!');

-- Add likes to articles (ignore duplicates)
INSERT IGNORE INTO article_like (user_id, article_id) VALUES
-- User 2 likes
(2, 1), (2, 3), (2, 5), (2, 7), (2, 9),
-- User 3 likes
(3, 2), (3, 4), (3, 6), (3, 8), (3, 10),
-- User 4 likes
(4, 1), (4, 4), (4, 5), (4, 7), (4, 8),
-- User 5 likes
(5, 2), (5, 3), (5, 6), (5, 9), (5, 10),
-- User 6 likes
(6, 1), (6, 2), (6, 5), (6, 7), (6, 8),
-- User 7 likes
(7, 3), (7, 4), (7, 6), (7, 9), (7, 10),
-- User 8 likes
(8, 1), (8, 4), (8, 5), (8, 6), (8, 9),
-- User 9 likes
(9, 2), (9, 3), (9, 7), (9, 8), (9, 10),
-- User 10 likes
(10, 1), (10, 2), (10, 4), (10, 6), (10, 7);

-- ============================================
-- Update statistics again to reflect new data
-- ============================================

-- Update article stats
UPDATE article a
SET a.comment_count = COALESCE((SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1), 0),
    a.like_count = COALESCE((SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id), 0);

-- Update user stats
UPDATE user u
SET u.article_count = COALESCE((SELECT COUNT(*) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0),
    u.like_count = COALESCE((SELECT SUM(a.like_count) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0);

-- ============================================
-- Verify the results
-- ============================================

SELECT '=== Final verification ===' as info;

-- Show articles with stats
SELECT 
    a.id as article_id,
    a.like_count as likes,
    a.comment_count as comments,
    (SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1) as actual_comments,
    (SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id) as actual_likes
FROM article a
ORDER BY a.id
LIMIT 15;

SELECT '=== Total counts ===' as info;
SELECT COUNT(*) as articles FROM article WHERE status = 1;
SELECT COUNT(*) as comments FROM comment WHERE status = 1;
SELECT COUNT(*) as likes FROM article_like;
SELECT COUNT(*) as users FROM user;

SELECT '✅ Data rebuilt successfully!' as result;