-- 测试账号数据
USE content_share;

-- 插入测试用户（密码123456的MD5值）
INSERT INTO `user` (`username`, `password`, `nickname`, `bio`, `location`, `follow_count`, `fans_count`, `article_count`, `status`) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员', '系统管理员账号', '北京', 5, 100, 10, 1),
('zhangsan', 'e10adc3949ba59abbe56e057f20f883e', '张三', '热爱生活的摄影师', '北京', 50, 200, 15, 1),
('lisi', 'e10adc3949ba59abbe56e057f20f883e', '李四', '美食爱好者', '上海', 80, 150, 20, 1),
('wangwu', 'e10adc3949ba59abbe56e057f20f883e', '王五', '科技达人', '深圳', 100, 300, 25, 1),
('zhaoliu', 'e10adc3949ba59abbe56e057f20f883e', '赵六', '旅游达人', '成都', 120, 400, 30, 1),
('sunqi', 'e10adc3949ba59abbe56e057f20f883e', '孙七', '健身教练', '广州', 90, 250, 18, 1),
('xiaohong', 'e10adc3949ba59abbe56e057f20f883e', '小红', '美妆博主', '杭州', 150, 500, 40, 1),
('xiaoming', 'e10adc3949ba59abbe56e057f20f883e', '小明', '学生一枚', '武汉', 60, 180, 12, 1),
('xiaomei', 'e10adc3949ba59abbe56e057f20f883e', '小美', '音乐爱好者', '西安', 70, 220, 16, 1),
('test1', 'e10adc3949ba59abbe56e057f20f883e', '测试用户1', '这是测试用户', '北京', 30, 80, 8, 1),
('test2', 'e10adc3949ba59abbe56e057f20f883e', '测试用户2', '喜欢分享生活', '上海', 40, 120, 10, 1)
ON DUPLICATE KEY UPDATE `nickname` = VALUES(`nickname`);

-- 验证插入
SELECT id, username, nickname FROM `user` WHERE username IN ('admin', 'zhangsan', 'lisi', 'wangwu', 'zhaoliu', 'sunqi', 'xiaohong', 'xiaoming', 'xiaomei', 'test1', 'test2');
