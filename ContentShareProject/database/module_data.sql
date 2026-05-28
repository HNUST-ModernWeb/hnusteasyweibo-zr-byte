-- 为首页各模块准备测试数据
USE content_share;

-- ============================================
-- 1. 为文章添加不同的地理位置（用于同城模块）
-- ============================================
UPDATE `article` SET `location` = '北京·朝阳区' WHERE `id` IN (1, 10);
UPDATE `article` SET `location` = '上海·浦东新区' WHERE `id` IN (2, 3, 11);
UPDATE `article` SET `location` = '深圳·南山区' WHERE `id` IN (4, 12);
UPDATE `article` SET `location` = '成都·锦江区' WHERE `id` IN (5, 13);
UPDATE `article` SET `location` = '广州·天河区' WHERE `id` IN (6, 14);
UPDATE `article` SET `location` = '杭州·西湖区' WHERE `id` = 7;
UPDATE `article` SET `location` = '武汉·洪山区' WHERE `id` = 8;
UPDATE `article` SET `location` = '西安·雁塔区' WHERE `id` = 9;
UPDATE `article` SET `location` = '重庆·渝中区' WHERE `id` = 15;

-- 添加经纬度信息
UPDATE `article` SET `latitude` = 39.9042, `longitude` = 116.4074 WHERE `location` LIKE '北京%';  -- 北京
UPDATE `article` SET `latitude` = 31.2304, `longitude` = 121.4737 WHERE `location` LIKE '上海%';  -- 上海
UPDATE `article` SET `latitude` = 22.5431, `longitude` = 114.0579 WHERE `location` LIKE '深圳%';  -- 深圳
UPDATE `article` SET `latitude` = 30.5728, `longitude` = 104.0668 WHERE `location` LIKE '成都%';  -- 成都
UPDATE `article` SET `latitude` = 23.1291, `longitude` = 113.2644 WHERE `location` LIKE '广州%';  -- 广州
UPDATE `article` SET `latitude` = 30.2741, `longitude` = 120.1551 WHERE `location` LIKE '杭州%';  -- 杭州
UPDATE `article` SET `latitude` = 30.5928, `longitude` = 114.3055 WHERE `location` LIKE '武汉%';  -- 武汉
UPDATE `article` SET `latitude` = 34.3416, `longitude` = 108.9398 WHERE `location` LIKE '西安%';  -- 西安
UPDATE `article` SET `latitude` = 29.4316, `longitude` = 106.9123 WHERE `location` LIKE '重庆%';  -- 重庆

-- ============================================
-- 2. 更新用户的位置信息
-- ============================================
UPDATE `user` SET `location` = '北京' WHERE `username` = 'zhangsan';
UPDATE `user` SET `location` = '上海' WHERE `username` = 'lisi';
UPDATE `user` SET `location` = '深圳' WHERE `username` = 'wangwu';
UPDATE `user` SET `location` = '成都' WHERE `username` = 'zhaoliu';
UPDATE `user` SET `location` = '广州' WHERE `username` = 'sunqi';
UPDATE `user` SET `location` = '杭州' WHERE `username` = 'xiaohong';
UPDATE `user` SET `location` = '武汉' WHERE `username` = 'xiaoming';
UPDATE `user` SET `location` = '西安' WHERE `username` = 'xiaomei';

-- ============================================
-- 3. 添加更多点赞数据，提高热门文章的点赞数
-- ============================================
-- 将部分文章的点赞数提高，使其出现在热门列表
UPDATE `article` SET `like_count` = 1256 WHERE `id` = 7;   -- 美妆文章
UPDATE `article` SET `like_count` = 987 WHERE `id` = 5;    -- 成都攻略
UPDATE `article` SET `like_count` = 856 WHERE `id` = 9;    -- 音乐分享
UPDATE `article` SET `like_count` = 743 WHERE `id` = 10;   -- 摄影技巧
UPDATE `article` SET `like_count` = 654 WHERE `id` = 13;    -- MAC试色
UPDATE `article` SET `like_count` = 543 WHERE `id` = 2;    -- 红烧肉
UPDATE `article` SET `like_count` = 432 WHERE `id` = 15;   -- 大唐不夜城
UPDATE `article` SET `like_count` = 321 WHERE `id` = 4;    -- MacBook Pro

-- ============================================
-- 4. 添加浏览数
-- ============================================
UPDATE `article` SET `view_count` = 15600 WHERE `id` = 7;
UPDATE `article` SET `view_count` = 12300 WHERE `id` = 5;
UPDATE `article` SET `view_count` = 10800 WHERE `id` = 9;
UPDATE `article` SET `view_count` = 9500 WHERE `id` = 10;
UPDATE `article` SET `view_count` = 8900 WHERE `id` = 13;
UPDATE `article` SET `view_count` = 7800 WHERE `id` = 2;
UPDATE `article` SET `view_count` = 6500 WHERE `id` = 15;
UPDATE `article` SET `view_count` = 5400 WHERE `id` = 4;

