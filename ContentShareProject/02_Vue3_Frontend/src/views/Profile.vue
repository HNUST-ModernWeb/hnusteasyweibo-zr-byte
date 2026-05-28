<template>
  <Layout>
    <div class="profile-page">
      <template v-if="currentUser">
        <div class="profile-header">
          <div class="profile-cover"></div>
          <div class="profile-info">
            <div class="profile-avatar-wrapper">
              <div class="profile-avatar" :style="{ backgroundImage: currentUser.avatar ? `url(${currentUser.avatar})` : '' }">
                <span v-if="!currentUser.avatar">{{ (currentUser.nickname || currentUser.username).charAt(0) }}</span>
              </div>
              <input type="file" id="avatarInput" accept="image/*" @change="handleAvatarUpload" />
              <label for="avatarInput" class="avatar-upload-btn">
                <span class="upload-icon">📷</span>
              </label>
            </div>
            <div class="profile-details">
              <h1>{{ currentUser.nickname || currentUser.username }}</h1>
              <p class="bio">{{ currentUser.bio || '暂无简介' }}</p>
              <div class="profile-stats">
                <div class="stat" @click="goToFollow">
                  <span class="stat-num">{{ currentUser.followCount || 0 }}</span>
                  <span class="stat-label">关注</span>
                </div>
                <div class="stat" @click="goToFans">
                  <span class="stat-num">{{ Math.max(currentUser.fansCount || 0, 0) }}</span>
                  <span class="stat-label">粉丝</span>
                </div>
                <div class="stat" @click="goToArticle">
                  <span class="stat-num">{{ Math.max(currentUser.articleCount || 0, 0) }}</span>
                  <span class="stat-label">微博</span>
                </div>
                <div class="stat" @click="goToFavorite">
                  <span class="stat-num">{{ Math.max(currentUser.favoriteCount || 0, 0) }}</span>
                  <span class="stat-label">收藏</span>
                </div>
                <div class="stat" @click="goToLike">
                  <span class="stat-num">{{ Math.max(currentUser.likeCount || 0, 0) }}</span>
                  <span class="stat-label">赞过</span>
                </div>
              </div>
            </div>
            <div class="profile-actions">
              <router-link to="/settings" class="edit-btn">编辑资料</router-link>
              <button @click="handleLogout" class="logout-btn">退出登录</button>
            </div>
          </div>
        </div>

        <div class="profile-tabs">
          <button :class="{ active: tab === 'article' }" @click="switchTab('article')">微博</button>
          <button :class="{ active: tab === 'favorite' }" @click="switchTab('favorite')">收藏</button>
          <button :class="{ active: tab === 'follow' }" @click="switchTab('follow')">关注</button>
          <button :class="{ active: tab === 'fans' }" @click="switchTab('fans')">粉丝</button>
          <button :class="{ active: tab === 'like' }" @click="switchTab('like')">赞过</button>
        </div>

        <div class="profile-content">
          <div v-if="loading" class="loading">加载中...</div>
          <div v-else-if="content.length === 0 && tab !== 'follow' && tab !== 'fans'" class="empty">
            <div class="empty-icon">📭</div>
            <div class="empty-text">暂无内容</div>
          </div>
          <div v-else-if="tab !== 'follow' && tab !== 'fans'" v-for="item in content" :key="item.id" class="article-item">
            <div v-if="editingId === item.id" class="edit-form">
              <textarea v-model="editingContent" class="edit-textarea"></textarea>
              <div class="edit-actions">
                <button @click="handleSave(item.id)" class="save-btn">保存</button>
                <button @click="handleCancel" class="cancel-btn">取消</button>
              </div>
            </div>
            <div v-else>
              <ArticleCard :article="item" />
              <div class="article-actions">
                <button @click="handleEdit(item)" class="action-btn edit">编辑</button>
                <button @click="handleDelete(item.id)" class="action-btn delete">删除</button>
              </div>
            </div>
          </div>
          <!-- 关注列表 -->
          <div v-if="tab === 'follow'">
            <div v-if="followList.length === 0" class="empty">
              <div class="empty-icon">👥</div>
              <div class="empty-text">暂无关注</div>
            </div>
            <div v-for="user in followList" :key="user.id" class="user-item" @click="goToUser(user.id)">
              <div class="user-avatar-small">{{ (user.nickname || user.username).charAt(0) }}</div>
              <div class="user-info-small">
                <div class="user-name">{{ user.nickname || user.username }}</div>
                <div class="user-bio-small">{{ user.bio || '暂无简介' }}</div>
              </div>
            </div>
          </div>
          <!-- 粉丝列表 -->
          <div v-if="tab === 'fans'">
            <div v-if="fansList.length === 0" class="empty">
              <div class="empty-icon">👤</div>
              <div class="empty-text">暂无粉丝</div>
            </div>
            <div v-for="user in fansList" :key="user.id" class="user-item" @click="goToUser(user.id)">
              <div class="user-avatar-small">{{ (user.nickname || user.username).charAt(0) }}</div>
              <div class="user-info-small">
                <div class="user-name">{{ user.nickname || user.username }}</div>
                <div class="user-bio-small">{{ user.bio || '暂无简介' }}</div>
              </div>
            </div>
          </div>
        </div>
      </template>
      <div v-else class="not-login">
        <div class="not-login-icon">👤</div>
        <h2>未登录</h2>
        <p>请先登录查看个人信息</p>
        <router-link to="/login" class="login-btn">去登录</router-link>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import Layout from '../components/Layout.vue'
