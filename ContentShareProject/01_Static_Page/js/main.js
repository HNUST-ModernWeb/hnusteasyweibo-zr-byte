// 模拟数据
const articleData = [
    {
        id: 1,
        title: "欢迎使用内容分享平台",
        content: "这是首页信息流展示区域，所有用户发布的内容都会展示在这里。",
        username: "测试用户",
        time: "2026-04-20 10:30"
    },
    {
        id: 2,
        title: "项目介绍",
        content: "本项目完成静态页面、Vue3改造、后端开发、前后端完整整合全流程。",
        username: "测试用户",
        time: "2026-04-20 09:20"
    }
];

// 页面加载渲染
window.onload = function () {
    const box = document.getElementById('articleList');
    let html = '';
    articleData.forEach(item => {
        html += `
            <div class="card">
                <h3>${item.title}</h3>
                <p class="content">${item.content}</p>
                <div class="info">${item.username} · ${item.time}</div>
            </div>
        `;
    });
    box.innerHTML = html;
}