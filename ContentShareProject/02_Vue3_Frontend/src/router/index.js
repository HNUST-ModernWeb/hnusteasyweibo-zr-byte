import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/login', component: () => import('../views/Login.vue') },
  { path: '/register', component: () => import('../views/Register.vue') },
  {
    path: '/',
    component: () => import('../views/Home.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/publish',
    component: () => import('../views/Publish.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/profile',
    component: () => import('../views/Profile.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/search',
    component: () => import('../views/Search.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/topic',
    component: () => import('../views/TopicSquare.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/topic/:id',
    component: () => import('../views/TopicDetail.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/message',
    component: () => import('../views/Message.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/settings',
    component: () => import('../views/Settings.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/user/:id',
    component: () => import('../views/UserProfile.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/article/:id',
    component: () => import('../views/ArticleDetail.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const user = JSON.parse(localStorage.getItem('user') || 'null')

  // 检查路由是否需要登录
  if (to.meta.requiresAuth && !user) {
    // 如果未登录且路由需要认证，跳转到登录页
    next('/login')
  } else if ((to.path === '/login' || to.path === '/register') && user) {
    // 如果已登录且访问登录/注册页，跳转到首页
    next('/')
  } else {
    next()
  }
})

export default router
