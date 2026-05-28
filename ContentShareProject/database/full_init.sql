-- 微博系统完整数据库初始化脚本
-- 包含数据库创建、表结构、索引和初始数据

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS content_share DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE content_share;

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码',
    `nickname` VARCHAR(100) COMMENT '昵称',
    `avatar` VARCHAR(500) COMMENT '头像URL',
    `bio` VARCHAR(500) COMMENT '个人简介',
    `gender` TINYINT DEFAULT 0 COMMENT '性别: 0-未知, 1-男, 2-女',
    `birthday` DATE COMMENT '生日',
    `location` VARCHAR(100) COMMENT '所在地',
    `phone` VARCHAR(20) COMMENT '手机号',
    `email` VARCHAR(100) COMMENT '邮箱',
    `is_verified` TINYINT DEFAULT 0 COMMENT '是否认证',
    `verified_type` VARCHAR(50) COMMENT '认证类型',
    `follow_count` INT DEFAULT 0 COMMENT '关注数',
    `fans_count` INT DEFAULT 0 COMMENT '粉丝数',
    `article_count` INT DEFAULT 0 COMMENT '发文章数',
    `like_count` INT DEFAULT 0 COMMENT '获赞数',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-正常, 0-禁用',
    `last_login_time` DATETIME COMMENT '最后登录时间',
    `last_login_ip` VARCHAR(50) COMMENT '最后登录IP',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 文章/动态表
CREATE TABLE IF NOT EXISTS `article` (
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

-- 关注关系表
CREATE TABLE IF NOT EXISTS `follow` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '关注者ID',
    `follow_user_id` BIGINT NOT NULL COMMENT '被关注者ID',
    `is_special` TINYINT DEFAULT 0 COMMENT '是否特别关注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`follow_user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_follow` (`user_id`, `follow_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关注关系表';

-- 点赞表
CREATE TABLE IF NOT EXISTS `article_like` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `article_id` BIGINT NOT NULL COMMENT '文章ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`article_id`) REFERENCES `article`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_like` (`user_id`, `article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点赞表';

-- 评论表
CREATE TABLE IF NOT EXISTS `comment` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `article_id` BIGINT NOT NULL COMMENT '文章ID',
    `user_id` BIGINT NOT NULL COMMENT '评论者ID',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父评论ID',
    `reply_id` BIGINT DEFAULT 0 COMMENT '回复ID',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `like_count` INT DEFAULT 0 COMMENT '点赞数',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-正常, 0-删除',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`article_id`) REFERENCES `article`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- 收藏表
CREATE TABLE IF NOT EXISTS `favorite` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `article_id` BIGINT NOT NULL COMMENT '文章ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`article_id`) REFERENCES `article`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_favorite` (`user_id`, `article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

-- 转发记录表
CREATE TABLE IF NOT EXISTS `forward` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '转发者ID',
    `article_id` BIGINT NOT NULL COMMENT '原文章ID',
    `content` TEXT COMMENT '转发时添加的内容',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`article_id`) REFERENCES `article`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='转发记录表';

-- 私信表
CREATE TABLE IF NOT EXISTS `message` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `from_user_id` BIGINT NOT NULL COMMENT '发送者ID',
    `to_user_id` BIGINT NOT NULL COMMENT '接收者ID',
    `content` TEXT NOT NULL COMMENT '消息内容',
    `message_type` TINYINT DEFAULT 1 COMMENT '类型: 1-文字, 2-图片, 3-语音',
    `is_read` TINYINT DEFAULT 0 COMMENT '是否已读',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`from_user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`to_user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='私信表';

-- 话题表
CREATE TABLE IF NOT EXISTS `topic` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL UNIQUE COMMENT '话题名称',
    `description` VARCHAR(500) COMMENT '话题描述',
    `icon` VARCHAR(500) COMMENT '话题图标',
    `cover_image` VARCHAR(500) COMMENT '封面图片',
    `participant_count` INT DEFAULT 0 COMMENT '参与人数',
    `article_count` INT DEFAULT 0 COMMENT '动态数量',
    `heat_score` INT DEFAULT 0 COMMENT '热度评分',
    `category` VARCHAR(50) COMMENT '分类',
    `is_recommend` TINYINT DEFAULT 0 COMMENT '是否推荐',
    `status` TINYINT DEFAULT 1 COMMENT '状态: 1-正常, 0-禁用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='话题表';

-- 文章话题关联表
CREATE TABLE IF NOT EXISTS `article_topic` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `article_id` BIGINT NOT NULL COMMENT '文章ID',
    `topic_id` BIGINT NOT NULL COMMENT '话题ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`article_id`) REFERENCES `article`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`topic_id`) REFERENCES `topic`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_article_topic` (`article_id`, `topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章话题关联表';

-- 热搜表
CREATE TABLE IF NOT EXISTS `hot_search` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `keyword` VARCHAR(100) NOT NULL COMMENT '搜索关键词',
    `search_count` INT DEFAULT 0 COMMENT '搜索次数',
    `rank` INT DEFAULT 0 COMMENT '排名',
    `category` VARCHAR(50) COMMENT '分类: real_time-实时, entertainment-文娱, social-社会',
    `is_blocked` TINYINT DEFAULT 0 COMMENT '是否屏蔽',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='热搜表';

-- 搜索历史表
CREATE TABLE IF NOT EXISTS `search_history` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `keyword` VARCHAR(100) NOT NULL COMMENT '搜索关键词',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='搜索历史表';

