<template>
  <div class="article-detail">
    <div class="header">
      <div class="logo">内容分享</div>
      <div class="nav">
        <router-link to="/">首页</router-link>
        <router-link to="/search">搜索</router-link>
        <router-link to="/topic">话题</router-link>
        <router-link to="/message">消息</router-link>
        <router-link to="/publish">发布</router-link>
      </div>
    </div>

    <div class="main-container" v-if="article">
      <div class="article-card">
        <div class="article-header">
          <img :src="article.user?.avatar || '/default-avatar.png'" class="avatar" />
          <div class="user-info">
            <router-link :to="`/user/${article.userId}`" class="nickname">{{ article.user?.nickname || article.user?.username }}</router-link>
            <div class="time">{{ formatTime(article.createTime) }}</div>
          </div>
        </div>

        <div class="article-content">
          <p>{{ article.content }}</p>
          <div v-if="article.images" class="images">
            <img v-for="(img, index) in JSON.parse(article.images)" :key="index" :src="img" />
          </div>
          <div v-if="article.video" class="video">
            <video :src="article.video" controls></video>
          </div>
          <div v-if="article.location" class="location">📍 {{ article.location }}</div>
        </div>

        <div class="article-actions">
          <button @click="handleLike">
            ❤️ {{ Math.max(article.likeCount || 0, 0) }}
          </button>
          <button @click="showComment = true">
            💬 {{ comments.length }}
          </button>
          <button @click="handleForward">
            🔄 {{ Math.max(article.forwardCount || 0, 0) }}
          </button>
          <button @click="handleFavorite">
            ⭐ {{ Math.max(article.favoriteCount || 0, 0) }}
          </button>
        </div>
      </div>

      <div class="comment-section" v-if="showComment">
        <h3>评论</h3>
        <div class="comment-input" v-if="currentUser">
          <textarea v-model="commentContent" placeholder="写评论..."></textarea>
          <button @click="submitComment">发送</button>
        </div>
        <div v-else class="login-tip">
          <router-link to="/login">登录</router-link>后发表评论
        </div>
        <div class="comments-list">
          <div v-for="comment in comments" :key="comment.id" class="comment-item">
            <img :src="comment.user?.avatar || '/default-avatar.png'" class="avatar" />
            <div class="comment-body">
              <div class="comment-user">{{ comment.user?.nickname || comment.user?.username }}</div>
              <div class="comment-content">{{ comment.content }}</div>
              <div class="comment-time">{{ formatTime(comment.createTime) }}</div>
            </div>
          </div>
          <div v-if="comments.length === 0" class="empty">暂无评论</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { articleApi, commentApi } from '../utils/request'

const route = useRoute()
const article = ref(null)
const comments = ref([])
const showComment = ref(true)
const commentContent = ref('')
const currentUser = ref(JSON.parse(localStorage.getItem('user') || 'null'))

const loadArticle = async () => {
  try {
    const res = await articleApi.getById(route.params.id, currentUser.value?.id)
    if (res.code === 200) {
      article.value = res.data
    }
  } catch (e) {
    console.log('加载文章失败', e)
  }
}

const loadComments = async () => {
  try {
    const res = await commentApi.getByArticle(route.params.id)
    if (res.code === 200) {
      comments.value = res.data || []
    }
  } catch (e) {
    console.log('加载评论失败', e)
  }
}

const handleLike = async () => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  try {
    if (article.value.isLiked) {
      await articleApi.unlike(currentUser.value.id, article.value.id)
    } else {
      await articleApi.like(currentUser.value.id, article.value.id)
    }
    loadArticle()
  } catch (e) {
    console.log('点赞失败', e)
  }
}

const handleFavorite = async () => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  try {
    if (article.value.isFavorited) {
      await articleApi.unfavorite(currentUser.value.id, article.value.id)
    } else {
      await articleApi.favorite(currentUser.value.id, article.value.id)
    }
    loadArticle()
  } catch (e) {
    console.log('收藏失败', e)
  }
}

const handleForward = async () => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  const content = prompt('请输入转发语:')
  if (content !== null) {
    try {
      await articleApi.forward(currentUser.value.id, article.value.id, content)
      alert('转发成功')
      loadArticle()
    } catch (e) {
      console.log('转发失败', e)
    }
  }
}

const submitComment = async () => {
  if (!commentContent.value.trim()) return
  try {
    await commentApi.add({
      articleId: article.value.id,
      userId: currentUser.value.id,
      content: commentContent.value
    })
    commentContent.value = ''
    loadComments()
    loadArticle()
  } catch (e) {
    console.log('评论失败', e)
  }
}

const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  return date.toLocaleString()
}

onMounted(() => {
  loadArticle()
  loadComments()
})
</script>

<style scoped>
.article-detail { min-height: 100vh; background: #f5f5f5; }
.header { background: #fff; padding: 15px 30px; display: flex; align-items: center; border-bottom: 1px solid #e5e5e5; }
.logo { font-size: 24px; font-weight: bold; color: #ff6b00; margin-right: 40px; }
.nav { flex: 1; display: flex; gap: 30px; }
.nav a { color: #333; text-decoration: none; }
.nav a:hover { color: #ff6b00; }
.main-container { width: 100%; max-width: none; margin: 0; padding: 0; }
.article-card { background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
.article-header { display: flex; align-items: center; margin-bottom: 15px; }
.article-header .avatar { width: 50px; height: 50px; border-radius: 50%; margin-right: 15px; }
.article-header .nickname { font-weight: bold; text-decoration: none; color: #333; }
.article-header .time { color: #999; font-size: 14px; }
.article-content p { margin: 0 0 15px 0; line-height: 1.6; }
.article-content .images { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 15px; }
.article-content .images img { width: 100%; border-radius: 8px; }
.article-content .video video { width: 100%; border-radius: 8px; }
.article-content .location { color: #999; font-size: 14px; }
.article-actions { display: flex; gap: 30px; padding-top: 15px; border-top: 1px solid #f5f5f5; }
.article-actions button { padding: 8px 15px; border: none; background: none; cursor: pointer; font-size: 14px; }
.comment-section { background: #fff; padding: 20px; border-radius: 8px; }
.comment-section h3 { margin: 0 0 20px 0; }
.comment-input { display: flex; gap: 10px; margin-bottom: 20px; }
.comment-input textarea { flex: 1; padding: 10px; border: 1px solid #e5e5e5; border-radius: 4px; resize: none; height: 80px; }
.comment-input button { padding: 10px 20px; background: #ff6b00; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
.login-tip { text-align: center; padding: 20px; color: #999; }
.login-tip a { color: #ff6b00; text-decoration: none; }
.comments-list { }
.comment-item { display: flex; padding: 15px 0; border-bottom: 1px solid #f5f5f5; }
.comment-item .avatar { width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; }
.comment-item .comment-body { flex: 1; }
.comment-item .comment-user { font-weight: bold; margin-bottom: 5px; }
.comment-item .comment-content { margin-bottom: 5px; }
.comment-item .comment-time { color: #999; font-size: 12px; }
.empty { text-align: center; padding: 30px; color: #999; }
</style>
