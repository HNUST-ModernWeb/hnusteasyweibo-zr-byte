<template>
  <Layout>
    <div class="publish-page">
      <div class="page-header">
        <h1>✏️ 发布微博</h1>
      </div>

      <div class="publish-form">
        <div class="form-group">
          <textarea v-model="form.content" placeholder="分享新鲜事..." rows="6"></textarea>
        </div>

        <div class="form-toolbar">
          <div class="toolbar-left">
            <button type="button" @click="showTopicPicker = true">
              <span>🏷️</span> 话题
            </button>
            <button type="button" @click="showLocation = true">
              <span>📍</span> 位置
            </button>
            <button type="button">
              <span>📷</span> 图片
            </button>
            <button type="button">
              <span>🎥</span> 视频
            </button>
            <button type="button">
              <span>📊</span> 投票
            </button>
          </div>
          <div class="toolbar-right">
            <select v-model="form.visibility">
              <option value="public">🌍 公开</option>
              <option value="friends">👥 好友可见</option>
              <option value="private">🔒 仅自己可见</option>
            </select>
          </div>
        </div>

        <div v-if="form.topic" class="selected-topic">
          话题：#{{ form.topic }}#
          <button @click="form.topic = ''">×</button>
        </div>

        <div class="form-actions">
          <button type="submit" @click="handlePublish" :disabled="!form.content.trim()">
            发布
          </button>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Layout from '../components/Layout.vue'
import { articleApi } from '../utils/request'

const router = useRouter()
const form = ref({
  content: '',
  topic: '',
  visibility: 'public'
})
const showTopicPicker = ref(false)
const showLocation = ref(false)

const handlePublish = async () => {
  const user = JSON.parse(localStorage.getItem('user') || 'null')
  if (!user) {
    alert('请先登录')
    return
  }

  if (!form.value.content.trim()) {
    alert('请输入内容')
    return
  }

  try {
    const res = await articleApi.create({
      userId: user.id,
      content: form.value.content,
      topicName: form.value.topic,
      visibility: form.value.visibility
    })

    if (res.code === 200) {
      alert('发布成功')
      router.push('/')
    } else {
      alert(res.message || '发布失败')
    }
  } catch (e) {
    alert('发布失败')
  }
}
</script>

<style scoped>
.publish-page {
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

.publish-form {
  background: #fff;
  border-radius: 16px;
  padding: 30px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.form-group textarea {
  width: 100%;
  padding: 15px;
  border: 2px solid #e5e5e5;
  border-radius: 12px;
  resize: none;
  font-size: 16px;
  font-family: inherit;
  line-height: 1.6;
  transition: all 0.3s ease;
}

.form-group textarea:focus {
  outline: none;
  border-color: #ff6b35;
}

.form-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 15px;
  padding: 15px 0;
  border-top: 1px solid #f0f0f0;
}

.toolbar-left {
  display: flex;
  gap: 10px;
}

.toolbar-left button {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 8px 15px;
  border: none;
  background: #f5f5f5;
  border-radius: 20px;
  cursor: pointer;
  font-size: 14px;
  color: #666;
  transition: all 0.3s ease;
}

.toolbar-left button:hover {
  background: #ff6b35;
  color: #fff;
}

.toolbar-right select {
  padding: 8px 15px;
  border: 1px solid #e5e5e5;
  border-radius: 20px;
  background: #fff;
  font-size: 14px;
  cursor: pointer;
}

.selected-topic {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  margin-top: 15px;
  padding: 8px 15px;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  border-radius: 20px;
  font-size: 14px;
}

.selected-topic button {
  border: none;
  background: rgba(255, 255, 255, 0.3);
  color: #fff;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.form-actions {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.form-actions button {
  padding: 12px 40px;
  background: linear-gradient(135deg, #ff6b35 0%, #ff8c42 100%);
  color: #fff;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  font-size: 16px;
  font-weight: bold;
  transition: all 0.3s ease;
}

.form-actions button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(255, 107, 53, 0.3);
}

.form-actions button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
