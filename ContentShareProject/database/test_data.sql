-- 测试数据插入脚本
USE content_share;

-- ============================================
-- 插入更多用户数据
-- ============================================
INSERT INTO `user` (`username`, `password`, `nickname`, `avatar`, `bio`, `gender`, `location`, `email`, `is_verified`, `follow_count`, `fans_count`, `article_count`, `like_count`, `status`) VALUES
('zhangsan', 'e10adc3949ba59abbe56e057f20f883e', '张三', 'https://api.dicebear.com/7.x/avataaars/svg?seed=zhangsan', '热爱生活的摄影师📷', 1, '北京', 'zhangsan@example.com', 1, 50, 120, 25, 300, 1),
('lisi', 'e10adc3949ba59abbe56e057f20f883e', '李四', 'https://api.dicebear.com/7.x/avataaars/svg?seed=lisi', '美食爱好者🍜', 2, '上海', 'lisi@example.com', 0, 30, 80, 18, 150, 1),
('wangwu', 'e10adc3949ba59abbe56e057f20f883e', '王五', 'https://api.dicebear.com/7.x/avataaars/svg?seed=wangwu', '科技达人💻', 1, '深圳', 'wangwu@example.com', 1, 40, 200, 32, 500, 1),
('zhaoliu', 'e10adc3949ba59abbe56e057f20f883e', '赵六', 'https://api.dicebear.com/7.x/avataaars/svg?seed=zhaoliu', '旅游达人✈️', 2, '成都', 'zhaoliu@example.com', 0, 60, 150, 28, 200, 1),
('sunqi', 'e10adc3949ba59abbe56e057f20f883e', '孙七', 'https://api.dicebear.com/7.x/avataaars/svg?seed=sunqi', '健身教练💪', 1, '广州', 'sunqi@example.com', 1, 35, 90, 15, 120, 1),
('xiaohong', 'e10adc3949ba59abbe56e057f20f883e', '小红', 'https://api.dicebear.com/7.x/avataaars/svg?seed=xiaohong', '美妆博主💄', 2, '杭州', 'xiaohong@example.com', 1, 80, 300, 45, 800, 1),
('xiaoming', 'e10adc3949ba59abbe56e057f20f883e', '小明', 'https://api.dicebear.com/7.x/avataaars/svg?seed=xiaoming', '学生一枚📚', 1, '武汉', 'xiaoming@example.com', 0, 25, 45, 12, 80, 1),
('xiaomei', 'e10adc3949ba59abbe56e057f20f883e', '小美', 'https://api.dicebear.com/7.x/avataaars/svg?seed=xiaomei', '音乐爱好者🎵', 2, '西安', 'xiaomei@example.com', 0, 42, 78, 20, 150, 1)
ON DUPLICATE KEY UPDATE `nickname` = VALUES(`nickname`);

-- ============================================
-- 更新article表，添加更多字段（如果没有的话）
-- ============================================
ALTER TABLE `article` ADD COLUMN IF NOT EXISTS `view_count` INT DEFAULT 0 COMMENT '浏览数';

