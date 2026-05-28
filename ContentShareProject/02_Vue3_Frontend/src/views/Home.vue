<template>
  <Layout>
    <div class="home">
      <div class="main-container">
        <div class="left-sidebar">
          <div class="user-card" v-if="currentUser">
            <div class="user-avatar">{{ (currentUser.nickname || currentUser.username).charAt(0) }}</div>
            <div class="user-name">{{ currentUser.nickname || currentUser.username }}</div>
            <div class="user-stats">
              <div class="stat-item" @click="goToProfile('follow')">
                <span class="stat-num">{{ currentUser.followCount || 0 }}</span>
                <span class="stat-label">关注</span>
              </div>
              <div class="stat-item" @click="goToProfile('fans')">
                <span class="stat-num">{{ currentUser.fansCount || 0 }}</span>
                <span class="stat-label">粉丝</span>
              </div>
              <div class="stat-item" @click="goToProfile('article')">
                <span class="stat-num">{{ currentUser.articleCount || 0 }}</span>
                <span class="stat-label">微博</span>
              </div>
            </div>
          </div>
          <div class="quick-nav">
            <div class="quick-nav-item" @click="goToFavorite">
              <span class="icon">⭐</span>
              <span>收藏</span>
            </div>
            <div class="quick-nav-item" @click="goToLike">
              <span class="icon">👍</span>
              <span>赞过</span>
            </div>
          </div>
        </div>

        <div class="content-area">
          <div class="feed-tabs">
            <button :class="{ active: feedType === 'follow' }" @click="switchFeed('follow')">
              <span class="tab-icon">👥</span> 关注
            </button>
            <button :class="{ active: feedType === 'hot' }" @click="switchFeed('hot')">
              <span class="tab-icon">🔥</span> 热门
            </button>
            <button :class="{ active: feedType === 'nearby' }" @click="switchFeed('nearby')">
              <span class="tab-icon">📍</span> 同城
            </button>
            <button :class="{ active: feedType === 'recommend' }" @click="switchFeed('recommend')">
              <span class="tab-icon">💡</span> 推荐
            </button>
          </div>

          <div class="article-list">
            <ArticleCard
              v-for="item in articleList"
              :key="item.id"
              :article="item"
              :show-follow-btn="true"
              @like="handleLike"
              @favorite="handleFavorite"
              @comment="handleComment"
              @forward="handleForward"
              @follow="handleFollow"
            />
            <div v-if="articleList.length === 0" class="empty">
              <div class="empty-icon">📭</div>
              <div class="empty-text">暂无内容</div>
              <div class="empty-hint">快去发布第一条微博吧！</div>
            </div>
          </div>
        </div>

        <div class="right-sidebar">
          <div class="sidebar-section hot-users">
            <h3>
              <span class="section-icon">🔥</span>
              热门用户
            </h3>
            <div v-for="user in hotUsers" :key="user.id" class="hot-user">
              <div class="user-avatar-small">{{ (user.nickname || user.username).charAt(0) }}</div>
              <router-link :to="`/user/${user.id}`" class="user-link">
                <div class="user-name">{{ user.nickname || user.username }}</div>
                <div class="user-fans">{{ user.fansCount || 0 }} 粉丝</div>
              </router-link>
              <button class="follow-btn" :class="{ followed: user.isFollowing }" @click="handleFollow(user)">
                {{ user.isFollowing ? '已关注' : '关注' }}
              </button>
            </div>
          </div>
          <div class="sidebar-section hot-topics">
            <h3>
              <span class="section-icon">💬</span>
              热门话题
            </h3>
            <div v-for="(topic, index) in hotTopics" :key="topic.id" class="hot-topic">
              <div class="topic-rank" :class="{ top: index < 3 }">{{ index + 1 }}</div>
              <router-link :to="`/topic/${topic.id}`" class="topic-link">
                <div class="topic-name">#{{ topic.name }}#</div>
                <div class="topic-count">{{ topic.articleCount || 0 }} 讨论</div>
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Layout from '../components/Layout.vue'
import ArticleCard from '../components/ArticleCard.vue'
import { articleApi, userApi, topicApi } from '../utils/request'

const router = useRouter()
const articleList = ref([])
const hotUsers = ref([])
const hotTopics = ref([])
const feedType = ref('hot')
const currentUser = ref(JSON.parse(localStorage.getItem('user') || 'null'))

