USE content_share;

-- ============================================
-- Insert more articles to make content richer
-- ============================================

-- User 5 (Photographer)
INSERT INTO article (user_id, content, location) VALUES 
(5, 'Nice weather today! Went out for photos and found a beautiful flower field. #Life #Photography', 'Beijing Chaoyang'),
(5, 'Sharing a sunset photo taken at the Great Wall yesterday. So magnificent! #Scenery #Travel', 'Beijing Badaling'),
(5, 'New camera arrived! Can not wait to try it out! #Digital #Photography', NULL),
(5, 'Went to the park this weekend, found many cute little animals. #Nature #Park', 'Beijing Olympic Park'),
(5, 'Editing photos late at night, sharing today is results. #PostProcessing #Photography', NULL);

-- User 6 (Food Blogger)
INSERT INTO article (user_id, content, location) VALUES
(6, 'Made braised pork today! Sharing the recipe: First prepare pork belly... #Food #HomeCooking', 'Shanghai Pudong'),
(6, 'Explored a great Japanese restaurant this weekend! #Food #FoodReview', 'Shanghai Jingan'),
(6, 'Sharing sweet and sour pork ribs made today. So delicious! #Food #Cooking', 'Shanghai Xuhui'),
(6, 'Breakfast check-in: Soy milk and youtiao, classic combo! #Breakfast #Food', NULL),
(6, 'Hot pot restaurant recommended by a friend, super authentic taste! #Food #HotPot', 'Shanghai Huangpu');

-- User 7 (Tech Blogger)
INSERT INTO article (user_id, content, location) VALUES
(7, 'MacBook Pro M3 one week experience, performance is really strong! #Tech #Digital', 'Shenzhen Nanshan'),
(7, 'Latest AI model progress: Can generate such realistic images now! #AI #Tech', NULL),
(7, 'A programmer day: Write code in morning, fix bugs in afternoon, work overtime at night. #Programmer #Work', 'Shenzhen Futian'),
(7, 'Sharing a useful programming technique to boost efficiency! #Programming #Tech', NULL),
(7, 'New keyboard arrived, typing feel is amazing! #Digital #Peripherals', NULL);

-- User 8 (Travel Blogger)
INSERT INTO article (user_id, content, location) VALUES
(8, 'Chengdu 3-day travel guide! Day 1: Kuanzhai Alleys... Day 2: Panda Base... Day 3: Jinli Street... #Travel #Chengdu', 'Chengdu Jinjiang'),
(8, 'Giant pandas are so cute! Spent the whole day at Panda Base. #Travel #Panda', 'Chengdu Chenghua'),
(8, 'Chengdu hot pot recommendation: This one is super authentic! #Food #Travel', 'Chengdu Wuhou'),
(8, 'Next stop: Chongqing! Any recommendations? #Travel #Chongqing', NULL),
(8, 'Sharing a nice moment from travel: Met a super cute cat. #Travel #Daily', 'Chongqing Yuzhong');

-- User 9 (Fitness Blogger)
INSERT INTO article (user_id, content, location) VALUES
(9, 'Fitness check-in day 30! Persistence is really important. #Fitness #CheckIn', 'Guangzhou Tianhe'),
(9, 'Today is breakfast: Chicken breast salad + oatmeal, balanced nutrition! #Fitness #Breakfast', NULL),
(9, 'Completed 10km run! Feeling better and better. #Fitness #Running', 'Guangzhou Haizhu'),
(9, 'Sharing a set of ab exercises, let is work together! #Fitness #Training', NULL),
(9, 'Before and after fitness photos, changes in three months! #Fitness #Motivation', NULL);

-- User 10 (Beauty Blogger)
INSERT INTO article (user_id, content, location) VALUES
(10, 'MAC lipstick swatches: Sharing 3 super nice shades today! #Beauty #Lipstick', 'Hangzhou Xihu'),
(10, 'Makeup tutorial: Everyday makeup even beginners can learn! #Beauty #Tutorial', NULL),
(10, 'Today is outfit: Minimal style can also be beautiful! #OOTD #Fashion', 'Hangzhou Binjiang'),
(10, 'Sharing recent favorite skincare products, effects are amazing! #Beauty #Skincare', NULL),
(10, 'Summer is here, sharing some sunscreen tips! #Beauty #Sunscreen', NULL);

