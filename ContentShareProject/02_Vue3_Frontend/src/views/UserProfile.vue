<template>
  <Layout>
    <div class="user-profile-page">
      <div v-if="user" class="profile-header">
        <div class="profile-cover"></div>
        <div class="profile-info">
          <div class="profile-avatar">{{ (user.nickname || user.username).charAt(0) }}</div>
          <div class="profile-details">
            <h1>{{ user.nickname || user.username }}</h1>
            <p class="bio">{{ user.bio || '暂无简介' }}</p>
            <div class="profile-meta">
              <span v-if="user.location">📍 {{ user.location }}</span>
              <span v-if="user.birthday">🎂 {{ formatBirthday(user.birthday) }}</span>
            </div>
            <div class="profile-stats">
              <div class="stat" @click="goToFollow">
                <span class="stat-num">{{ user.followCount || 0 }}</span>
                <span class="stat-label">关注</span>
              </div>
              <div class="stat" @click="goToFans">
                <span class="stat-num">{{ user.fansCount || 0 }}</span>
                <span class="stat-label">粉丝</span>
              </div>
              <div class="stat" @click="goToArticle">
                <span class="stat-num">{{ user.articleCount || 0 }}</span>
                <span class="stat-label">微博</span>
              </div>
            </div>
          </div>
          <div class="profile-actions">
            <button v-if="!isFollowing" @click="handleFollow" class="follow-btn">关注</button>
            <button v-else @click="handleUnfollow" class="unfollow-btn">已关注</button>
          </div>
        </div>
      </div>

      <div class="profile-tabs">
        <button :class="{ active: tab === 'article' }" @click="switchTab('article')">微博</button>
        <button :class="{ active: tab === 'follow' }" @click="switchTab('follow')">关注</button>
        <button :class="{ active: tab === 'fans' }" @click="switchTab('fans')">粉丝</button>
      </div>

      <div class="profile-content">
        <div v-if="loading" class="loading">加载中...</div>
        <div v-else-if="articles.length === 0 && tab === 'article'" class="empty">
          <div class="empty-icon">📭</div>
          <div class="empty-text">暂无微博</div>
        </div>
        <div v-else-if="followList.length === 0 && tab === 'follow'" class="empty">
          <div class="empty-icon">👥</div>
          <div class="empty-text">暂无关注</div>
        </div>
        <div v-else-if="fansList.length === 0 && tab === 'fans'" class="empty">
          <div class="empty-icon">👥</div>
          <div class="empty-text">暂无粉丝</div>
        </div>
        <ArticleCard v-else-if="tab === 'article'" v-for="item in articles" :key="item.id" :article="item" />
        <!-- 关注列表 -->
        <div v-else-if="tab === 'follow' && followList.length > 0">
          <div v-for="u in followList" :key="u.id" class="user-item" @click="goToUser(u.id)">
            <div class="user-avatar-small">{{ (u.nickname || u.username).charAt(0) }}</div>
            <div class="user-info-small">
              <div class="user-name">{{ u.nickname || u.username }}</div>
              <div class="user-bio-small">{{ u.bio || '暂无简介' }}</div>
            </div>
          </div>
        </div>
        <!-- 粉丝列表 -->
        <div v-else-if="tab === 'fans' && fansList.length > 0">
          <div v-for="u in fansList" :key="u.id" class="user-item" @click="goToUser(u.id)">
            <div class="user-avatar-small">{{ (u.nickname || u.username).charAt(0) }}</div>
            <div class="user-info-small">
              <div class="user-name">{{ u.nickname || u.username }}</div>
              <div class="user-bio-small">{{ u.bio || '暂无简介' }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Layout from '../components/Layout.vue'
import ArticleCard from '../components/ArticleCard.vue'
import { userApi, articleApi } from '../utils/request'

const route = useRoute()
const router = useRouter()
const user = ref(null)
const articles = ref([])
const followList = ref([])
const fansList = ref([])
const tab = ref('article')
const loading = ref(false)
const isFollowing = ref(false)
const currentUser = ref(JSON.parse(localStorage.getItem('user') || 'null'))

const loadUser = async () => {
  try {
    const res = await userApi.getUserInfo(route.params.id)
    if (res.code === 200) {
      user.value = res.data
      // 用户信息加载完成后再检查关注状态
      checkFollowStatus()
    }
  } catch (e) {
    console.log('加载用户信息失败', e)
  }
}

const loadArticles = async () => {
  loading.value = true
  try {
    if (tab.value === 'article') {
      const res = await articleApi.getUserArticles(route.params.id, 1, 50)
      if (res.code === 200) {
        articles.value = res.data || []
        followList.value = []
        fansList.value = []
      }
    } else if (tab.value === 'follow') {
      const res = await userApi.getFollowingList(route.params.id)
      if (res.code === 200) {
        followList.value = res.data || []
        articles.value = []
        fansList.value = []
      }
    } else if (tab.value === 'fans') {
      const res = await userApi.getFansList(route.params.id)
      if (res.code === 200) {
        fansList.value = res.data || []
        articles.value = []
        followList.value = []
      }
    }
  } catch (e) {
    console.log('加载失败', e)
  }
  loading.value = false
}

const checkFollowStatus = async () => {
  if (!currentUser.value || !user.value) return
  try {
    const res = await userApi.getFollowingList(currentUser.value.id)
    if (res.code === 200 && res.data) {
      const followIds = res.data.map(u => u.id)
      isFollowing.value = followIds.includes(user.value.id)
    }
  } catch (e) {
    console.log('检查关注状态失败', e)
  }
}

const handleFollow = async () => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  try {
    const res = await userApi.follow(currentUser.value.id, user.value.id)
    if (res.code === 200) {
      isFollowing.value = true
      if (user.value.fansCount !== undefined) {
        user.value.fansCount++
      }
    } else {
      alert(res.message || '关注失败')
    }
  } catch (e) {
    console.log('关注失败', e)
  }
}

