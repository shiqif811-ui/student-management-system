<template>
  <div class="layout">
    <aside class="sidebar">
      <h2 class="logo">学生管理系统</h2>
      <nav class="nav">
        <RouterLink to="/">数据概览</RouterLink>
        <RouterLink to="/students">学生管理</RouterLink>
        <RouterLink to="/grades">成绩管理</RouterLink>
        <RouterLink to="/stats">统计分析</RouterLink>
        <button class="logout-btn" @click="handleLogout">退出登录</button>
      </nav>
    </aside>
    <main class="content">
      <RouterView />
    </main>
  </div>
</template>

<script setup>
const handleLogout = () => {
  localStorage.removeItem("token")
  window.location.href = "/login"
}
</script>

<style scoped>
.layout {
  display: grid;
  grid-template-columns: 220px 1fr;
  min-height: 100vh;
}

.sidebar {
  padding: 20px;
  background: #0f172a;
  color: #e5e7eb;
}

.logo {
  font-size: 18px;
  margin: 0 0 20px;
}

.nav {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.nav a {
  padding: 8px 12px;
  border-radius: 8px;
  color: #e5e7eb;
  text-decoration: none;
}

.nav a.router-link-active {
  background: #1d4ed8;
}

.logout-btn {
  margin-top: 20px;
  padding: 8px 12px;
  border: none;
  border-radius: 8px;
  background: #dc2626;
  color: white;
  cursor: pointer;
  text-align: left;
}

.content {
  padding: 24px;
  background: #f3f4f6;
}
</style>