import ArticleCard from '../components/ArticleCard.vue'
import { articleApi, userApi } from '../utils/request'

const router = useRouter()
const route = useRoute()
const currentUser = ref(JSON.parse(localStorage.getItem('user') || 'null'))
const tab = ref(route.query.tab || 'article')
const content = ref([])
const followList = ref([])
const fansList = ref([])
const loading = ref(false)
const editingId = ref(null)
const editingContent = ref('')

const loadContent = async () => {
  if (!currentUser.value) return
  loading.value = true
  try {
    let res
    if (tab.value === 'article') {
      res = await articleApi.getUserArticles(currentUser.value.id, 1, 50)
    } else if (tab.value === 'favorite') {
      res = await articleApi.getFavorited(currentUser.value.id)
    } else if (tab.value === 'like') {
      res = await articleApi.getLiked(currentUser.value.id)
    } else if (tab.value === 'follow') {
      res = await userApi.getFollowingList(currentUser.value.id)
      if (res.code === 200) {
        followList.value = res.data || []
        // 更新关注数，确保与实际列表一致
        currentUser.value.followCount = followList.value.length
        localStorage.setItem('user', JSON.stringify(currentUser.value))
        content.value = []
        loading.value = false
        return
      }
    } else if (tab.value === 'fans') {
      res = await userApi.getFansList(currentUser.value.id)
      if (res.code === 200) {
        fansList.value = res.data || []
        // 更新粉丝数，确保与实际列表一致
        currentUser.value.fansCount = fansList.value.length
        localStorage.setItem('user', JSON.stringify(currentUser.value))
        content.value = []
        loading.value = false
        return
      }
    }
    if (res.code === 200) {
      content.value = res.data || []
      followList.value = []
      fansList.value = []
    }
  } catch (e) {
    console.log('加载失败', e)
  }
  loading.value = false
}

const handleEdit = (article) => {
  editingId.value = article.id
  editingContent.value = article.content
}

const handleSave = async (articleId) => {
  try {
    await articleApi.update({ id: articleId, userId: currentUser.value.id, content: editingContent.value })
    editingId.value = null
    loadContent()
    alert('修改成功')
  } catch (e) {
    console.log('修改失败', e)
  }
}

const handleCancel = () => {
  editingId.value = null
  editingContent.value = ''
}

const handleDelete = async (articleId) => {
  if (!confirm('确定要删除这条微博吗？')) return
  try {
    await articleApi.delete(articleId, currentUser.value.id)
    loadContent()
    alert('删除成功')
  } catch (e) {
    console.log('删除失败', e)
  }
}

const switchTab = (newTab) => {
  tab.value = newTab
  content.value = []
  followList.value = []
  fansList.value = []
  loadContent()
}

const handleLogout = () => {
  localStorage.removeItem('user')
  alert('已退出登录')
  router.push('/')
  location.reload()
}