const handleUnfollow = async () => {
  if (!currentUser.value) return
  try {
    const res = await userApi.unfollow(currentUser.value.id, user.value.id)
    if (res.code === 200) {
      isFollowing.value = false
      if (user.value.fansCount !== undefined) {
        user.value.fansCount--
      }
    } else {
      alert(res.message || '取消关注失败')
    }
  } catch (e) {
    console.log('取消关注失败', e)
  }
}

const switchTab = (newTab) => {
  tab.value = newTab
  articles.value = []
  followList.value = []
  fansList.value = []
  loadArticles()
}

const goToUser = (userId) => {
  if (userId === currentUser.value?.id) {
    router.push('/profile')
  } else {
    router.push(`/user/${userId}`)
  }
}

const goToFollow = () => {
  switchTab('follow')
}

const goToFans = () => {
  switchTab('fans')
}

const goToArticle = () => {
  switchTab('article')
}

const formatBirthday = (date) => {
  if (!date) return ''
  return date.split('T')[0]
}

onMounted(() => {
  loadUser()
  loadArticles()
})
</script>

<style scoped>
.user-profile-page {
  width: 100%;
  max-width: none;
  margin: 0;
  padding: 0;
}

.profile-header {
  background: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  margin-bottom: 20px;
}

.profile-cover {
  height: 200px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.profile-info {
  padding: 0 30px 30px;
  position: relative;
}

.profile-avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-weight: bold;
  font-size: 48px;
  margin-top: -60px;
  border: 5px solid #fff;
  box-shadow: 0 8px 25px rgba(255, 107, 53, 0.4);
}

.profile-details {
  margin-top: 15px;
}

.profile-details h1 {
  font-size: 24px;
  color: #333;
  margin-bottom: 10px;
}

.bio {
  font-size: 14px;
  color: #666;
  margin-bottom: 10px;
  line-height: 1.6;
}

.profile-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  font-size: 13px;
  color: #999;
}

.profile-stats {
  display: flex;
  gap: 30px;
}

.stat {
  text-align: center;
  cursor: pointer;
  padding: 8px 16px;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.stat:hover {
  background: #f5f5f5;
}

.stat-num {
  display: block;
  font-size: 22px;
  font-weight: bold;
  color: #333;
}

.stat-label {
  font-size: 13px;
  color: #999;
}

.profile-actions {
  position: absolute;
  top: 15px;
  right: 30px;
}

.follow-btn, .unfollow-btn {
  padding: 10px 30px;
  border-radius: 25px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.follow-btn {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  border: none;
}

.unfollow-btn {
  background: #f5f5f5;
  color: #666;
  border: 2px solid #e5e5e5;
}

.profile-tabs {
  display: flex;
  gap: 10px;
  background: #fff;
  padding: 15px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  margin-bottom: 20px;
}

.profile-tabs button {
  flex: 1;
  padding: 12px;
  border: none;
  background: none;
  border-radius: 12px;
  cursor: pointer;
  font-size: 14px;
  color: #666;
  transition: all 0.3s ease;
}

.profile-tabs button.active {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
}

.profile-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.loading {
  text-align: center;
  padding: 60px;
  color: #999;
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
  font-size: 16px;
  color: #999;
}

.user-item {
  display: flex;
  align-items: center;
  padding: 15px;
  background: #fff;
  border-radius: 12px;
  margin-bottom: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.user-item:hover {
  background: #f8f9fa;
  transform: translateX(5px);
}

.user-avatar-small {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: bold;
}

.user-info-small {
  flex: 1;
  margin-left: 15px;
}

.user-name {
  font-weight: bold;
  color: #333;
  font-size: 16px;
}

.user-bio-small {
  color: #999;
  font-size: 14px;
  margin-top: 4px;
}
</style>