-- ============================================
-- 5. 添加转发数
-- ============================================
UPDATE `article` SET `forward_count` = 234 WHERE `id` = 7;
UPDATE `article` SET `forward_count` = 189 WHERE `id` = 5;
UPDATE `article` SET `forward_count` = 156 WHERE `id` = 9;
UPDATE `article` SET `forward_count` = 123 WHERE `id` = 10;
UPDATE `article` SET `forward_count` = 98 WHERE `id` = 13;
UPDATE `article` SET `forward_count` = 87 WHERE `id` = 2;
UPDATE `article` SET `forward_count` = 76 WHERE `id` = 15;
UPDATE `article` SET `forward_count` = 65 WHERE `id` = 4;

-- ============================================
-- 6. 添加用户兴趣标签（用于推荐算法）
-- ============================================
INSERT INTO `user_tag` (`user_id`, `tag_name`) VALUES
-- zhangsan (id=2) 的兴趣
(2, '摄影'),
(2, '旅行'),
(2, '美食'),
(2, '科技'),

-- lisi (id=3) 的兴趣
(3, '美食'),
(3, '烹饪'),
(3, '旅行'),
(3, '生活方式'),

-- wangwu (id=4) 的兴趣
(4, '科技'),
(4, '数码'),
(4, 'AI'),
(4, '编程'),

-- zhaoliu (id=5) 的兴趣
(5, '旅行'),
(5, '摄影'),
(5, '美食'),
(5, '文化'),

-- sunqi (id=6) 的兴趣
(6, '健身'),
(6, '运动'),
(6, '健康'),
(6, '生活'),

-- xiaohong (id=7) 的兴趣
(7, '美妆'),
(7, '时尚'),
(7, '购物'),
(7, '生活'),

-- xiaoming (id=8) 的兴趣
(8, '学习'),
(8, '音乐'),
(8, '校园'),
(8, '科技'),

-- xiaomei (id=9) 的兴趣
(9, '旅行'),
(9, '美食'),
(9, '音乐'),
(9, '文化')
ON DUPLICATE KEY UPDATE `tag_name` = VALUES(`tag_name`);

-- ============================================
-- 7. 添加更多关注关系（确保关注流有内容）
-- ============================================
-- admin (id=1) 关注很多人
INSERT INTO `follow` (`user_id`, `follow_user_id`) VALUES
(1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9)
ON DUPLICATE KEY UPDATE `user_id` = VALUES(`user_id`);

-- ============================================
-- 8. 更新用户的获赞总数
-- ============================================
UPDATE `user` SET `like_count` = (SELECT SUM(`like_count`) FROM `article` WHERE `user_id` = `user`.id);

-- ============================================
-- 9. 创建用户-内容交互表（用于推荐算法）
-- ============================================
CREATE TABLE IF NOT EXISTS `user_interaction` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `article_id` BIGINT NOT NULL,
    `interaction_type` TINYINT COMMENT '互动类型: 1-浏览, 2-点赞, 3-收藏, 4-分享, 5-评论',
    `score` INT DEFAULT 1 COMMENT '互动得分',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`article_id`) REFERENCES `article`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户内容交互表';

-- 插入模拟的浏览记录
INSERT INTO `user_interaction` (`user_id`, `article_id`, `interaction_type`, `score`) VALUES
-- admin 的浏览记录
(1, 7, 1, 5), (1, 5, 1, 4), (1, 9, 1, 3), (1, 2, 1, 4), (1, 13, 1, 5),
(1, 10, 2, 3), (1, 7, 2, 5), (1, 5, 2, 4), (1, 2, 3, 3), (1, 13, 3, 5),
-- zhangsan 的浏览记录
(2, 2, 1, 5), (2, 5, 1, 4), (2, 3, 1, 3), (2, 7, 1, 4), (2, 4, 1, 3),
(2, 6, 2, 4), (2, 2, 2, 5), (2, 13, 3, 4),
-- lisi 的浏览记录
(3, 2, 1, 5), (3, 11, 1, 4), (3, 5, 1, 4), (3, 13, 1, 3),
(3, 2, 2, 5), (3, 7, 2, 4), (3, 9, 2, 3),
-- wangwu 的浏览记录
(4, 4, 1, 5), (4, 12, 1, 4), (4, 2, 1, 3), (4, 9, 1, 4),
(4, 4, 2, 5), (4, 5, 2, 4), (4, 7, 2, 3)
ON DUPLICATE KEY UPDATE `score` = VALUES(`score`);

-- ============================================
-- 10. 创建用户画像表（用于推荐算法）
-- ============================================
CREATE TABLE IF NOT EXISTS `user_profile` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL UNIQUE,
    `interest_tags` VARCHAR(500) COMMENT '兴趣标签JSON',
    `preferred_locations` VARCHAR(500) COMMENT '偏好位置JSON',
    `active_time` VARCHAR(100) COMMENT '活跃时间段',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户画像表';

