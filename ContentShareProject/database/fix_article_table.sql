USE content_share;

-- 删除旧表
DROP TABLE IF EXISTS article;

-- 重新创建文章表（包含status列）
CREATE TABLE `article` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '文章ID',
    `user_id` BIGINT NOT NULL COMMENT '作者ID',
    `content` TEXT COMMENT '文字内容',
    `images` VARCHAR(2000) COMMENT '图片JSON数组',
    `video` VARCHAR(500) COMMENT '视频URL',
    `location` VARCHAR(100) COMMENT '定位位置',
    `latitude` DECIMAL(10,7) COMMENT '纬度',
    `longitude` DECIMAL(10,7) COMMENT '经度',
    `article_type` TINYINT DEFAULT 1 COMMENT '类型: 1-图文, 2-短视频, 3-纯文字, 4-投票, 5-活动',
    `topic_id` BIGINT COMMENT '所属话题ID',
    `vote_title` VARCHAR(200) COMMENT '投票标题',
    `vote_options` VARCHAR(2000) COMMENT '投票选项JSON',
    `vote_end_time` DATETIME COMMENT '投票结束时间',
    `activity_time` DATETIME COMMENT '活动时间',
    `activity_location` VARCHAR(200) COMMENT '活动地点',
    `like_count` INT DEFAULT 0 COMMENT '点赞数',
    `comment_count` INT DEFAULT 0 COMMENT '评论数',
    `forward_count` INT DEFAULT 0 COMMENT '转发数',
    `favorite_count` INT DEFAULT 0 COMMENT '收藏数',
    `share_count` INT DEFAULT 0 COMMENT '分享数',
    `view_count` INT DEFAULT 0 COMMENT '浏览数',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-正常, 0-删除, 2-仅自己可见',
    `is_top` TINYINT DEFAULT 0 COMMENT '是否置顶',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章/动态表';

-- 重新插入测试文章数据
INSERT INTO article (user_id, content, like_count, view_count, forward_count, comment_count, status, location, create_time) VALUES
(5, '今天天气真好！出门拍照去📸', 100, 1000, 10, 5, 1, '北京·朝阳区', NOW()),
(5, '分享一组长城摄影作品🇨🇳', 250, 3000, 25, 15, 1, '北京·八达岭', NOW()),
(5, '新买的相机到了，太激动了！', 180, 2000, 12, 8, 1, NULL, NOW()),
(6, '红烧肉做法，简单又美味！🥘', 320, 4000, 45, 30, 1, '上海·浦东新区', NOW()),
(6, '周末探店美食推荐🍜', 150, 1800, 20, 12, 1, '上海·静安区', NOW()),
(6, '在家做川菜，麻辣鲜香🌶️', 200, 2500, 18, 10, 1, '上海·徐汇区', NOW()),
(7, 'MacBook Pro M3使用体验💻', 450, 5000, 50, 35, 1, '深圳·南山区', NOW()),
(7, 'AI大模型最新进展🚀', 280, 3500, 30, 22, 1, NULL, NOW()),
(7, '程序员的一天都在写bug吗😂', 380, 4200, 55, 40, 1, '深圳·福田区', NOW()),
(8, '成都三日游攻略📍', 380, 4500, 42, 28, 1, '成都·锦江区', NOW()),
(8, '大熊猫太可爱了🐼', 200, 2500, 25, 18, 1, '成都·成华区', NOW()),
(8, '成都火锅推荐🔥', 290, 3200, 35, 20, 1, '成都·武侯区', NOW()),
(9, '健身打卡第30天💪', 160, 1900, 15, 12, 1, '广州·天河区', NOW()),
(9, '今日早餐打卡🍳', 90, 1100, 8, 5, 1, NULL, NOW()),
(9, '跑步10公里完成！🏃', 130, 1600, 12, 8, 1, '广州·海珠区', NOW()),
(10, 'MAC口红试色💄', 520, 6000, 68, 45, 1, '杭州·西湖区', NOW()),
(10, '美妆教程分享✨', 340, 4000, 42, 30, 1, NULL, NOW()),
(10, '今日穿搭👗', 210, 2800, 28, 18, 1, '杭州·滨江区', NOW());

SELECT '修复完成！' AS result;
SELECT COUNT(*) AS article_count FROM article;
