<template>
  <Layout>
    <div class="settings-page">
      <div class="page-header">
        <h1>⚙️ 设置</h1>
      </div>

      <div class="settings-section">
        <h2>个人信息</h2>
        <div class="settings-form">
          <div class="form-group avatar-group">
            <label>头像</label>
            <div class="avatar-upload">
              <div class="avatar-preview" :style="{ backgroundImage: `url(${currentUser?.avatar || defaultAvatar})` }">
                <input type="file" id="avatarInput" accept="image/*" @change="handleAvatarUpload" />
                <label for="avatarInput" class="upload-label">
                  <span class="upload-icon">📷</span>
                  <span class="upload-text">更换头像</span>
                </label>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label>昵称</label>
            <input v-model="form.nickname" type="text" />
          </div>
          <div class="form-group">
            <label>个人简介</label>
            <textarea v-model="form.bio" rows="4"></textarea>
          </div>
          <div class="form-group">
            <label>性别</label>
            <select v-model="form.gender">
              <option :value="0">未知</option>
              <option :value="1">男</option>
              <option :value="2">女</option>
            </select>
          </div>
          <div class="form-group">
            <label>生日</label>
            <input v-model="form.birthday" type="date" />
          </div>
          <div class="form-group">
            <label>所在地</label>
            <input v-model="form.location" type="text" />
          </div>
          <button @click="saveProfile">保存修改</button>
        </div>
      </div>

      <div class="settings-section">
        <h2>账号安全</h2>
        <div class="settings-form">
          <div class="form-group">
            <label>手机号</label>
            <input v-model="form.phone" type="tel" />
          </div>
          <div class="form-group">
            <label>邮箱</label>
            <input v-model="form.email" type="email" />
          </div>
          <button @click="updateAccount">更新账号信息</button>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Layout from '../components/Layout.vue'
import { userApi } from '../utils/request'

const router = useRouter()
const currentUser = ref(JSON.parse(localStorage.getItem('user') || 'null'))
const defaultAvatar = 'https://api.dicebear.com/7.x/avataaars/svg?seed=' + (currentUser.value?.id || 'user')
const form = ref({
  nickname: '',
  bio: '',
  gender: 0,
  birthday: '',
  location: '',
  phone: '',
  email: ''
})

const loadUserInfo = async () => {
  if (!currentUser.value) {
    alert('请先登录')
    return
  }
  try {
    const res = await userApi.getById(currentUser.value.id)
    if (res.code === 200 && res.data) {
      Object.assign(form.value, res.data)
    }
  } catch (e) {
    console.log('加载用户信息失败', e)
  }
}

const saveProfile = async () => {
  if (!currentUser.value) return
  try {
    const res = await userApi.updateProfile({
      id: currentUser.value.id,
      nickname: form.value.nickname,
      bio: form.value.bio,
      gender: form.value.gender,
      birthday: form.value.birthday,
      location: form.value.location
    })
    if (res.code === 200) {
      alert('保存成功')
      loadUserInfo()
    } else {
      alert(res.message || '保存失败')
    }
  } catch (e) {
    alert('保存失败')
  }
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

const updateAccount = async () => {
  if (!currentUser.value) return
  try {
    const res = await userApi.updateAccount({
      id: currentUser.value.id,
      phone: form.value.phone,
      email: form.value.email
    })
    if (res.code === 200) {
      alert('更新成功')
    } else {
      alert(res.message || '更新失败')
    }
  } catch (e) {
    alert('更新失败')
  }
}

onMounted(() => {
  loadUserInfo()
})
</script>

<style scoped>
.settings-page {
  width: 100%;
  max-width: none;
  margin: 0;
  padding: 0;
}

.page-header {
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 28px;
  color: #333;
}

.settings-section {
  background: #fff;
  border-radius: 16px;
  padding: 30px;
  margin-bottom: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.settings-section h2 {
  font-size: 18px;
  color: #333;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f0f0f0;
}

.settings-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group.avatar-group {
  flex-direction: row;
  align-items: flex-start;
}

.form-group.avatar-group label {
  width: 80px;
  flex-shrink: 0;
}

.avatar-upload {
  flex: 1;
}

.avatar-preview {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background-size: cover;
  background-position: center;
  background-color: #f5f5f5;
  position: relative;
  cursor: pointer;
  border: 3px solid #e5e5e5;
  transition: all 0.3s ease;
}

.avatar-preview:hover {
  border-color: #ff6b35;
  transform: scale(1.05);
}

.avatar-preview input {
  display: none;
}

.upload-label {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0, 0, 0, 0.6);
  color: #fff;
  padding: 8px;
  border-radius: 0 0 50% 50%;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.avatar-preview:hover .upload-label {
  opacity: 1;
}

.upload-icon {
  font-size: 18px;
}

.upload-text {
  font-size: 12px;
}

.form-group label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.form-group input,
.form-group textarea,
.form-group select {
  padding: 12px;
  border: 2px solid #e5e5e5;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s ease;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  outline: none;
  border-color: #ff6b35;
}

button {
  padding: 12px 30px;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  font-weight: bold;
  transition: all 0.3s ease;
  align-self: flex-start;
}

button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}
</style>