-- 插入用户画像数据
INSERT INTO `user_profile` (`user_id`, `interest_tags`, `preferred_locations`) VALUES
(1, '["美妆", "美食", "旅行", "摄影"]', '["北京", "上海", "深圳"]'),
(2, '["摄影", "旅行", "美食", "科技"]', '["北京", "成都", "杭州"]'),
(3, '["美食", "烹饪", "旅行", "生活方式"]', '["上海", "成都", "广州"]'),
(4, '["科技", "数码", "AI", "编程"]', '["深圳", "北京", "上海"]'),
(5, '["旅行", "摄影", "美食", "文化"]', '["成都", "西安", "重庆"]'),
(6, '["健身", "运动", "健康", "生活"]', '["广州", "深圳", "北京"]'),
(7, '["美妆", "时尚", "购物", "生活"]', '["杭州", "上海", "北京"]'),
(8, '["学习", "音乐", "校园", "科技"]', '["武汉", "西安", "成都"]'),
(9, '["旅行", "美食", "音乐", "文化"]', '["西安", "成都", "重庆"]')
ON DUPLICATE KEY UPDATE `interest_tags` = VALUES(`interest_tags`);

-- ============================================
-- 11. 为每个城市添加同城内容
-- ============================================
-- 北京的内容
INSERT INTO `article` (`user_id`, `content`, `location`, `article_type`, `like_count`, `view_count`, `status`) VALUES
(2, '北京胡同里的秋天🍂 银杏叶黄了，老北京的韵味更浓了。推荐大家去雍和宫、五道营胡同走走，特别适合拍照！', '北京·东城区', 1, 567, 8900, 1),
(2, '天安门广场的升旗仪式🇨🇳 凌晨4点起床，排队2小时，但看到国旗升起的那一刻，一切都值了！', '北京·天安门广场', 1, 1234, 15600, 1)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- 上海的内容
INSERT INTO `article` (`user_id`, `content`, `location`, `article_type`, `like_count`, `view_count`, `status`) VALUES
(3, '外滩的夜景太美了！🌃 陆家嘴的摩天大楼和万国建筑博览群形成完美对比，上海夜景名不虚传！', '上海·外滩', 1, 789, 11200, 1),
(3, '上海网红咖啡店打卡☕️ 这家店的拿铁拉花超级可爱，味道也很棒。环境很适合拍照和发呆~', '上海·静安区', 1, 456, 6700, 1)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- 深圳的内容
INSERT INTO `article` (`user_id`, `content`, `location`, `article_type`, `like_count`, `view_count`, `status`) VALUES
(4, '深圳人才公园的日落🌅 程序员下班后的放松好去处，跑步、遛狗、看海，太惬意了！', '深圳·南山区', 1, 345, 5400, 1),
(4, '华强北电子市场淘货记🔌 终于配齐了所有的电子元件，科技达人的天堂！价格便宜到不敢相信~', '深圳·福田区', 1, 234, 4300, 1)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- 成都的内容
INSERT INTO `article` (`user_id`, `content`, `location`, `article_type`, `like_count`, `view_count`, `status`) VALUES
(5, '成都大熊猫基地🐼 早上7点就出发，看到熊猫宝宝吃竹子的样子，心都化了！超级推荐！', '成都·成华区', 1, 678, 9800, 1),
(5, '宽窄巷子的美食🥟 担担面、钟水饺、龙抄手...成都小吃真的太好吃了，两天根本吃不完！', '成都·青羊区', 1, 543, 7800, 1)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- 广州的内容
INSERT INTO `article` (`user_id`, `content`, `location`, `article_type`, `like_count`, `view_count`, `status`) VALUES
(6, '广州早茶🍵 虾饺、烧麦、叉烧包...一盅两件，这就是广州人的生活态度！', '广州·荔湾区', 1, 432, 6500, 1),
(6, '珠江夜游🚢 广州夜景最美的打开方式，两岸灯光璀璨，太浪漫了！', '广州·海珠区', 1, 321, 5200, 1)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- ============================================
-- 显示数据统计
-- ============================================
SELECT '📊 数据统计：' AS '';
SELECT CONCAT('总用户数: ', COUNT(*)) AS stat FROM `user` WHERE `status` = 1;
SELECT CONCAT('总文章数: ', COUNT(*)) AS stat FROM `article` WHERE `status` = 1;
SELECT CONCAT('有位置的文章数: ', COUNT(*)) AS stat FROM `article` WHERE `location` IS NOT NULL AND `status` = 1;
SELECT CONCAT('总关注数: ', COUNT(*)) AS stat FROM `follow`;
SELECT CONCAT('话题数: ', COUNT(*)) AS stat FROM `topic` WHERE `status` = 1;
SELECT CONCAT('热搜数: ', COUNT(*)) AS stat FROM `hot_search` WHERE `is_blocked` = 0;
SELECT CONCAT('用户画像数: ', COUNT(*)) AS stat FROM `user_profile`;
