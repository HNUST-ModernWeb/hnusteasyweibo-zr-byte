<template>
  <div class="user-list">
    <div v-if="loading" class="loading">加载中...</div>
    <div v-else-if="users.length === 0" class="empty">
      <div class="empty-icon">👥</div>
      <div class="empty-text">暂无{{ title }}</div>
    </div>
    <div v-else v-for="user in users" :key="user.id" class="user-item" @click="goToUser(user.id)">
      <div class="user-avatar">{{ (user.nickname || user.username).charAt(0) }}</div>
      <div class="user-info">
        <div class="user-name">{{ user.nickname || user.username }}</div>
        <div class="user-bio">{{ user.bio || '暂无简介' }}</div>
      </div>
      <div class="user-follow">
        <button v-if="currentUserId !== user.id" :class="{ followed: user.isFollowing }" @click.stop="handleFollow(user)">
          {{ user.isFollowing ? '已关注' : '+关注' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { userApi } from '../utils/request'

const router = useRouter()
const route = useRoute()

defineProps({
  title: {
    type: String,
    default: '用户列表'
  },
  type: {
    type: String,
    required: true
  },
  userId: {
    type: Number,
    required: true
  }
})

const currentUserId = ref(JSON.parse(localStorage.getItem('user') || 'null')?.id)
const users = ref([])
const loading = ref(false)

const loadUsers = async () => {
  loading.value = true
  try {
    let res
    if (route.params.id) {
      // 查看其他用户的列表
      if (route.params.type === 'follow') {
        res = await userApi.getFollowingList(route.params.id)
      } else {
        res = await userApi.getFansList(route.params.id)
      }
    } else {
      // 查看自己的列表
      if (route.params.type === 'follow') {
        res = await userApi.getFollowingList(currentUserId.value)
      } else {
        res = await userApi.getFansList(currentUserId.value)
      }
    }
    if (res.code === 200) {
      users.value = res.data || []
    }
  } catch (e) {
    console.log('加载失败', e)
  }
  loading.value = false
}

const goToUser = (userId) => {
  if (userId === currentUserId.value) {
    router.push('/profile')
  } else {
    router.push(`/user/${userId}`)
  }
}

const handleFollow = async (user) => {
  if (!currentUserId.value) {
    alert('请先登录')
    return
  }
  try {
    if (user.isFollowing) {
      await userApi.unfollow(currentUserId.value, user.id)
      user.isFollowing = false
    } else {
      await userApi.follow(currentUserId.value, user.id)
      user.isFollowing = true
    }
  } catch (e) {
    console.log('关注失败', e)
  }
}

onMounted(() => {
  loadUsers()
})

watch(() => route.params, () => {
  loadUsers()
}, { deep: true })
</script>

<style scoped>
.user-list {
  padding: 20px;
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

.user-avatar {
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

.user-info {
  flex: 1;
  margin-left: 15px;
}

.user-name {
  font-weight: bold;
  color: #333;
  font-size: 16px;
}

.user-bio {
  color: #999;
  font-size: 14px;
  margin-top: 4px;
}

.user-follow button {
  padding: 8px 20px;
  border: 1px solid #ff6b35;
  border-radius: 20px;
  background: #fff;
  color: #ff6b35;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.user-follow button:hover {
  background: rgba(255, 107, 53, 0.1);
}

.user-follow button.followed {
  background: #fff;
  border-color: #ccc;
  color: #999;
}

.loading {
  text-align: center;
  padding: 40px;
  color: #999;
}

.empty {
  text-align: center;
  padding: 40px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 10px;
}

.empty-text {
  color: #999;
}
</style>