const loadArticles = async () => {
  try {
    let res
    if (feedType.value === 'follow' && currentUser.value) {
      res = await articleApi.getFollowFeed(currentUser.value.id, 1, 20)
    } else if (feedType.value === 'hot') {
      res = await articleApi.getHotFeed(currentUser.value?.id, 1, 20)
    } else if (feedType.value === 'nearby') {
      res = await articleApi.getNearbyFeed(1, 20)
    } else if (feedType.value === 'recommend' && currentUser.value) {
      res = await articleApi.getRecommendFeed(currentUser.value.id, 1, 20)
    } else {
      res = await articleApi.getHotFeed(1, 20)
    }
    if (res.code === 200) {
      articleList.value = res.data || []
    }
  } catch (e) {
    console.log('加载文章列表失败', e)
  }
}

const loadHotUsers = async () => {
  try {
    hotUsers.value = await userApi.getHotUsers(currentUser.value?.id, 5)
  } catch (e) {
    console.log('加载热门用户失败', e)
  }
}

// 模拟热门话题数据（统计数据从数据库获取）
const mockHotTopics = [
  { id: 1, name: '今日热议', articleCount: 0, participantCount: 0, heatScore: 0 },
  { id: 2, name: '明星八卦', articleCount: 0, participantCount: 0, heatScore: 0 },
  { id: 3, name: '足球世界杯', articleCount: 0, participantCount: 0, heatScore: 0 },
  { id: 4, name: 'AI人工智能', articleCount: 0, participantCount: 0, heatScore: 0 },
  { id: 5, name: '美食探店', articleCount: 0, participantCount: 0, heatScore: 0 },
  { id: 6, name: '旅行日记', articleCount: 0, participantCount: 0, heatScore: 0 },
  { id: 7, name: '数码科技', articleCount: 0, participantCount: 0, heatScore: 0 },
  { id: 8, name: '电影推荐', articleCount: 0, participantCount: 0, heatScore: 0 }
]

const loadHotTopics = async () => {
  try {
    const res = await topicApi.getHot(8)
    if (res.code === 200) {
      let data = res.data || []
      // 如果API返回的数据较少，补充模拟数据
      if (data.length < 5) {
        const existingIds = new Set(data.map(t => t.id))
        const additionalTopics = mockHotTopics.filter(t => !existingIds.has(t.id))
        data = [...data, ...additionalTopics].slice(0, 8)
      }
      hotTopics.value = data
    }
  } catch (e) {
    console.log('加载热门话题失败，使用模拟数据', e)
    hotTopics.value = mockHotTopics.slice(0, 8)
  }
}

const switchFeed = (type) => {
  feedType.value = type
  loadArticles()
}

const handleLike = async (article) => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  try {
    if (article.isLiked) {
      await articleApi.unlike(currentUser.value.id, article.id)
    } else {
      await articleApi.like(currentUser.value.id, article.id)
    }
    loadArticles()
  } catch (e) {
    console.log('点赞操作失败', e)
  }
}

const handleFavorite = async (article) => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  try {
    if (article.isFavorited) {
      await articleApi.unfavorite(currentUser.value.id, article.id)
    } else {
      await articleApi.favorite(currentUser.value.id, article.id)
    }
    loadArticles()
  } catch (e) {
    console.log('收藏操作失败', e)
  }
}

const handleComment = (article) => {
  window.location.href = `/article/${article.id}`
}

const handleForward = async (article) => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  const content = prompt('请输入转发语:')
  if (content !== null) {
    try {
      await articleApi.forward(currentUser.value.id, article.id, content)
      alert('转发成功')
      loadArticles()
    } catch (e) {
      console.log('转发失败', e)
    }
  }
}

const goToFavorite = () => {
  router.push({ path: '/profile', query: { tab: 'favorite' } })
}

const goToLike = () => {
  router.push({ path: '/profile', query: { tab: 'like' } })
}

const goToProfile = (tab) => {
  router.push({ path: '/profile', query: { tab } })
}

