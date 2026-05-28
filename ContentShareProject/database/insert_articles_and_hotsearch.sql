USE content_share;

-- ============================================
-- 插入测试文章数据
-- ============================================

INSERT INTO article (user_id, content, like_count, view_count, forward_count, comment_count, status, location, create_time) VALUES
-- zhangsan (ID=5) 的文章
(5, '今天天气真好！出门拍照去📸', 100, 1000, 10, 5, 1, '北京·朝阳区', NOW()),
(5, '分享一组长城摄影作品🇨🇳', 250, 3000, 25, 15, 1, '北京·八达岭', NOW() - INTERVAL 1 DAY),
(5, '新买的相机到了，太激动了！', 180, 2000, 12, 8, 1, NULL, NOW() - INTERVAL 2 DAY),
-- lisi (ID=6) 的文章
(6, '红烧肉做法，简单又美味！🥘', 320, 4000, 45, 30, 1, '上海·浦东新区', NOW()),
(6, '周末探店美食推荐🍜', 150, 1800, 20, 12, 1, '上海·静安区', NOW() - INTERVAL 1 DAY),
(6, '在家做川菜，麻辣鲜香🌶️', 200, 2500, 18, 10, 1, '上海·徐汇区', NOW() - INTERVAL 3 DAY),
-- wangwu (ID=7) 的文章
(7, 'MacBook Pro M3使用体验💻 性能真的太强了！', 450, 5000, 50, 35, 1, '深圳·南山区', NOW()),
(7, 'AI大模型最新进展🚀 未来已来！', 280, 3500, 30, 22, 1, NULL, NOW() - INTERVAL 1 DAY),
(7, '程序员的一天都在写bug吗😂', 380, 4200, 55, 40, 1, '深圳·福田区', NOW() - INTERVAL 2 DAY),
-- zhaoliu (ID=8) 的文章
(8, '成都三日游攻略📍 超详细路线分享！', 380, 4500, 42, 28, 1, '成都·锦江区', NOW()),
(8, '大熊猫太可爱了🐼 萌化了！', 200, 2500, 25, 18, 1, '成都·成华区', NOW() - INTERVAL 1 DAY),
(8, '成都火锅推荐🔥 必吃清单', 290, 3200, 35, 20, 1, '成都·武侯区', NOW() - INTERVAL 2 DAY),
-- sunqi (ID=9) 的文章
(9, '健身打卡第30天💪 坚持就是胜利！', 160, 1900, 15, 12, 1, '广州·天河区', NOW()),
(9, '今日早餐打卡🍳 营养均衡很重要', 90, 1100, 8, 5, 1, NULL, NOW() - INTERVAL 1 DAY),
(9, '跑步10公里完成！🏃‍♂️', 130, 1600, 12, 8, 1, '广州·海珠区', NOW() - INTERVAL 2 DAY),
-- xiaohong (ID=10) 的文章
(10, 'MAC口红试色💄 今日份的心动色号', 520, 6000, 68, 45, 1, '杭州·西湖区', NOW()),
(10, '美妆教程分享✨ 新手也能学会', 340, 4000, 42, 30, 1, NULL, NOW() - INTERVAL 1 DAY),
(10, '今日穿搭👗 简约风格也很美', 210, 2800, 28, 18, 1, '杭州·滨江区', NOW() - INTERVAL 2 DAY)
ON DUPLICATE KEY UPDATE content = VALUES(content);

-- ============================================
-- 插入热搜数据（按真实搜索次数排序）
-- ============================================

INSERT INTO hot_search (keyword, search_count, rank, category, is_blocked, create_time) VALUES
('梅西来中国', 15000, 1, 'real_time', 0, NOW()),
('高考成绩公布', 12000, 2, 'real_time', 0, NOW()),
('618购物节', 9800, 3, 'real_time', 0, NOW()),
('成都演唱会', 8500, 4, 'entertainment', 0, NOW()),
('AI大模型新突破', 7200, 5, 'tech', 0, NOW()),
('新上映电影', 6500, 6, 'entertainment', 0, NOW()),
('明星八卦', 6200, 7, 'entertainment', 0, NOW()),
('国际新闻', 5800, 8, 'social', 0, NOW()),
('科技新品发布', 5500, 9, 'tech', 0, NOW()),
('社会热点', 5000, 10, 'social', 0, NOW())
ON DUPLICATE KEY UPDATE search_count = VALUES(search_count);

-- ============================================
-- 更新用户的文章数量
-- ============================================

UPDATE user u SET article_count = (
    SELECT COUNT(*) FROM article a WHERE a.user_id = u.id AND a.status = 1
);

-- ============================================
-- 验证数据
-- ============================================

SELECT '📊 数据统计：' AS '';
SELECT CONCAT('总用户数: ', COUNT(*)) AS stat FROM user WHERE status = 1;
SELECT CONCAT('总文章数: ', COUNT(*)) AS stat FROM article WHERE status = 1;
SELECT CONCAT('有位置的文章数: ', COUNT(*)) AS stat FROM article WHERE location IS NOT NULL AND status = 1;
SELECT CONCAT('热搜数: ', COUNT(*)) AS stat FROM hot_search WHERE is_blocked = 0;
