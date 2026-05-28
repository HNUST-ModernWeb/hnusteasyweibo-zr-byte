USE content_share;

-- 先清空文章表，确保数据干净
TRUNCATE TABLE article;

-- 重新插入测试文章
INSERT INTO article (id, user_id, content, like_count, view_count, forward_count, comment_count, status, location, create_time) VALUES
(1, 5, '今天天气真好！出门拍照去📸', 100, 1000, 10, 5, 1, '北京·朝阳区', NOW()),
(2, 5, '分享一组长城摄影作品🇨🇳', 250, 3000, 25, 15, 1, '北京·八达岭', NOW()),
(3, 5, '新买的相机到了，太激动了！', 180, 2000, 12, 8, 1, NULL, NOW()),
(4, 6, '红烧肉做法，简单又美味！🥘', 320, 4000, 45, 30, 1, '上海·浦东新区', NOW()),
(5, 6, '周末探店美食推荐🍜', 150, 1800, 20, 12, 1, '上海·静安区', NOW()),
(6, 7, 'MacBook Pro M3使用体验💻', 450, 5000, 50, 35, 1, '深圳·南山区', NOW()),
(7, 7, 'AI大模型最新进展🚀', 280, 3500, 30, 22, 1, NULL, NOW()),
(8, 8, '成都三日游攻略📍', 380, 4500, 42, 28, 1, '成都·锦江区', NOW()),
(9, 8, '大熊猫太可爱了🐼', 200, 2500, 25, 18, 1, '成都·成华区', NOW()),
(10, 9, '健身打卡第30天💪', 160, 1900, 15, 12, 1, '广州·天河区', NOW()),
(11, 10, 'MAC口红试色💄', 520, 6000, 68, 45, 1, '杭州·西湖区', NOW()),
(12, 10, '美妆教程分享✨', 340, 4000, 42, 30, 1, NULL, NOW());

-- 验证插入
SELECT '文章插入成功！' AS result;
SELECT COUNT(*) AS article_count FROM article;
SELECT id, user_id, content, like_count, status FROM article ORDER BY like_count DESC;
