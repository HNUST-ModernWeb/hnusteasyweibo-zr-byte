<template>
  <div class="article-card" @click="$emit('click', article)">
    <div class="card-header">
      <img :src="article.user?.avatar || '/default-avatar.png'" class="avatar" @click.stop="goToUser" />
      <div class="user-info">
        <span class="nickname" @click.stop="goToUser">{{ article.user?.nickname || article.user?.username || '匿名用户' }}</span>
        <span class="time">{{ formatTime(article.createTime) }}</span>
      </div>
      <button v-if="showFollowBtn" class="follow-btn" @click.stop="$emit('follow', article.user)">
        {{ article.user?.isFollowing ? '已关注' : '关注' }}
      </button>
    </div>

    <div class="card-content" @click.stop>
      <p class="text">{{ article.content }}</p>

      <div v-if="article.images" class="images">
        <img v-for="(img, index) in parseImages(article.images)" :key="index" :src="img" @click="previewImage(img)" />
      </div>

      <div v-if="article.video" class="video">
        <video :src="article.video" controls></video>
      </div>

      <div v-if="article.location" class="location">📍 {{ article.location }}</div>

      <div v-if="article.topicName || article.topicId" class="topic" @click.stop="goToTopic">
        #{{ article.topicName || '话题' }}#
      </div>
    </div>

    <div class="card-actions" @click.stop>
      <button @click="$emit('like', article)" :class="{ active: article.isLiked }">
        ❤️ {{ Math.max(article.likeCount || 0, 0) }}
      </button>
      <button @click="$emit('comment', article)">
        💬 {{ Math.max(article.commentCount || 0, 0) }}
      </button>
      <button @click="$emit('forward', article)">
        🔄 {{ Math.max(article.forwardCount || 0, 0) }}
      </button>
      <button @click="$emit('favorite', article)" :class="{ active: article.isFavorited }">
        ⭐ {{ Math.max(article.favoriteCount || 0, 0) }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const props = defineProps({
  article: Object,
  showFollowBtn: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['like', 'comment', 'forward', 'favorite', 'follow', 'click'])
const router = useRouter()

const parseImages = (images) => {
  if (!images) return []
  try {
    return JSON.parse(images)
  } catch {
    return images.split(',')
  }
}

const formatTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  const now = new Date()
  const diff = now - date

  if (diff < 60000) return '刚刚'
  if (diff < 3600000) return Math.floor(diff / 60000) + '分钟前'
  if (diff < 86400000) return Math.floor(diff / 3600000) + '小时前'
  if (diff < 604800000) return Math.floor(diff / 86400000) + '天前'
  return date.toLocaleDateString()
}

const goToUser = () => {
  if (props.article.userId) {
    router.push(`/user/${props.article.userId}`)
  }
}

const goToTopic = () => {
  if (props.article.topicId) {
    router.push(`/topic/${props.article.topicId}`)
  }
}

const previewImage = (img) => {
  window.open(img, '_blank')
}
</script>

<style scoped>
.article-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
  cursor: pointer;
  transition: all 0.3s;
}
.article-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}
.card-header {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}
.avatar {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 12px;
  cursor: pointer;
}
.user-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.nickname {
  font-weight: bold;
  color: #333;
  cursor: pointer;
}
.nickname:hover {
  color: #ff6b00;
}
.time {
  font-size: 13px;
  color: #999;
}
.follow-btn {
  padding: 6px 16px;
  border: 1px solid #ff6b00;
  background: #fff;
  color: #ff6b00;
  border-radius: 15px;
  cursor: pointer;
  font-size: 13px;
}
.follow-btn:hover {
  background: #ff6b00;
  color: #fff;
}
.card-content {
  margin-bottom: 15px;
}
.card-content .text {
  margin: 0 0 12px 0;
  line-height: 1.6;
  color: #333;
}
.card-content .images {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  margin-bottom: 12px;
}
.card-content .images img {
  width: 100%;
  aspect-ratio: 1;
  object-fit: cover;
  border-radius: 8px;
  cursor: pointer;
}
.card-content .video video {
  width: 100%;
  border-radius: 8px;
  margin-bottom: 12px;
}
.card-content .location {
  color: #999;
  font-size: 14px;
  margin-bottom: 8px;
}
.card-content .topic {
  color: #ff6b00;
  font-size: 14px;
  cursor: pointer;
}
.card-content .topic:hover {
  text-decoration: underline;
}
.card-actions {
  display: flex;
  justify-content: space-between;
  padding-top: 15px;
  border-top: 1px solid #f5f5f5;
}
.card-actions button {
  padding: 8px 15px;
  border: none;
  background: none;
  cursor: pointer;
  color: #666;
  font-size: 14px;
  border-radius: 4px;
}
.card-actions button:hover {
  background: #f5f5f5;
}
.card-actions button.active {
  color: #ff6b00;
}
</style>