const handleFollow = async (user) => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  if (!user) return
  try {
    if (user.isFollowing) {
      await userApi.unfollow(currentUser.value.id, user.id)
      if (currentUser.value.followCount !== undefined) {
        currentUser.value.followCount--
      }
    } else {
      await userApi.follow(currentUser.value.id, user.id)
      if (currentUser.value.followCount !== undefined) {
        currentUser.value.followCount++
      }
    }
    // 重新获取用户信息确保数据准确
    const userRes = await userApi.getUserInfo(currentUser.value.id)
    if (userRes.code === 200 && userRes.data) {
      currentUser.value = userRes.data
    }
    localStorage.setItem('user', JSON.stringify(currentUser.value))
    loadArticles()
    loadHotUsers()
  } catch (e) {
    console.log('关注失败', e)
  }
}

onMounted(() => {
  loadArticles()
  loadHotUsers()
  loadHotTopics()
})
</script>

<style scoped>
.home {
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: calc(100vh - 70px);
  width: 100%;
}

.main-container {
  width: 100%;
  max-width: none;
  margin: 0;
  padding: 0;
  display: grid;
  grid-template-columns: 250px 1fr 300px;
  gap: 20px;
}

.left-sidebar {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.user-card {
  background: #fff;
  border-radius: 16px;
  padding: 25px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  text-align: center;
}

.user-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-weight: bold;
  font-size: 36px;
  margin: 0 auto 15px;
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
}

.user-name {
  font-size: 18px;
  font-weight: bold;
  color: #333;
  margin-bottom: 20px;
}

.user-stats {
  display: flex;
  justify-content: space-around;
}

.stat-item {
  text-align: center;
}

.stat-num {
  display: block;
  font-size: 20px;
  font-weight: bold;
  color: #ff6b35;
}

.stat-label {
  font-size: 12px;
  color: #999;
}

.quick-nav {
  background: #fff;
  border-radius: 16px;
  padding: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.quick-nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.quick-nav-item:hover {
  background: #f5f5f5;
  transform: translateX(5px);
}

.quick-nav-item .icon {
  font-size: 20px;
}

.content-area {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.feed-tabs {
  background: #fff;
  padding: 15px 20px;
  border-radius: 16px;
  display: flex;
  gap: 15px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.feed-tabs button {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 24px;
  border: none;
  background: none;
  cursor: pointer;
  font-size: 15px;
  border-radius: 25px;
  transition: all 0.3s ease;
  color: #666;
}

.feed-tabs button:hover {
  background: #f5f5f5;
}

.feed-tabs button.active {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}

.tab-icon {
  font-size: 18px;
}

.article-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.right-sidebar {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.sidebar-section {
  background: #fff;
  padding: 20px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.sidebar-section h3 {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 0 0 20px 0;
  font-size: 16px;
  color: #333;
}

.section-icon {
  font-size: 20px;
}

.hot-user {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.hot-user:last-child {
  border-bottom: none;
}

.user-avatar-small {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-weight: bold;
  font-size: 16px;
}

.user-link {
  flex: 1;
  text-decoration: none;
}

.user-link .user-name {
  font-size: 14px;
  font-weight: 500;
  color: #333;
  margin-bottom: 2px;
}

.user-fans {
  font-size: 12px;
  color: #999;
}

.follow-btn {
  padding: 6px 16px;
  border: 2px solid #ff6b35;
  background: none;
  color: #ff6b35;
  border-radius: 20px;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.3s ease;
}

.follow-btn:hover {
  background: #ff6b35;
  color: #fff;
}

.hot-topic {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.hot-topic:last-child {
  border-bottom: none;
}

.topic-rank {
  width: 28px;
  height: 28px;
  border-radius: 8px;
  background: #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 14px;
  color: #666;
}

.topic-rank.top {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
}

.topic-link {
  flex: 1;
  text-decoration: none;
}

.topic-name {
  font-size: 14px;
  font-weight: 500;
  color: #333;
  margin-bottom: 2px;
}

.topic-count {
  font-size: 12px;
  color: #999;
}

.empty {
  text-align: center;
  padding: 60px 20px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.empty-icon {
  font-size: 60px;
  margin-bottom: 20px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.empty-text {
  font-size: 20px;
  color: #666;
  margin-bottom: 10px;
}

.empty-hint {
  font-size: 14px;
  color: #999;
}

@media (max-width: 1200px) {
  .main-container {
    grid-template-columns: 1fr 300px;
  }
  .left-sidebar {
    display: none;
  }
}

@media (max-width: 768px) {
  .main-container {
    grid-template-columns: 1fr;
  }
  .right-sidebar {
    display: none;
  }
}
</style>
