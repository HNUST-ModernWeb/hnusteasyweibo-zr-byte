<template>
  <Layout>
    <div class="search-page">
      <div class="search-header">
        <div class="search-box">
          <input v-model="keyword" type="text" placeholder="搜索用户、话题、微博..." @keyup.enter="handleSearch" />
          <button @click="handleSearch">搜索</button>
        </div>
        <div class="search-tabs">
          <button :class="{ active: tab === 'user' }" @click="switchTab('user')">用户</button>
          <button :class="{ active: tab === 'article' }" @click="switchTab('article')">微博</button>
          <button :class="{ active: tab === 'topic' }" @click="switchTab('topic')">话题</button>
        </div>
      </div>

      <div class="search-results">
        <div v-if="loading" class="loading">加载中...</div>
        <div v-else-if="results.length === 0 && searched" class="empty">
          <div class="empty-icon">🔍</div>
          <div class="empty-text">未找到相关内容</div>
        </div>
        <div v-else>
          <div v-if="tab === 'user'" class="user-list">
            <div v-for="user in results" :key="user.id" class="user-item">
              <div class="user-avatar">{{ (user.nickname || user.username).charAt(0) }}</div>
              <div class="user-info">
                <router-link :to="`/user/${user.id}`" class="user-name">{{ user.nickname || user.username }}</router-link>
                <div class="user-bio">{{ user.bio || '暂无简介' }}</div>
                <div class="user-stats">
                  <span>{{ user.fansCount || 0 }} 粉丝</span>
                  <span>{{ user.articleCount || 0 }} 微博</span>
                </div>
              </div>
              <button class="follow-btn">关注</button>
            </div>
          </div>
          <div v-else-if="tab === 'article'" class="article-list">
            <ArticleCard v-for="item in results" :key="item.id" :article="item" />
          </div>
          <div v-else class="topic-list">
            <div v-for="topic in results" :key="topic.id" class="topic-item">
              <router-link :to="`/topic/${topic.id}`" class="topic-name">#{{ topic.name }}#</router-link>
              <div class="topic-desc">{{ topic.description || '暂无描述' }}</div>
              <div class="topic-stats">
                <span>{{ topic.articleCount || 0 }} 讨论</span>
                <span>{{ topic.participantCount || 0 }} 参与</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="hot-search">
        <h3>🔥 热搜榜</h3>
        <div class="hot-list">
          <div v-for="(item, index) in hotSearch" :key="item.id" class="hot-item">
            <span class="rank" :class="{ top: index < 3 }">{{ index + 1 }}</span>
            <router-link :to="`/topic/${item.topicId}`" class="hot-title">{{ item.keyword }}</router-link>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Layout from '../components/Layout.vue'
import ArticleCard from '../components/ArticleCard.vue'
import { searchApi } from '../utils/request'

const keyword = ref('')
const tab = ref('user')
const results = ref([])
const loading = ref(false)
const searched = ref(false)
const hotSearch = ref([])

const handleSearch = async () => {
  if (!keyword.value.trim()) return
  loading.value = true
  searched.value = true
  try {
    let res
    if (tab.value === 'user') {
      res = await searchApi.searchUsers(keyword.value)
      results.value = res.data || []
    } else if (tab.value === 'article') {
      res = await searchApi.searchArticles(keyword.value)
      results.value = res.data || []
    } else {
      res = await searchApi.searchTopics(keyword.value)
      results.value = res.data || []
    }
  } catch (e) {
    console.log('搜索失败', e)
  }
  loading.value = false
}

const switchTab = (newTab) => {
  tab.value = newTab
  if (searched.value) {
    handleSearch()
  }
}

const loadHotSearch = async () => {
  try {
    const res = await searchApi.getHotSearches(null, 10)
    hotSearch.value = res.data || []
  } catch (e) {
    console.log('加载热搜失败', e)
  }
}

onMounted(() => {
  loadHotSearch()
})
</script>

<style scoped>
.search-page {
  width: 100%;
  max-width: none;
  margin: 0;
  padding: 0;
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 20px;
}

.search-header {
  background: #fff;
  padding: 20px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  margin-bottom: 20px;
}

.search-box {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.search-box input {
  flex: 1;
  padding: 12px 16px;
  border: 2px solid #e5e5e5;
  border-radius: 25px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.search-box input:focus {
  outline: none;
  border-color: #ff6b35;
}

.search-box button {
  padding: 12px 30px;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  font-weight: bold;
  transition: all 0.3s ease;
}

.search-box button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}

.search-tabs {
  display: flex;
  gap: 10px;
}

.search-tabs button {
  padding: 8px 20px;
  border: none;
  background: #f5f5f5;
  border-radius: 20px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.search-tabs button.active {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
}

.loading {
  text-align: center;
  padding: 60px;
  color: #999;
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

.user-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 20px;
  background: #fff;
  border-radius: 16px;
  margin-bottom: 15px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.user-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-weight: bold;
  font-size: 24px;
}

.user-info {
  flex: 1;
}

.user-name {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  text-decoration: none;
  display: block;
  margin-bottom: 5px;
}

.user-bio {
  font-size: 14px;
  color: #666;
  margin-bottom: 5px;
}

.user-stats {
  font-size: 12px;
  color: #999;
  display: flex;
  gap: 15px;
}

.follow-btn {
  padding: 8px 20px;
  border: 2px solid #ff6b35;
  background: none;
  color: #ff6b35;
  border-radius: 20px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.follow-btn:hover {
  background: #ff6b35;
  color: #fff;
}

.topic-item {
  padding: 20px;
  background: #fff;
  border-radius: 16px;
  margin-bottom: 15px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.topic-name {
  font-size: 18px;
  font-weight: bold;
  color: #ff6b35;
  text-decoration: none;
  display: block;
  margin-bottom: 8px;
}

.topic-desc {
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
}

.topic-stats {
  font-size: 12px;
  color: #999;
  display: flex;
  gap: 15px;
}

.hot-search {
  background: #fff;
  padding: 20px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  height: fit-content;
}

.hot-search h3 {
  margin-bottom: 15px;
  font-size: 16px;
  color: #333;
}

.hot-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.hot-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.rank {
  width: 24px;
  height: 24px;
  border-radius: 6px;
  background: #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 13px;
  color: #666;
}

.rank.top {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
}

.hot-title {
  flex: 1;
  font-size: 14px;
  color: #333;
  text-decoration: none;
  transition: color 0.3s ease;
}

.hot-title:hover {
  color: #ff6b35;
}

@media (max-width: 768px) {
  .search-page {
    grid-template-columns: 1fr;
  }
  .hot-search {
    display: none;
  }
}
</style>