-- ============================================
-- 插入更多文章数据
-- ============================================
INSERT INTO `article` (`user_id`, `content`, `images`, `location`, `article_type`, `like_count`, `comment_count`, `forward_count`, `view_count`, `status`) VALUES
(2, '今天去了趟长城，天气超好！🏔️ 终于亲眼看到了长城的雄伟壮观，真的太震撼了！强烈推荐大家有空的时候去走走。', '["https://picsum.photos/400/300?random=1","https://picsum.photos/400/300?random=2"]', '北京·八达岭长城', 1, 156, 23, 12, 1500, 1),
(3, '分享一道超级好吃的红烧肉做法🍖\n1. 五花肉切块焯水\n2. 冰糖炒色\n3. 加生抽、老抽、料酒\n4. 小火炖1小时\n绝对好吃到停不下来！', '["https://picsum.photos/400/300?random=3"]', '上海·家中厨房', 1, 234, 45, 67, 3200, 1),
(4, '最新入手的MacBook Pro M3，性能太强了！💻 编程、剪辑、设计全都不在话下，续航也很给力。强烈推荐给需要高性能笔记本的朋友们！', NULL, NULL, 1, 189, 34, 28, 2800, 1),
(5, '成都三日游攻略🏯\nDay1: 宽窄巷子、锦里\nDay2: 熊猫基地、都江堰\nDay3: 青城山\n美食推荐：串串、火锅、担担面\n真的太适合旅游了！', '["https://picsum.photos/400/300?random=4","https://picsum.photos/400/300?random=5","https://picsum.photos/400/300?random=6"]', '成都', 1, 312, 78, 156, 5000, 1),
(6, '今天的健身计划完成！💪\n🏃 跑步30分钟\n🏋️ 深蹲4组\n🤸 硬拉3组\n坚持就是胜利，加油！', NULL, '广州·健身房', 3, 98, 15, 5, 800, 1),
(7, '【新品试色】MAC #Ruby Woo💄\n这个颜色真的太绝了！显白又有气质，涂上瞬间气场全开。适合所有肤色的姐妹！\n#美妆 #口红 #种草', '["https://picsum.photos/400/300?random=7"]', '杭州', 1, 567, 123, 89, 8000, 1),
(8, '期末考试终于结束了！📚 感觉整个人都轻松了，不管结果如何，努力过就不后悔。接下来要好好放松一下~', NULL, '武汉·大学校园', 3, 145, 32, 8, 1200, 1),
(9, '分享一首最近单曲循环的歌🎵\n《岁月神偷》- 金玟岐\n"时间是让人猝不及防的东西"\n歌词真的太戳心了，推荐给大家！', NULL, '西安', 3, 203, 41, 25, 2500, 1),
(2, '【摄影技巧】如何拍出好看的逆光照片？📷\n1. 选择合适的时间（日落前1小时）\n2. 使用点测光\n3. 适当欠曝保留细节\n4. 后期调整色温', '["https://picsum.photos/400/300?random=8","https://picsum.photos/400/300?random=9"]', NULL, 1, 287, 56, 43, 3500, 1),
(3, '周末在家做了一顿丰盛的早餐🥐\n牛油果吐司+煎蛋+咖啡\n简单又美味，开启美好的一天！', '["https://picsum.photos/400/300?random=10"]', '上海', 1, 178, 29, 15, 2000, 1),
(4, 'AI发展太快了，ChatGPT、Midjourney、Sora... 感觉再不学习就要被淘汰了。各位程序员们，你们有危机感吗？🤔', NULL, NULL, 3, 345, 89, 67, 6000, 1),
(5, '成都美食清单📝\n1. 玉林串串香\n2. 大龙燚火锅\n3. 降龙爪爪\n4. 甜皮鸭\n5. 蛋烘糕\n亲测好吃不踩雷！', '["https://picsum.photos/400/300?random=11"]', '成都', 1, 423, 67, 134, 4500, 1),
(6, '今日份妆容分享💄\n眼影：橘棕色系\n口红：MAC chili\n腮红：NARS高潮\n整体妆感很日常，适合上班族和学生党~', '["https://picsum.photos/400/300?random=12"]', '杭州', 1, 689, 145, 98, 9500, 1),
(7, '大学四年就这样结束了🎓 感谢老师的教导，感谢朋友的陪伴。希望未来可期，我们顶峰相见！', NULL, '武汉', 3, 234, 56, 23, 3000, 1),
(8, '终于去了心心念念的大唐不夜城！🏮 夜景真的太美了，仿佛穿越回了唐朝。不夜城果然名不虚传！', '["https://picsum.photos/400/300?random=13","https://picsum.photos/400/300?random=14"]', '西安·大唐不夜城', 1, 356, 78, 45, 4200, 1)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- ============================================
-- 插入关注关系
-- ============================================
INSERT INTO `follow` (`user_id`, `follow_user_id`, `is_special`) VALUES
(2, 3, 0), (2, 4, 1), (2, 6, 0), (2, 7, 0),
(3, 2, 0), (3, 5, 0), (3, 6, 1),
(4, 2, 0), (4, 3, 0), (4, 5, 0), (4, 6, 0), (4, 7, 0),
(5, 2, 0), (5, 3, 1), (5, 6, 0),
(6, 2, 0), (6, 3, 0), (6, 4, 0), (6, 5, 0), (6, 7, 0), (6, 8, 0), (6, 9, 0),
(7, 2, 0), (7, 3, 0), (7, 6, 1),
(8, 2, 0), (8, 6, 0),
(9, 2, 0), (9, 3, 0), (9, 6, 0)
ON DUPLICATE KEY UPDATE `is_special` = VALUES(`is_special`);

