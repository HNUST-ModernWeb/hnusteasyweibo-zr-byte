USE content_share;

-- ============================================
-- 插入更多博文数据，让内容更丰富
-- ============================================

-- 用户5（假设是摄影师）的博文
INSERT INTO article (user_id, content, location) VALUES 
(5, '今天天气真好，出去拍照发现了一片花海，太美了！ #生活记录 #摄影', '北京·朝阳区'),
(5, '分享一张昨天在长城拍的日落，真的很壮观！ #风景 #旅行', '北京·八达岭'),
(5, '新相机到了，迫不及待想试试！ #数码 #摄影', NULL),
(5, '周末去了公园，发现很多可爱的小动物 #自然 #公园', '北京·奥林匹克公园'),
(5, '深夜修图，分享一下今天拍的成果 #后期 #摄影', NULL);

-- 用户6（美食博主）的博文  
INSERT INTO article (user_id, content, location) VALUES
(6, '今天做了红烧肉，分享一下教程！首先准备五花肉切块... #美食 #家常菜', '上海·浦东新区'),
(6, '周末探店，发现了一家超棒的日料店！ #美食 #探店', '上海·静安区'),
(6, '分享今天做的糖醋排骨，酸酸甜甜超好吃！ #美食 #做饭', '上海·徐汇区'),
(6, '早餐打卡：豆浆油条，经典搭配！ #早餐 #美食', NULL),
(6, '朋友推荐的火锅店，味道真的很正宗！ #美食 #火锅', '上海·黄浦区');

-- 用户7（科技博主）的博文
INSERT INTO article (user_id, content, location) VALUES
(7, 'MacBook Pro M3使用一周体验，性能真的很强！ #科技 #数码', '深圳·南山区'),
(7, 'AI大模型最新进展：现在已经能生成这么逼真的图片了！ #AI #科技', NULL),
(7, '程序员的一天：早上写代码，下午改bug，晚上加班 #程序员 #工作', '深圳·福田区'),
(7, '分享一个很实用的编程技巧，提升效率！ #编程 #技术', NULL),
(7, '新买的键盘到了，打字手感超棒！ #数码 #外设', NULL);

-- 用户8（旅行博主）的博文
INSERT INTO article (user_id, content, location) VALUES
(8, '成都三日游攻略！第一天：宽窄巷子...第二天：熊猫基地...第三天：锦里古街... #旅行 #成都', '成都·锦江区'),
(8, '大熊猫太可爱了！今天在熊猫基地待了一整天 #旅行 #熊猫', '成都·成华区'),
(8, '成都火锅推荐：这家真的超级正宗！ #美食 #旅行', '成都·武侯区'),
(8, '下一站：重庆！有没有什么推荐的地方？ #旅行 #重庆', NULL),
(8, '分享旅行中的小确幸：遇到了一只超可爱的猫 #旅行 #日常', '重庆·渝中区');

-- 用户9（健身博主）的博文
INSERT INTO article (user_id, content, location) VALUES
(9, '健身打卡第30天！坚持真的很重要 #健身 #打卡', '广州·天河区'),
(9, '今日早餐：鸡胸肉沙拉+燕麦粥，营养均衡！ #健身 #早餐', NULL),
(9, '跑步10公里完成！感觉自己越来越棒了 #健身 #跑步', '广州·海珠区'),
(9, '分享一组腹肌训练动作，一起加油！ #健身 #训练', NULL),
(9, '健身前后对比图，三个月的变化！ #健身 #励志', NULL);

-- 用户10（美妆博主）的博文
INSERT INTO article (user_id, content, location) VALUES
(10, 'MAC口红试色：今天分享3支超好看的色号！ #美妆 #口红', '杭州·西湖区'),
(10, '美妆教程：新手也能学会的日常妆容！ #美妆 #教程', NULL),
(10, '今日穿搭：简约风格也可以很美！ #穿搭 #时尚', '杭州·滨江区'),
(10, '分享最近爱用的护肤品，效果超棒！ #美妆 #护肤', NULL),
(10, '夏天到了，分享几个防晒小技巧！ #美妆 #防晒', NULL);

-- ============================================
-- 为部分博文添加评论
-- ============================================

