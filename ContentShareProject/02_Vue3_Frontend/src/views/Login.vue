<template>
  <Layout>
    <div class="login-page">
      <div class="login-box">
        <h2>登录</h2>
        <form @submit.prevent="handleLogin">
          <div class="form-group">
            <input v-model="form.username" type="text" placeholder="用户名" required />
          </div>
          <div class="form-group">
            <input v-model="form.password" type="password" placeholder="密码" required />
          </div>
          <button type="submit">登录</button>
          <div class="links">
            <router-link to="/register">没有账号？立即注册</router-link>
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
  password: ''
})

const handleLogin = async () => {
  try {
    const res = await userApi.login(form.value)
    if (res.code === 200) {
      localStorage.setItem('user', JSON.stringify(res.data))
      alert('登录成功')
      router.push('/')
    } else {
      alert(res.message || '登录失败')
    }
  } catch (e) {
    alert('登录失败')
  }
}
</script>

<style scoped>
.login-page {
  min-height: calc(100vh - 70px);
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 20px;
}
.login-box {
  background: #fff;
  padding: 40px;
  border-radius: 16px;
  width: 350px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}
.login-box h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
  font-size: 24px;
}
.form-group {
  margin-bottom: 20px;
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