-- ============================================
-- Add comments to some articles
-- ============================================

-- Comments for article 47
INSERT INTO comment (article_id, user_id, content) VALUES
(47, 6, 'So beautiful! Where is this place?'),
(47, 8, 'Looks so healing!'),
(47, 10, 'Great photography skills!');

-- Comments for article 52
INSERT INTO comment (article_id, user_id, content) VALUES
(52, 7, 'Looks so delicious!'),
(52, 9, 'Please share detailed recipe!');

-- Comments for article 57
INSERT INTO comment (article_id, user_id, content) VALUES
(57, 5, 'I want to upgrade too!'),
(57, 10, 'So jealous!');

-- Comments for article 62
INSERT INTO comment (article_id, user_id, content) VALUES
(62, 7, 'Saved! Planning to go to Chengdu'),
(62, 8, 'Thanks for the guide!'),
(62, 9, 'Panda Base is amazing!');

-- Comments for article 67
INSERT INTO comment (article_id, user_id, content) VALUES
(67, 5, 'Amazing! Learning from you'),
(67, 8, 'Keep it up!');

-- Comments for article 72
INSERT INTO comment (article_id, user_id, content) VALUES
(72, 6, 'Which shade is most flattering?'),
(72, 9, 'All look great!');

-- ============================================
-- Add likes to some articles
-- ============================================

INSERT INTO article_like (user_id, article_id) VALUES
-- User 5 likes food and tech bloggers
(5, 52), (5, 53), (5, 57),
-- User 6 likes photography and travel bloggers
(6, 47), (6, 48), (6, 62),
-- User 7 likes fitness and food bloggers
(7, 67), (7, 68), (7, 52),
-- User 8 likes photography and beauty bloggers
(8, 47), (8, 49), (8, 72),
-- User 9 likes tech and travel bloggers
(9, 57), (9, 62), (9, 63),
-- User 10 likes food and fitness bloggers
(10, 52), (10, 67), (10, 68);

-- ============================================
-- Add favorites to some articles
-- ============================================

INSERT INTO favorite (user_id, article_id) VALUES
(6, 62),  -- Food blogger saves Chengdu guide
(7, 47),  -- Tech blogger saves photography article
(8, 52),  -- Travel blogger saves braised pork recipe
(9, 57),  -- Fitness blogger saves MacBook review
(10, 67); -- Beauty blogger saves fitness check-in

-- ============================================
-- Update statistics to match actual data
-- ============================================

-- Update article comment counts
UPDATE article a 
SET a.comment_count = COALESCE((SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1), 0);

-- Update article like counts
UPDATE article a 
SET a.like_count = COALESCE((SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id), 0);

-- Update article favorite counts
UPDATE article a 
SET a.favorite_count = COALESCE((SELECT COUNT(*) FROM favorite f WHERE f.article_id = a.id), 0);

-- Update user article counts
UPDATE user u 
SET u.article_count = COALESCE((SELECT COUNT(*) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0);

-- Update user like counts (total likes on articles)
UPDATE user u 
SET u.like_count = COALESCE((SELECT SUM(a.like_count) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0);

-- ============================================
-- Verify the results
-- ============================================

SELECT 'Data Statistics:' as info;
SELECT CONCAT('Total articles: ', COUNT(*)) as stat FROM article WHERE status = 1;
SELECT CONCAT('Total comments: ', COUNT(*)) as stat FROM comment WHERE status = 1;
SELECT CONCAT('Total likes: ', COUNT(*)) as stat FROM article_like;
SELECT CONCAT('Total favorites: ', COUNT(*)) as stat FROM favorite;

SELECT 'User article counts:' as info;
SELECT u.id, u.username, u.nickname, COUNT(a.id) as article_count 
FROM user u LEFT JOIN article a ON u.id = a.user_id AND a.status = 1 
GROUP BY u.id, u.username, u.nickname ORDER BY u.id;

SELECT 'Data insertion complete!' as result;