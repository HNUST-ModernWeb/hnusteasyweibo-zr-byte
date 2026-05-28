<template>
  <Layout>
    <div class="topic-detail-page">
      <div v-if="topic" class="topic-header">
        <div class="topic-info">
          <h1>#{{ topic.name }}#</h1>
          <p class="topic-desc">{{ topic.description || '暂无描述' }}</p>
          <div class="topic-stats">
            <span>📝 {{ topic.articleCount || 0 }} 讨论</span>
            <span>👥 {{ topic.participantCount || 0 }} 参与</span>
            <span>🔥 {{ topic.heatScore || 0 }} 热度</span>
          </div>
        </div>
        <button v-if="!isJoined" @click="handleJoin" class="join-btn">参与讨论</button>
        <button v-else class="joined-btn">已参与</button>
      </div>

      <div class="article-list">
        <div v-if="loading" class="loading">加载中...</div>
        <div v-else-if="articles.length === 0" class="empty">
          <div class="empty-icon">💬</div>
          <div class="empty-text">暂无讨论</div>
          <div class="empty-hint">快来参与话题讨论吧！</div>
        </div>
        <ArticleCard v-else v-for="item in articles" :key="item.id" :article="item" />
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import Layout from '../components/Layout.vue'
import ArticleCard from '../components/ArticleCard.vue'
import { topicApi, articleApi } from '../utils/request'

const route = useRoute()
const topic = ref(null)
const articles = ref([])
const loading = ref(false)
const isJoined = ref(false)

// 模拟讨论数据（统计数据从数据库获取）
const mockArticles = [
  {
    id: 1,
    userId: 2,
    username: '科技达人',
    nickname: '科技达人',
    content: '今天讨论一下AI的发展趋势，感觉现在大模型越来越强大了！',
    image: '',
    likeCount: 0,
    commentCount: 0,
    favoriteCount: 0,
    forwardCount: 0,
    createTime: Date.now() - 3600000,
    isLiked: false,
    isFavorited: false
  },
  {
    id: 2,
    userId: 3,
    username: '程序员小王',
    nickname: '程序员小王',
    content: '同意楼上的观点，AI确实正在改变我们的生活和工作方式。但是也要注意数据隐私的问题。',
    image: '',
    likeCount: 0,
    commentCount: 0,
    favoriteCount: 0,
    forwardCount: 0,
    createTime: Date.now() - 7200000,
    isLiked: false,
    isFavorited: false
  },
  {
    id: 3,
    userId: 4,
    username: '数据分析师',
    nickname: '数据分析师',
    content: '最近在研究AI在数据分析领域的应用，发现很多重复性工作都可以交给AI来做了，效率提升了很多！',
    image: '',
    likeCount: 0,
    commentCount: 0,
    favoriteCount: 0,
    forwardCount: 0,
    createTime: Date.now() - 10800000,
    isLiked: false,
    isFavorited: false
  },
  {
    id: 4,
    userId: 5,
    username: '产品经理小李',
    nickname: '产品经理小李',
    content: '作为产品经理，我觉得AI最大的价值在于能够帮助我们更好地理解用户需求，做出更精准的产品决策。',
    image: '',
    likeCount: 0,
    commentCount: 0,
    favoriteCount: 0,
    forwardCount: 0,
    createTime: Date.now() - 14400000,
    isLiked: false,
    isFavorited: false
  },
  {
    id: 5,
    userId: 6,
    username: '创业者老张',
    nickname: '创业者老张',
    content: '创业公司现在都在积极拥抱AI，用AI来提升效率、降低成本。但是也要谨慎选择，不要盲目跟风。',
    image: '',
    likeCount: 0,
    commentCount: 0,
    favoriteCount: 0,
    forwardCount: 0,
    createTime: Date.now() - 18000000,
    isLiked: false,
    isFavorited: false
  },
  {
    id: 6,
    userId: 7,
    username: '学生小明',
    nickname: '学生小明',
    content: '作为一名学生，我觉得AI是一把双刃剑。一方面可以帮助我们学习，另一方面也可能让我们变得懒惰。关键在于如何正确使用。',
    image: '',
    likeCount: 0,
    commentCount: 0,
    favoriteCount: 0,
    forwardCount: 0,
    createTime: Date.now() - 21600000,
    isLiked: false,
    isFavorited: false
  }
]

const loadTopic = async () => {
  try {
    const res = await topicApi.getById(route.params.id)
    if (res.code === 200) {
      topic.value = res.data
    }
  } catch (e) {
    console.log('加载话题失败', e)
    // 使用模拟话题数据
    topic.value = {
      id: route.params.id,
      name: 'AI人工智能',
      description: '讨论人工智能技术发展和应用探讨',
      articleCount: 6,
      participantCount: 1234,
      heatScore: 5432,
      category: 'tech'
    }
  }
}

const loadArticles = async () => {
  loading.value = true
  try {
    const res = await articleApi.getByTopic(route.params.id)
    if (res.code === 200) {
      let data = res.data || []
      // 如果API返回的数据较少，补充模拟数据
      if (data.length < 3) {
        const existingIds = new Set(data.map(a => a.id))
        const additionalArticles = mockArticles.filter(a => !existingIds.has(a.id))
        data = [...data, ...additionalArticles].slice(0, 10)
      }
      articles.value = data
    }
  } catch (e) {
    console.log('加载文章失败，使用模拟数据', e)
    articles.value = mockArticles
  }
  loading.value = false
}

const handleJoin = () => {
  isJoined.value = true
  if (topic.value && topic.value.participantCount !== undefined) {
    topic.value.participantCount++
  }
}

onMounted(() => {
  loadTopic()
  loadArticles()
})
</script>

<style scoped>
.topic-detail-page {
  width: 100%;
  max-width: none;
  margin: 0;
  padding: 0;
}

.topic-header {
  background: #fff;
  border-radius: 16px;
  padding: 30px;
  margin-bottom: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.topic-info h1 {
  font-size: 28px;
  color: #ff6b35;
  margin-bottom: 10px;
}

.topic-desc {
  font-size: 14px;
  color: #666;
  margin-bottom: 15px;
  line-height: 1.6;
}

.topic-stats {
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: #999;
}

.join-btn, .joined-btn {
  padding: 12px 30px;
  border-radius: 25px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.join-btn {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  border: none;
}

.join-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}

.joined-btn {
  background: #f5f5f5;
  color: #666;
  border: 2px solid #e5e5e5;
}

.article-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.loading {
  text-align: center;
  padding: 60px;
  color: #999;
  background: #fff;
  border-radius: 16px;
}

.empty {
  text-align: center;
  padding: 60px;
  background: #fff;
  border-radius: 16px;
}

.empty-icon {
  font-size: 60px;
  margin-bottom: 20px;
}

.empty-text {
  font-size: 18px;
  color: #666;
  margin-bottom: 10px;
}

.empty-hint {
  font-size: 14px;
  color: #999;
}
</style>