const handleAvatarUpload = async (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  const formData = new FormData()
  formData.append('avatar', file)
  formData.append('userId', currentUser.value.id)
  
  try {
    const res = await userApi.uploadAvatar(formData)
    if (res.code === 200) {
      alert('头像上传成功')
      currentUser.value.avatar = res.data.avatar
      localStorage.setItem('user', JSON.stringify(currentUser.value))
    } else {
      alert(res.message || '头像上传失败')
    }
  } catch (e) {
    console.log('头像上传失败', e)
    // 如果上传失败，使用随机生成的头像
    const randomAvatar = 'https://api.dicebear.com/7.x/avataaars/svg?seed=' + Date.now()
    currentUser.value.avatar = randomAvatar
    localStorage.setItem('user', JSON.stringify(currentUser.value))
    alert('头像已更新')
  }
}

const loadUserInfo = async () => {
  if (!currentUser.value) return
  try {
    const res = await userApi.getUserInfo(currentUser.value.id)
    if (res.code === 200 && res.data) {
      currentUser.value = res.data
      localStorage.setItem('user', JSON.stringify(currentUser.value))
    }
  } catch (e) {
    console.log('获取用户信息失败', e)
  }
}

const goToUser = (userId) => {
  if (userId === currentUser.value.id) {
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

const goToFavorite = () => {
  switchTab('favorite')
}

const goToLike = () => {
  switchTab('like')
}

onMounted(() => {
  if (currentUser.value) {
    loadUserInfo()
    loadContent()
  }
})
</script>

<style scoped>
.profile-page {
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

.profile-avatar-wrapper {
  position: relative;
  display: inline-block;
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
  background-size: cover;
  background-position: center;
  cursor: pointer;
  transition: all 0.3s ease;
}

.profile-avatar:hover {
  transform: scale(1.05);
}

.profile-avatar-wrapper input {
  display: none;
}

.avatar-upload-btn {
  position: absolute;
  bottom: 5px;
  right: 5px;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  border: 3px solid #fff;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.profile-avatar-wrapper:hover .avatar-upload-btn {
  opacity: 1;
}

.upload-icon {
  font-size: 16px;
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
  margin-bottom: 15px;
  line-height: 1.6;
}

.profile-stats {
  display: flex;
  gap: 30px;
  margin-top: 20px;
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
  display: flex;
  gap: 10px;
}

.edit-btn, .logout-btn {
  padding: 10px 20px;
  border-radius: 25px;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.3s ease;
}

.edit-btn {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
}

.logout-btn {
  background: #f5f5f5;
  color: #666;
  border: none;
  cursor: pointer;
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

.profile-tabs button:hover {
  background: #f5f5f5;
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

.not-login {
  text-align: center;
  padding: 100px 20px;
  background: #fff;
  border-radius: 16px;
  width: 100%;
  margin: 20px auto;
}

.not-login-icon {
  font-size: 80px;
  margin-bottom: 20px;
}

.not-login h2 {
  font-size: 24px;
  color: #333;
  margin-bottom: 10px;
}

.not-login p {
  font-size: 14px;
  color: #999;
  margin-bottom: 20px;
}

.login-btn {
  display: inline-block;
  padding: 12px 30px;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  text-decoration: none;
  border-radius: 25px;
  font-weight: bold;
  transition: all 0.3s ease;
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}

.article-item {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.article-actions {
  display: flex;
  gap: 10px;
  padding: 15px 20px;
  border-top: 1px solid #f0f0f0;
  justify-content: flex-end;
}

.action-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 20px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.action-btn.edit {
  background: #f0f0f0;
  color: #666;
}

.action-btn.edit:hover {
  background: #e0e0e0;
}

.action-btn.delete {
  background: #fff5f5;
  color: #dc3545;
}

.action-btn.delete:hover {
  background: #ffebee;
}

.edit-form {
  padding: 20px;
}

.edit-textarea {
  width: 100%;
  min-height: 100px;
  padding: 15px;
  border: 1px solid #e0e0e0;
  border-radius: 12px;
  font-size: 14px;
  resize: vertical;
  font-family: inherit;
}

.edit-actions {
  display: flex;
  gap: 10px;
  margin-top: 15px;
  justify-content: flex-end;
}

.save-btn, .cancel-btn {
  padding: 10px 24px;
  border: none;
  border-radius: 25px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.save-btn {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
}

.save-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}

.cancel-btn {
  background: #f5f5f5;
  color: #666;
}

.cancel-btn:hover {
  background: #e0e0e0;
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
