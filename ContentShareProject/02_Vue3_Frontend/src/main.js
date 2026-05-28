import { createApp } from 'vue'
import App from './App.vue'
// 此时路由已经安装完成，可以正常导入挂载
import router from './router'
import './style.css'

createApp(App).use(router).mount('#app')