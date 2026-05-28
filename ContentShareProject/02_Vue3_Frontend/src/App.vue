<template>
  <!-- 路由页面出口：所有页面内容都渲染在这里 -->
  <router-view />
</template>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: "Microsoft Yahei", sans-serif;
}
html, body {
  width: 100%;
  min-height: 100vh;
  background-color: #f0f2f5;
  margin: 0;
  padding: 0;
}
/* 全局容器统一样式 */
.container {
  width: 100%;
  margin: 0;
  padding: 0;
}
</style>