-- ============================================
-- 插入点赞记录
-- ============================================
INSERT INTO `article_like` (`user_id`, `article_id`) VALUES
(2, 4), (2, 5), (2, 7), (2, 10), (2, 13),
(3, 1), (3, 2), (3, 6), (3, 8), (3, 11), (3, 14),
(4, 1), (4, 2), (4, 3), (4, 5), (4, 8), (4, 12),
(5, 1), (5, 2), (5, 4), (5, 7), (5, 9), (5, 11),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6), (6, 8), (6, 9), (6, 10), (6, 11), (6, 12), (6, 13), (6, 14),
(7, 2), (7, 5), (7, 7), (7, 10), (7, 13),
(8, 1), (8, 2), (8, 7), (8, 10), (8, 14),
(9, 1), (9, 3), (9, 6), (9, 8), (9, 11), (9, 13)
ON DUPLICATE KEY UPDATE `user_id` = VALUES(`user_id`);

-- ============================================
-- 插入评论数据
-- ============================================
INSERT INTO `comment` (`article_id`, `user_id`, `parent_id`, `content`, `like_count`) VALUES
(1, 3, 0, '照片拍得真好看！是在日出时分拍的吗？', 25),
(1, 2, 1, '谢谢！是的，早上6点左右，光线特别好', 10),
(1, 4, 0, '长城真的很壮观，有机会一定要去一次', 18),
(2, 4, 0, '看起来太美味了！请问五花肉要选多厚的？', 15),
(2, 3, 4, '我选的是2-3厘米厚的，炖出来口感最好', 8),
(2, 5, 0, '收藏了！今晚就试试做', 22),
(4, 2, 0, 'M3确实很强，我也在考虑要不要入手', 30),
(4, 4, 1, '真的好用，不过价格也不便宜😂', 12),
(4, 6, 0, '程序员必备！有没有遇到兼容性问题？', 20),
(5, 6, 0, '成都攻略太全了！正好下周要去，收藏了', 45),
(5, 5, 6, '成都真的很值得去，祝你玩得开心~', 15),
(7, 8, 0, '这个颜色绝了！黄皮友好吗？', 35),
(7, 7, 7, '超级友好！我就是黄皮，亲测显白', 20),
(10, 9, 0, '逆光拍摄技巧很实用，学到了！', 28),
(11, 5, 0, '早餐看起来好丰盛，厨艺不错呀', 16),
(13, 8, 0, 'MAC chili 确实经典，我已经回购两次了', 40),
(13, 7, 12, '哈哈哈，因为真的很好用呀', 10),
(14, 6, 0, '毕业快乐！未来可期🌟', 50)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- ============================================
-- 插入收藏记录
-- ============================================
INSERT INTO `favorite` (`user_id`, `article_id`) VALUES
(2, 2), (2, 5), (2, 7), (2, 10),
(3, 1), (3, 4), (3, 8), (3, 12),
(4, 2), (4, 5), (4, 7), (4, 11), (4, 13),
(5, 1), (5, 4), (5, 9),
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 8), (6, 9), (6, 10), (6, 11), (6, 12), (6, 13), (6, 14),
(7, 2), (7, 7), (7, 13),
(8, 1), (8, 5), (8, 10), (8, 14),
(9, 2), (9, 6), (9, 11)
ON DUPLICATE KEY UPDATE `user_id` = VALUES(`user_id`);

