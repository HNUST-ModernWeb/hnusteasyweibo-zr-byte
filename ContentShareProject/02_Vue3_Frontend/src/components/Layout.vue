<template>
  <div class="layout">
    <div class="header">
      <div class="header-content">
        <div class="logo">
          <span class="logo-icon">📱</span>
          <span class="logo-text">微博</span>
        </div>
        <div class="nav">
          <router-link to="/" class="nav-item">
            <span class="nav-icon">🏠</span>
            <span>首页</span>
          </router-link>
          <router-link to="/search" class="nav-item">
            <span class="nav-icon">🔍</span>
            <span>搜索</span>
          </router-link>
          <router-link to="/topic" class="nav-item">
            <span class="nav-icon">💬</span>
            <span>话题</span>
          </router-link>
          <router-link to="/message" class="nav-item">
            <span class="nav-icon">✉️</span>
            <span>消息</span>
          </router-link>
        </div>
        <div class="user-area">
          <router-link to="/publish" class="publish-btn">
            <span>✏️</span> 发布
          </router-link>
          <div v-if="!currentUser" class="login-area">
            <router-link to="/login" class="login-btn">登录</router-link>
            <router-link to="/register" class="register-btn">注册</router-link>
          </div>
          <div v-else class="user-dropdown" @click="toggleDropdown">
            <div class="user-info">
              <div class="avatar">{{ (currentUser.nickname || currentUser.username).charAt(0) }}</div>
              <span class="username">{{ currentUser.nickname || currentUser.username }}</span>
              <span class="dropdown-arrow">▼</span>
            </div>
            <div v-if="showDropdown" class="dropdown-menu">
              <div class="dropdown-header">
                <div class="current-account">
                  <span class="label">当前账号</span>
                  <span class="account-name">{{ currentUser.nickname || currentUser.username }}</span>
                </div>
              </div>
              <div class="dropdown-divider"></div>
              <router-link to="/profile" class="dropdown-item" @click="showDropdown = false">
                <span class="item-icon">👤</span>
                <span>个人主页</span>
              </router-link>
              <router-link to="/settings" class="dropdown-item" @click="showDropdown = false">
                <span class="item-icon">⚙️</span>
                <span>账号设置</span>
              </router-link>
              <div class="dropdown-divider"></div>
              <div class="dropdown-item switch-account" @click="handleSwitchAccount">
                <span class="item-icon">🔄</span>
                <span>切换账号</span>
              </div>
              <div class="dropdown-item logout" @click="handleLogout">
                <span class="item-icon">🚪</span>
                <span>退出登录</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="main-content">
      <slot></slot>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const currentUser = ref(JSON.parse(localStorage.getItem('user') || 'null'))
const showDropdown = ref(false)

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value
}

const handleSwitchAccount = () => {
  showDropdown.value = false
  // 清除用户信息并跳转到登录页
  localStorage.removeItem('user')
  currentUser.value = null
  router.push('/login')
}

const handleLogout = () => {
  showDropdown.value = false
  // 清除用户信息并跳转到登录页
  localStorage.removeItem('user')
  currentUser.value = null
  router.push('/login')
}

const handleClickOutside = (event) => {
  if (!event.target.closest('.user-dropdown')) {
    showDropdown.value = false
  }
}

onMounted(() => {
  // 监听用户信息变化
  window.addEventListener('storage', (e) => {
    if (e.key === 'user') {
      currentUser.value = JSON.parse(e.newValue || 'null')
    }
  })

  // 添加点击外部关闭下拉菜单
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  box-shadow: 0 2px 20px rgba(255, 107, 53, 0.3);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-content {
  width: 100%;
  margin: 0;
  padding: 15px 20px;
  display: flex;
  align-items: center;
  gap: 30px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
}

.logo-icon {
  font-size: 32px;
  animation: bounce 2s infinite;
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-5px); }
}

.logo-text {
  font-size: 28px;
  font-weight: bold;
  color: #fff;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
}

.nav {
  flex: 1;
  display: flex;
  gap: 20px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border-radius: 20px;
  color: #fff;
  text-decoration: none;
  font-size: 15px;
  transition: all 0.3s ease;
}

.nav-item:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.nav-icon {
  font-size: 18px;
}

.user-area {
  display: flex;
  align-items: center;
  gap: 15px;
}

.publish-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background: #fff;
  color: #ff6b35;
  border-radius: 25px;
  text-decoration: none;
  font-weight: bold;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
}

.publish-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
}

.login-area {
  display: flex;
  gap: 10px;
}

.login-btn, .register-btn {
  padding: 8px 16px;
  border-radius: 20px;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s ease;
}

.login-btn {
  color: #fff;
  border: 2px solid #fff;
}

.register-btn {
  background: #fff;
  color: #ff6b35;
}

.user-dropdown {
  position: relative;
  cursor: pointer;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 5px 10px;
  border-radius: 25px;
  transition: all 0.3s ease;
}

.user-info:hover {
  background: rgba(255, 255, 255, 0.2);
}

.dropdown-arrow {
  color: #fff;
  font-size: 12px;
  transition: transform 0.3s ease;
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-weight: bold;
  font-size: 18px;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
}

.username {
  color: #fff;
  font-weight: 500;
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: 10px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
  min-width: 220px;
  overflow: hidden;
  animation: slideDown 0.3s ease;
  z-index: 1000;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.dropdown-header {
  padding: 15px;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

.current-account {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.current-account .label {
  font-size: 12px;
  color: #999;
}

.current-account .account-name {
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.dropdown-divider {
  height: 1px;
  background: #e9ecef;
}

.dropdown-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 15px;
  color: #333;
  text-decoration: none;
  transition: all 0.3s ease;
  cursor: pointer;
}

.dropdown-item:hover {
  background: #f8f9fa;
}

.item-icon {
  font-size: 18px;
}

.dropdown-item.switch-account {
  color: #007bff;
}

.dropdown-item.switch-account:hover {
  background: #e7f3ff;
}

.dropdown-item.logout {
  color: #dc3545;
}

.dropdown-item.logout:hover {
  background: #fff5f5;
}

.main-content {
  flex: 1;
  width: 100%;
  margin: 0;
  padding: 0;
}
</style>
