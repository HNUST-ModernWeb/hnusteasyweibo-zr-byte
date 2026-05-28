import axios from 'axios'

const request = axios.create({
  baseURL: 'http://localhost:8081/api'
})

request.interceptors.request.use(config => {
  return config
})

request.interceptors.response.use(res => {
  return res.data
})

export default request

export const userApi = {
  register: (data) => request.post('/user/register', null, { params: data }),
  login: (data) => request.post('/user/login', null, { params: data }),
  getUserInfo: (userId) => request.get(`/user/info/${userId}`),
  updateUserInfo: (data) => request.put('/user/info', data),
  updatePassword: (data) => request.put('/user/password', null, { params: data }),
  getHotUsers: (userId, limit) => request.get('/user/hot', { params: { userId, limit } }),
  searchUsers: (keyword) => request.get('/user/search', { params: { keyword } }),
  follow: (userId, followUserId) => request.post(`/user/follow/${followUserId}`, null, { params: { userId } }),
  unfollow: (userId, followUserId) => request.delete(`/user/follow/${followUserId}`, { params: { userId } }),
  setSpecialFollow: (userId, followUserId, isSpecial) => request.put(`/user/follow/${followUserId}/special`, null, { params: { userId, isSpecial } }),
  getFollowingList: (userId) => request.get(`/user/${userId}/following`),
  getFansList: (userId) => request.get(`/user/${userId}/fans`),
  getSpecialFollowingList: (userId) => request.get(`/user/${userId}/following/special`)
}

export const articleApi = {
  publish: (data) => request.post('/article/publish', data),
  update: (data) => request.put('/article/update', data),
  delete: (articleId, userId) => request.delete(`/article/${articleId}`, { params: { userId } }),
  getById: (articleId, userId) => request.get(`/article/${articleId}`, { params: { userId } }),
  getFollowFeed: (userId, page, limit) => request.get('/article/feed/follow', { params: { userId, page, limit } }),
  getHotFeed: (userId, page, limit) => request.get('/article/feed/hot', { params: { userId, page, limit } }),
  getNearbyFeed: (page, limit) => request.get('/article/feed/nearby', { params: { page, limit } }),
  getRecommendFeed: (userId, page, limit) => request.get('/article/feed/recommend', { params: { userId, page, limit } }),
  getUserArticles: (userId, page, limit) => request.get(`/article/user/${userId}`, { params: { page, limit } }),
  getTopicArticles: (topicId, page, limit) => request.get(`/article/topic/${topicId}`, { params: { page, limit } }),
  search: (keyword, page, limit) => request.get('/article/search', { params: { keyword, page, limit } }),
  like: (userId, articleId) => request.post(`/article/like/${articleId}`, null, { params: { userId } }),
  unlike: (userId, articleId) => request.delete(`/article/like/${articleId}`, { params: { userId } }),
  favorite: (userId, articleId) => request.post(`/article/favorite/${articleId}`, null, { params: { userId } }),
  unfavorite: (userId, articleId) => request.delete(`/article/favorite/${articleId}`, { params: { userId } }),
  getLiked: (userId) => request.get('/article/liked', { params: { userId } }),
  getFavorited: (userId) => request.get('/article/favorited', { params: { userId } }),
  forward: (userId, articleId, content) => request.post(`/article/forward/${articleId}`, null, { params: { userId, content } })
}

export const commentApi = {
  add: (data) => request.post('/comment', null, { params: data }),
  delete: (commentId, userId) => request.delete(`/comment/${commentId}`, { params: { userId } }),
  getByArticle: (articleId) => request.get(`/comment/article/${articleId}`),
  getReplies: (commentId) => request.get(`/comment/${commentId}/replies`),
  like: (userId, commentId) => request.post(`/comment/${commentId}/like`, null, { params: { userId } })
}

export const messageApi = {
  getConversations: (userId) => request.get('/message/conversations', { params: { userId } }),
  getMessages: (userId, targetUserId, page, limit) => request.get(`/message/conversation/${targetUserId}`, { params: { userId, page, limit } }),
  send: (fromUserId, toUserId, content, messageType) => request.post('/message', null, { params: { fromUserId, toUserId, content, messageType } }),
  markAsRead: (userId, fromUserId) => request.put(`/message/read/${fromUserId}`, null, { params: { userId } }),
  getUnreadCount: (userId) => request.get('/message/unread', { params: { userId } })
}

export const topicApi = {
  create: (data) => request.post('/topic', data),
  getById: (topicId) => request.get(`/topic/${topicId}`),
  getByName: (name) => request.get(`/topic/name/${name}`),
  getHot: (limit) => request.get('/topic/hot', { params: { limit } }),
  getRecommend: () => request.get('/topic/recommend'),
  getByCategory: (category) => request.get(`/topic/category/${category}`),
  search: (keyword) => request.get('/topic/search', { params: { keyword } })
}

export const searchApi = {
  getHotSearches: (category, limit) => request.get('/search/hot', { params: { category, limit } }),
  getSearchHistory: (userId, limit) => request.get('/search/history', { params: { userId, limit } }),
  clearHistory: (userId) => request.delete('/search/history', { params: { userId } }),
  deleteHistory: (userId, historyId) => request.delete(`/search/history/${historyId}`, { params: { userId } }),
  addKeyword: (keyword, category) => request.post('/search/keyword', null, { params: { keyword, category } })
}

export const settingsApi = {
  get: (userId) => request.get('/settings', { params: { userId } }),
  update: (data) => request.put('/settings', data)
}