-- ============================================
-- 插入私信消息
-- ============================================
INSERT INTO `message` (`from_user_id`, `to_user_id`, `content`, `message_type`, `is_read`) VALUES
(2, 3, '你好呀！看了你的美食分享，真的太诱人了！', 1, 1),
(3, 2, '哈哈，谢谢！有机会请你吃饭~', 1, 1),
(2, 3, '真的吗？那太好了！', 1, 1),
(4, 2, '摄影技术很棒，能教教我怎么拍逆光吗？', 1, 0),
(2, 4, '没问题，有空可以一起出去拍~', 1, 1),
(6, 7, '你的美妆教程对我帮助很大！', 1, 1),
(7, 6, '谢谢支持！有问题随时问我~', 1, 1),
(8, 5, '成都攻略太详细了，谢谢分享！', 1, 1),
(5, 8, '不客气，成都真的很值得去！', 1, 0)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`);

-- ============================================
-- 更新话题表，添加更多话题
-- ============================================
INSERT INTO `topic` (`name`, `description`, `participant_count`, `article_count`, `heat_score`, `category`) VALUES
('摄影', '分享摄影技巧和作品', 500, 250, 85, 'lifestyle'),
('美食', '各地美食推荐与制作', 800, 600, 95, 'lifestyle'),
('科技', '最新科技资讯', 600, 400, 88, 'tech'),
('旅游', '旅行攻略与见闻', 450, 300, 75, 'lifestyle'),
('健身', '健身心得与方法', 350, 200, 70, 'health'),
('美妆', '美妆教程与产品推荐', 700, 500, 90, 'fashion'),
('音乐', '音乐分享与讨论', 400, 250, 72, 'entertainment'),
('学习', '学习方法与成长', 380, 180, 68, 'education')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

-- ============================================
-- 更新热搜表，添加更多热搜
-- ============================================
INSERT INTO `hot_search` (`keyword`, `search_count`, `rank`, `category`) VALUES
('梅西来中国', 15000, 1, 'real_time'),
('高考成绩公布', 12000, 2, 'real_time'),
('夏季达沃斯论坛', 9800, 3, 'real_time'),
('成都演唱会', 8500, 4, 'entertainment'),
('AI大模型新突破', 7200, 5, 'tech'),
('618购物节', 6800, 6, 'social'),
('新上映电影', 6500, 7, 'entertainment'),
('明星八卦', 6200, 8, 'entertainment'),
('国际新闻', 5800, 9, 'social'),
('科技新品发布', 5500, 10, 'tech')
ON DUPLICATE KEY UPDATE `search_count` = VALUES(`search_count`);

-- ============================================
-- 插入用户标签
-- ============================================
INSERT INTO `user_tag` (`user_id`, `tag_name`) VALUES
(2, '摄影'),
(2, '旅行'),
(2, '美食'),
(3, '美食'),
(3, '烹饪'),
(4, '科技'),
(4, '数码'),
(5, '旅行'),
(5, '摄影'),
(6, '健身'),
(6, '运动'),
(7, '美妆'),
(7, '时尚'),
(8, '学习'),
(8, '音乐'),
(9, '旅行'),
(9, '美食')
ON DUPLICATE KEY UPDATE `tag_name` = VALUES(`tag_name`);

-- ============================================
-- 更新用户统计信息
-- ============================================
UPDATE `user` SET follow_count = (SELECT COUNT(*) FROM `follow` WHERE `user`.id = `follow`.user_id);
UPDATE `user` SET fans_count = (SELECT COUNT(*) FROM `follow` WHERE `user`.id = `follow`.follow_user_id);
UPDATE `user` SET article_count = (SELECT COUNT(*) FROM `article` WHERE `user`.id = `article`.user_id AND `article`.status = 1);
UPDATE `user` SET like_count = (SELECT COUNT(*) FROM `article_like` WHERE `user`.id = `article_like`.user_id);

-- 显示插入结果
SELECT '测试数据插入完成！' AS message;
SELECT COUNT(*) AS user_count FROM `user`;
SELECT COUNT(*) AS article_count FROM `article`;
SELECT COUNT(*) AS comment_count FROM `comment`;
SELECT COUNT(*) AS follow_count FROM `follow`;