-- 用户设置表
CREATE TABLE IF NOT EXISTS `user_settings` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL UNIQUE COMMENT '用户ID',
    `dark_mode` TINYINT DEFAULT 0 COMMENT '夜间模式: 0-关闭, 1-开启, 2-跟随系统',
    `font_size` VARCHAR(20) DEFAULT 'medium' COMMENT '字体大小: small, medium, large',
    `no_image_mode` TINYINT DEFAULT 0 COMMENT '无图模式',
    `auto_play_video` TINYINT DEFAULT 1 COMMENT '自动播放视频',
    `notification_settings` VARCHAR(500) COMMENT '通知设置JSON',
    `privacy_settings` VARCHAR(500) COMMENT '隐私设置JSON',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户设置表';

-- 话题分类表
CREATE TABLE IF NOT EXISTS `topic_category` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
    `icon` VARCHAR(100) COMMENT '分类图标',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT DEFAULT 1 COMMENT '状态',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='话题分类表';

-- 私信会话表
CREATE TABLE IF NOT EXISTS `conversation` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `target_user_id` BIGINT NOT NULL COMMENT '目标用户ID',
    `last_message_id` BIGINT COMMENT '最后一条消息ID',
    `last_message_time` DATETIME COMMENT '最后消息时间',
    `unread_count` INT DEFAULT 0 COMMENT '未读消息数',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`target_user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_conversation` (`user_id`, `target_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='私信会话表';

-- @提及表
CREATE TABLE IF NOT EXISTS `mention` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `article_id` BIGINT COMMENT '文章ID',
    `comment_id` BIGINT COMMENT '评论ID',
    `user_id` BIGINT NOT NULL COMMENT '被@的用户ID',
    `mention_user_id` BIGINT NOT NULL COMMENT '@用户的ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`article_id`) REFERENCES `article`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`comment_id`) REFERENCES `comment`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`mention_user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='@提及表';

-- 用户标签/兴趣表
CREATE TABLE IF NOT EXISTS `user_tag` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `tag_name` VARCHAR(50) NOT NULL COMMENT '标签名称',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签表';

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_article_user_id ON article(user_id);
CREATE INDEX IF NOT EXISTS idx_article_create_time ON article(create_time);
CREATE INDEX IF NOT EXISTS idx_article_topic_id ON article(topic_id);
CREATE INDEX IF NOT EXISTS idx_comment_article_id ON comment(article_id);
CREATE INDEX IF NOT EXISTS idx_comment_user_id ON comment(user_id);
CREATE INDEX IF NOT EXISTS idx_message_from_user ON message(from_user_id);
CREATE INDEX IF NOT EXISTS idx_message_to_user ON message(to_user_id);
CREATE INDEX IF NOT EXISTS idx_hot_search_rank ON hot_search(`rank`);
CREATE INDEX IF NOT EXISTS idx_topic_heat ON topic(heat_score);

-- 插入初始话题数据
INSERT INTO `topic` (`name`, `description`, `participant_count`, `article_count`, `heat_score`, `is_recommend`, `status`) VALUES
('热搜', '实时热点话题', 1000, 500, 100, 1, 1),
('娱乐', '娱乐八卦', 800, 400, 90, 1, 1),
('体育', '体育新闻', 600, 300, 80, 1, 1),
('科技', '科技资讯', 500, 250, 70, 1, 1),
('美食', '美食分享', 400, 200, 60, 1, 1)
ON DUPLICATE KEY UPDATE `heat_score` = VALUES(`heat_score`);

-- 插入初始热搜数据
INSERT INTO `hot_search` (`keyword`, `search_count`, `rank`, `category`) VALUES
('今日热搜', 10000, 1, 'real_time'),
('娱乐新闻', 8000, 2, 'entertainment'),
('社会热点', 6000, 3, 'social')
ON DUPLICATE KEY UPDATE `search_count` = VALUES(`search_count`);

-- 插入初始话题分类数据
INSERT INTO `topic_category` (`name`, `icon`, `sort_order`) VALUES
('实时', '🔥', 1),
('娱乐', '🎭', 2),
('体育', '⚽', 3),
('科技', '💻', 4),
('生活', '🍜', 5)
ON DUPLICATE KEY UPDATE `sort_order` = VALUES(`sort_order`);

-- 插入测试用户数据（密码都是123456的MD5值：e10adc3949ba59abbe56e057f20f883e）
INSERT INTO `user` (`username`, `password`, `nickname`, `bio`, `follow_count`, `fans_count`, `article_count`, `status`) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员', '这是管理员账号', 10, 100, 5, 1),
('test1', 'e10adc3949ba59abbe56e057f20f883e', '测试用户1', '这是测试用户', 5, 50, 3, 1),
('test2', 'e10adc3949ba59abbe56e057f20f883e', '测试用户2', '喜欢分享生活', 8, 80, 7, 1)
ON DUPLICATE KEY UPDATE `nickname` = VALUES(`nickname`);

-- 插入测试文章数据
INSERT INTO `article` (`user_id`, `content`, `article_type`, `like_count`, `comment_count`, `status`) VALUES
(2, '今天天气真好，出来散步啦！😊', 1, 10, 2, 1),
(3, '分享今天的美食，味道超赞！🍜', 1, 20, 5, 1),
(2, '分享一下最近看的电影，推荐给大家！🎬', 1, 15, 3, 1)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- 显示数据库表创建成功信息
SELECT '数据库表创建成功！' AS message;
SHOW TABLES;
