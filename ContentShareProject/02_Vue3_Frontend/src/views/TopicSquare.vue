<template>
  <Layout>
    <div class="topic-square">
      <div class="page-header">
        <h1>💬 话题广场</h1>
        <p>发现热门话题，参与讨论</p>
      </div>

      <div class="topic-categories">
        <button :class="{ active: category === 'all' }" @click="switchCategory('all')">全部</button>
        <button :class="{ active: category === 'realtime' }" @click="switchCategory('realtime')">🔥 实时</button>
        <button :class="{ active: category === 'entertainment' }" @click="switchCategory('entertainment')">🎭 娱乐</button>
        <button :class="{ active: category === 'sports' }" @click="switchCategory('sports')">⚽ 体育</button>
        <button :class="{ active: category === 'tech' }" @click="switchCategory('tech')">💻 科技</button>
        <button :class="{ active: category === 'life' }" @click="switchCategory('life')">🍜 生活</button>
      </div>

      <div class="topic-grid">
        <div v-for="topic in topics" :key="topic.id" class="topic-card">
          <router-link :to="`/topic/${topic.id}`" class="topic-link">
            <div class="topic-header">
              <span class="topic-icon">🏷️</span>
              <h3 class="topic-name">#{{ topic.name }}#</h3>
            </div>
            <p class="topic-desc">{{ topic.description || '暂无描述' }}</p>
            <div class="topic-stats">
              <span class="stat">
                <span class="stat-icon">📝</span>
                {{ topic.articleCount || 0 }} 讨论
              </span>
              <span class="stat">
                <span class="stat-icon">👥</span>
                {{ topic.participantCount || 0 }} 参与
              </span>
              <span class="stat heat">
                <span class="stat-icon">🔥</span>
                {{ topic.heatScore || 0 }} 热度
              </span>
            </div>
          </router-link>
        </div>
      </div>

      <div v-if="topics.length === 0" class="empty">
        <div class="empty-icon">💬</div>
        <div class="empty-text">暂无话题</div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Layout from '../components/Layout.vue'
import { topicApi } from '../utils/request'

const topics = ref([])
const category = ref('all')

// 模拟话题数据（统计数据从数据库获取）
const mockTopics = [
  { id: 1, name: '今日热议', description: '讨论今日最热门的话题和事件', articleCount: 0, participantCount: 0, heatScore: 0, category: 'realtime' },
  { id: 2, name: '明星八卦', description: '娱乐圈最新动态和明星私生活', articleCount: 0, participantCount: 0, heatScore: 0, category: 'entertainment' },
  { id: 3, name: '足球世界杯', description: '2026世界杯最新消息和精彩瞬间', articleCount: 0, participantCount: 0, heatScore: 0, category: 'sports' },
  { id: 4, name: 'AI人工智能', description: '人工智能技术发展和应用探讨', articleCount: 0, participantCount: 0, heatScore: 0, category: 'tech' },
  { id: 5, name: '美食探店', description: '分享各地美食和探店体验', articleCount: 0, participantCount: 0, heatScore: 0, category: 'life' },
  { id: 6, name: '旅行日记', description: '记录旅行中的美好瞬间', articleCount: 0, participantCount: 0, heatScore: 0, category: 'life' },
  { id: 7, name: '手机评测', description: '最新手机测评和使用体验', articleCount: 0, participantCount: 0, heatScore: 0, category: 'tech' },
  { id: 8, name: '电视剧推荐', description: '分享好看的电视剧和观后感', articleCount: 0, participantCount: 0, heatScore: 0, category: 'entertainment' },
  { id: 9, name: '篮球NBA', description: 'NBA最新赛事和球星动态', articleCount: 0, participantCount: 0, heatScore: 0, category: 'sports' },
  { id: 10, name: '股市行情', description: '股票市场分析和投资心得', articleCount: 0, participantCount: 0, heatScore: 0, category: 'realtime' },
  { id: 11, name: '读书分享', description: '好书推荐和阅读感悟', articleCount: 0, participantCount: 0, heatScore: 0, category: 'life' },
  { id: 12, name: '数码科技', description: '最新数码产品和科技资讯', articleCount: 0, participantCount: 0, heatScore: 0, category: 'tech' },
  { id: 13, name: '电影推荐', description: '热门电影推荐和影评', articleCount: 0, participantCount: 0, heatScore: 0, category: 'entertainment' },
  { id: 14, name: '健身打卡', description: '分享健身日常和运动心得', articleCount: 0, participantCount: 0, heatScore: 0, category: 'life' },
  { id: 15, name: '电竞游戏', description: '电子竞技和游戏攻略', articleCount: 0, participantCount: 0, heatScore: 0, category: 'realtime' },
  { id: 16, name: '网球公开赛', description: '网球赛事和球星资讯', articleCount: 0, participantCount: 0, heatScore: 0, category: 'sports' }
]

const loadTopics = async () => {
  try {
    const res = await topicApi.getAll(1, 50)
    if (res.code === 200) {
      let data = res.data || []
      // 如果API返回的数据较少，补充模拟数据
      if (data.length < 8) {
        const existingIds = new Set(data.map(t => t.id))
        const additionalTopics = mockTopics.filter(t => !existingIds.has(t.id))
        data = [...data, ...additionalTopics].slice(0, 16)
      }
      if (category.value !== 'all') {
        data = data.filter(t => t.category === category.value)
      }
      topics.value = data
    }
  } catch (e) {
    console.log('加载话题失败，使用模拟数据', e)
    let data = [...mockTopics]
    if (category.value !== 'all') {
      data = data.filter(t => t.category === category.value)
    }
    topics.value = data
  }
}

const switchCategory = (cat) => {
  category.value = cat
  loadTopics()
}

onMounted(() => {
  loadTopics()
})
</script>

<style scoped>
.topic-square {
  width: 100%;
  max-width: none;
  margin: 0;
  padding: 0;
}

.page-header {
  text-align: center;
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 32px;
  color: #333;
  margin-bottom: 10px;
}

.page-header p {
  font-size: 16px;
  color: #999;
}

.topic-categories {
  display: flex;
  gap: 10px;
  margin-bottom: 30px;
  flex-wrap: wrap;
}

.topic-categories button {
  padding: 10px 20px;
  border: none;
  background: #fff;
  border-radius: 25px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.topic-categories button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.topic-categories button.active {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
}

.topic-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.topic-card {
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.topic-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.topic-link {
  display: block;
  padding: 25px;
  text-decoration: none;
}

.topic-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.topic-icon {
  font-size: 24px;
}

.topic-name {
  font-size: 18px;
  color: #ff6b35;
  margin: 0;
}

.topic-desc {
  font-size: 14px;
  color: #666;
  margin-bottom: 15px;
  line-height: 1.6;
}

.topic-stats {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
}

.stat {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 13px;
  color: #999;
}

.stat-icon {
  font-size: 14px;
}

.stat.heat {
  color: #ff6b35;
}

.empty {
  text-align: center;
  padding: 60px;
}

.empty-icon {
  font-size: 60px;
  margin-bottom: 20px;
}

.empty-text {
  font-size: 18px;
  color: #999;
}
</style>
