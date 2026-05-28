<template>
  <Layout>
    <div class="register-page">
      <div class="register-box">
        <h2>注册</h2>
        <form @submit.prevent="handleRegister">
          <div class="form-group">
            <input v-model="form.username" type="text" placeholder="用户名" required />
          </div>
          <div class="form-group">
            <input v-model="form.password" type="password" placeholder="密码" required />
          </div>
          <div class="form-group">
            <input v-model="form.nickname" type="text" placeholder="昵称" required />
          </div>
          <div class="form-group">
            <input v-model="form.email" type="email" placeholder="邮箱" />
          </div>
          <div class="form-group">
            <input v-model="form.phone" type="tel" placeholder="手机号" />
          </div>
          <button type="submit">注册</button>
          <div class="links">
            <router-link to="/login">已有账号？立即登录</router-link>
          </div>
        </form>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Layout from '../components/Layout.vue'
import { userApi } from '../utils/request'

const router = useRouter()
const form = ref({
  username: '',
  password: '',
  nickname: '',
  email: '',
  phone: ''
})

const handleRegister = async () => {
  try {
    const res = await userApi.register(form.value)
    if (res.code === 200) {
      alert('注册成功')
      router.push('/login')
    } else {
      alert(res.message || '注册失败')
    }
  } catch (e) {
    alert('注册失败')
  }
}
</script>

<style scoped>
.register-page {
  min-height: calc(100vh - 70px);
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 20px;
}
.register-box {
  background: #fff;
  padding: 40px;
  border-radius: 16px;
  width: 350px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}
.register-box h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
  font-size: 24px;
}
.form-group {
  margin-bottom: 15px;
}
.form-group input {
  width: 100%;
  padding: 12px;
  border: 1px solid #e5e5e5;
  border-radius: 8px;
  box-sizing: border-box;
  font-size: 14px;
  transition: all 0.3s ease;
}
.form-group input:focus {
  outline: none;
  border-color: #ff6b35;
  box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.1);
}
button {
  width: 100%;
  padding: 12px;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
  font-weight: bold;
  transition: all 0.3s ease;
  margin-top: 10px;
}
button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}
.links {
  margin-top: 20px;
  text-align: center;
}
.links a {
  color: #ff6b35;
  text-decoration: none;
  font-size: 14px;
}
</style>