-- 获取刚才插入的文章ID（假设从31开始）
-- 给文章31（摄影师的花海博文）添加评论
INSERT INTO comment (article_id, user_id, content) VALUES
(31, 6, '太美了！这个地方在哪里呀？'),
(31, 8, '看着好治愈！'),
(31, 10, '拍照技术真好！');

-- 给文章36（美食博主的红烧肉）添加评论
INSERT INTO comment (article_id, user_id, content) VALUES
(36, 7, '看着好想吃！'),
(36, 9, '求详细教程！');

-- 给文章41（科技博主的MacBook体验）添加评论
INSERT INTO comment (article_id, user_id, content) VALUES
(41, 5, '我也想换了！'),
(41, 10, '羡慕了！');

-- 给文章46（旅行博主的成都攻略）添加评论
INSERT INTO comment (article_id, user_id, content) VALUES
(46, 7, '收藏了！正准备去成都'),
(46, 8, '谢谢你的攻略！'),
(46, 9, '熊猫基地真的超棒！');

-- 给文章51（健身博主的打卡）添加评论
INSERT INTO comment (article_id, user_id, content) VALUES
(51, 5, '好厉害！向你学习'),
(51, 8, '坚持下去！');

-- 给文章56（美妆博主的口红试色）添加评论
INSERT INTO comment (article_id, user_id, content) VALUES
(56, 6, '哪个色号最显白？'),
(56, 9, '都好好看！');

-- ============================================
-- 为部分博文添加点赞
-- ============================================

INSERT INTO article_like (user_id, article_id) VALUES
-- 用户5给美食、科技博主点赞
(5, 36), (5, 37), (5, 41),
-- 用户6给摄影、旅行博主点赞
(6, 31), (6, 32), (6, 46),
-- 用户7给健身、美食博主点赞
(7, 51), (7, 52), (7, 36),
-- 用户8给摄影、美妆博主点赞
(8, 31), (8, 33), (8, 56),
-- 用户9给科技、旅行博主点赞
(9, 41), (9, 46), (9, 47),
-- 用户10给美食、健身博主点赞
(10, 36), (10, 51), (10, 52);

-- ============================================
-- 为部分博文添加收藏
-- ============================================

INSERT INTO favorite (user_id, article_id) VALUES
(6, 46),  -- 美食博主收藏成都攻略
(7, 31),  -- 科技博主收藏摄影博文
(8, 36),  -- 旅行博主收藏红烧肉教程
(9, 41),  -- 健身博主收藏MacBook体验
(10, 51); -- 美妆博主收藏健身打卡

-- ============================================
-- 更新统计数据（确保与实际一致）
-- ============================================

-- 更新文章的评论数
UPDATE article a SET a.comment_count = COALESCE((SELECT COUNT(*) FROM comment c WHERE c.article_id = a.id AND c.status = 1), 0);

-- 更新文章的点赞数
UPDATE article a SET a.like_count = COALESCE((SELECT COUNT(*) FROM article_like al WHERE al.article_id = a.id), 0);

-- 更新文章的收藏数
UPDATE article a SET a.favorite_count = COALESCE((SELECT COUNT(*) FROM favorite f WHERE f.article_id = a.id), 0);

-- 更新用户的文章数
UPDATE user u SET u.article_count = COALESCE((SELECT COUNT(*) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0);

-- 更新用户的获赞数
UPDATE user u SET u.like_count = COALESCE((SELECT SUM(a.like_count) FROM article a WHERE a.user_id = u.id AND a.status = 1), 0);

-- ============================================
-- 验证插入结果
-- ============================================

SELECT '数据统计：' AS info;
SELECT CONCAT('总文章数：', COUNT(*)) AS stat FROM article WHERE status = 1;
SELECT CONCAT('总评论数：', COUNT(*)) AS stat FROM comment WHERE status = 1;
SELECT CONCAT('总点赞数：', COUNT(*)) AS stat FROM article_like;
SELECT CONCAT('总收藏数：', COUNT(*)) AS stat FROM favorite;

SELECT '用户文章统计：' AS info;
SELECT u.id, u.username, u.nickname, COUNT(a.id) AS article_count 
FROM user u LEFT JOIN article a ON u.id = a.user_id AND a.status = 1 
GROUP BY u.id, u.username, u.nickname ORDER BY u.id;

SELECT '数据插入完成！' AS result;