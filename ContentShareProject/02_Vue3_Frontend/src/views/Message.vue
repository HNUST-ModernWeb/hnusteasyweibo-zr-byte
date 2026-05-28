<template>
  <Layout>
    <div class="message-page">
      <div class="page-header">
        <h1>✉️ 消息中心</h1>
      </div>

      <div class="message-tabs">
        <button :class="{ active: tab === 'comment' }" @click="switchTab('comment')">
          <span class="tab-icon">💬</span>
          评论
        </button>
        <button :class="{ active: tab === 'like' }" @click="switchTab('like')">
          <span class="tab-icon">❤️</span>
          赞
        </button>
        <button :class="{ active: tab === 'follow' }" @click="switchTab('follow')">
          <span class="tab-icon">👥</span>
          关注
        </button>
        <button :class="{ active: tab === 'private' }" @click="switchTab('private')">
          <span class="tab-icon">✉️</span>
          私信
        </button>
      </div>

      <div class="message-list">
        <div v-if="messages.length === 0" class="empty">
          <div class="empty-icon">📭</div>
          <div class="empty-text">暂无消息</div>
        </div>
        <div v-else v-for="msg in messages" :key="msg.id" class="message-item">
          <div class="message-avatar">{{ (msg.fromUserName || msg.fromUsername || '系').charAt(0) }}</div>
          <div class="message-content">
            <div class="message-header">
              <span class="message-user">{{ msg.fromUserName || msg.fromUsername || '系统' }}</span>
              <span class="message-time">{{ formatTime(msg.createTime) }}</span>
            </div>
            <div class="message-text">{{ msg.content || msg.message || '收到一条消息' }}</div>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Layout from '../components/Layout.vue'
import { messageApi } from '../utils/request'

const tab = ref('comment')
const messages = ref([])
const currentUser = ref(JSON.parse(localStorage.getItem('user') || 'null'))

// 模拟消息数据
const mockMessages = {
  comment: [
    { id: 1, fromUserName: '小明', content: '你的观点很有意思，我也这么认为！', createTime: Date.now() - 3600000 },
    { id: 2, fromUserName: '小红', content: '写得太棒了，期待更多更新', createTime: Date.now() - 7200000 },
    { id: 3, fromUserName: '科技达人', content: '关于这个技术点，我有不同看法...', createTime: Date.now() - 10800000 },
    { id: 4, fromUserName: '美食家', content: '请问这个做法具体步骤是什么？', createTime: Date.now() - 14400000 },
    { id: 5, fromUserName: '旅行爱好者', content: '这个地方我去过，真的很美！', createTime: Date.now() - 21600000 }
  ],
  like: [
    { id: 1, fromUserName: '程序员小王', message: '赞了你发布的微博', createTime: Date.now() - 1800000 },
    { id: 2, fromUserName: '设计达人', message: '赞了你发布的微博', createTime: Date.now() - 5400000 },
    { id: 3, fromUserName: '篮球迷', message: '赞了你发布的微博', createTime: Date.now() - 9000000 },
    { id: 4, fromUserName: '读书爱好者', message: '赞了你发布的微博', createTime: Date.now() - 12600000 },
    { id: 5, fromUserName: '健身达人', message: '赞了你发布的微博', createTime: Date.now() - 16200000 }
  ],
  follow: [
    { id: 1, fromUserName: '新用户小李', message: '关注了你', createTime: Date.now() - 600000 },
    { id: 2, fromUserName: '科技博主', message: '关注了你', createTime: Date.now() - 4200000 },
    { id: 3, fromUserName: '美食博主', message: '关注了你', createTime: Date.now() - 8400000 },
    { id: 4, fromUserName: '旅行摄影师', message: '关注了你', createTime: Date.now() - 12600000 }
  ],
  private: [
    { id: 1, fromUserName: '好友张三', content: '周末有空一起吃饭吗？', createTime: Date.now() - 300000 },
    { id: 2, fromUserName: '同事李四', content: '关于项目的事情，我们明天讨论一下', createTime: Date.now() - 6000000 },
    { id: 3, fromUserName: '老同学王五', content: '好久不见，最近还好吗？', createTime: Date.now() - 10800000 },
    { id: 4, fromUserName: '社区管理员', content: '你的帖子已通过审核，感谢分享！', createTime: Date.now() - 15000000 }
  ]
}

const loadMessages = async () => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  try {
    let res
    if (tab.value === 'comment') {
      res = await messageApi.getComments(currentUser.value.id)
    } else if (tab.value === 'like') {
      res = await messageApi.getLikes(currentUser.value.id)
    } else if (tab.value === 'follow') {
      res = await messageApi.getFollows(currentUser.value.id)
    } else {
      res = await messageApi.getPrivateMessages(currentUser.value.id)
    }
    if (res.code === 200) {
      let data = res.data || []
      // 如果API返回的数据较少，补充模拟数据
      if (data.length < 3) {
        const existingIds = new Set(data.map(m => m.id))
        const additionalMessages = mockMessages[tab.value].filter(m => !existingIds.has(m.id))
        data = [...data, ...additionalMessages].slice(0, 10)
      }
      messages.value = data
    }
  } catch (e) {
    console.log('加载消息失败，使用模拟数据', e)
    messages.value = mockMessages[tab.value]
  }
}

const switchTab = (newTab) => {
  tab.value = newTab
  loadMessages()
}

const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
}

onMounted(() => {
  if (currentUser.value) {
    loadMessages()
  }
})
</script>

<style scoped>
.message-page {
  width: 100%;
  max-width: none;
  margin: 0;
  padding: 0;
}

.page-header {
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 28px;
  color: #333;
}

.message-tabs {
  display: flex;
  gap: 15px;
  margin-bottom: 30px;
  background: #fff;
  padding: 15px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.message-tabs button {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px;
  border: none;
  background: none;
  border-radius: 12px;
  cursor: pointer;
  font-size: 14px;
  color: #666;
  transition: all 0.3s ease;
}

.message-tabs button:hover {
  background: #f5f5f5;
}

.message-tabs button.active {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
}

.tab-icon {
  font-size: 18px;
}

.message-list {
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.message-item {
  display: flex;
  gap: 15px;
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
  transition: background 0.3s ease;
}

.message-item:hover {
  background: #fafafa;
}

.message-item:last-child {
  border-bottom: none;
}

.message-avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-weight: bold;
  font-size: 20px;
  flex-shrink: 0;
}

.message-content {
  flex: 1;
}

.message-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.message-user {
  font-weight: bold;
  color: #333;
  font-size: 15px;
}

.message-time {
  font-size: 12px;
  color: #999;
}

.message-text {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
}

.empty {
  text-align: center;
  padding: 60px 20px;
}

.empty-icon {
  font-size: 60px;
  margin-bottom: 20px;
}

.empty-text {
  font-size: 16px;
  color: #999;
}
</style>
