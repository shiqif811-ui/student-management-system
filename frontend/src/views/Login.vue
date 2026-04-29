<script setup>import { ref } from "vue";
import { login } from "../api/auth";
const username = ref("");
const password = ref("");
const error = ref("");
const loading = ref(false);
const handleLogin = async () => {
 error.value = "";
 if (!username.value || !password.value) {
 error.value = "请填写用户名和密码";
 return;
 }
 loading.value = true;
 try {
 const res = await login({
 username: username.value,
 password: password.value
 });
 localStorage.setItem("token", res.token);
 window.location.href = "/";
 }
 catch (e) {
 error.value = e.message;
 }
 finally {
 loading.value = false;
 }
};
</script>

<template>
  <div class="login-container">
    <div class="login-box">
      <h2>学生管理系统</h2>
      <p class="subtitle">欢迎登录</p>
      
      <div v-if="error" class="error">{{ error }}</div>
      
      <div class="form-group">
        <label>用户名</label>
        <input 
          v-model="username" 
          type="text" 
          placeholder="请输入用户名"
          @keyup.enter="handleLogin"
        />
      </div>
      
      <div class="form-group">
        <label>密码</label>
        <input 
          v-model="password" 
          type="password" 
          placeholder="请输入密码"
          @keyup.enter="handleLogin"
        />
      </div>
      
      <button class="btn btn-primary" @click="handleLogin" :disabled="loading">
        {{ loading ? '登录中...' : '登录' }}
      </button>
      
      <p class="hint">默认账号: admin / admin123</p>
    </div>
  </div>
</template>

<style scoped>
.login-container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-box {
  background: white;
  padding: 40px;
  border-radius: 12px;
  width: 100%;
  max-width: 360px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.login-box h2 {
  margin: 0 0 4px;
  font-size: 24px;
  text-align: center;
}

.subtitle {
  color: #6b7280;
  text-align: center;
  margin: 0 0 24px;
}

.error {
  color: #dc2626;
  padding: 10px;
  background: #fef2f2;
  border-radius: 6px;
  margin-bottom: 16px;
}

.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  margin-bottom: 6px;
  font-weight: 500;
}

.form-group input {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  box-sizing: border-box;
  font-size: 14px;
}

.btn {
  width: 100%;
  padding: 12px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 16px;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-primary:disabled {
  background: #93c5fd;
  cursor: not-allowed;
}

.hint {
  text-align: center;
  margin-top: 16px;
  font-size: 12px;
  color: #9ca3af;
}
</style>
