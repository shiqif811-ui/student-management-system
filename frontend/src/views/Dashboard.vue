<script setup>
import { onMounted, ref } from "vue";
import { getDashboardStats } from "../api/dashboard";

const loading = ref(false);
const stats = ref(null);
const error = ref("");

async function loadStats() {
  loading.value = true;
  error.value = "";
  try {
    const res = await getDashboardStats();
    stats.value = res;
  } catch (e) {
    error.value = e.message;
  } finally {
    loading.value = false;
  }
}

onMounted(loadStats);
</script>

<template>
  <section>
    <h1>数据概览</h1>
    <p>首页数据概览</p>

    <p v-if="loading">加载中...</p>
    <p v-else-if="error">{{ error }}</p>
    <div v-else-if="stats" class="cards">
      <div class="card">
        <h3>学生总数</h3>
        <p>{{ stats.student_count }}</p>
      </div>
      <div class="card">
        <h3>课程数量</h3>
        <p>{{ stats.course_count }}</p>
      </div>
      <div class="card">
        <h3>平均分</h3>
        <p>{{ Number(stats.avg_score || 0).toFixed(2) }}</p>
      </div>
      <div class="card">
        <h3>有成绩学生数</h3>
        <p>{{ stats.has_grades_count }}</p>
      </div>
      <div class="card">
        <h3>优秀人数</h3>
        <p>{{ stats.excellent_count }}</p>
      </div>
    </div>
  </section>
</template>

<style scoped>
.cards {
  display: grid;
  grid-template-columns: repeat(2, minmax(180px, 1fr));
  gap: 12px;
  max-width: 640px;
}

.card {
  background: #fff;
  border-radius: 10px;
  padding: 14px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.card h3 {
  margin: 0 0 8px;
  font-size: 14px;
  color: #6b7280;
}

.card p {
  margin: 0;
  font-size: 24px;
}
</style>
