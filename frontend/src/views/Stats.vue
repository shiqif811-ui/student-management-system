<script setup>
import { ref, onMounted } from "vue";
import { getStats } from "../api/stats";

const stats = ref({
  total: 0,
  avg: 0,
  pass_rate: 0
});
const loading = ref(true);
const error = ref("");

const loadStats = async () => {
  loading.value = true;
  error.value = "";
  try {
    const res = await getStats();
    stats.value = res;
  } catch (e) {
    error.value = e.message;
  } finally {
    loading.value = false;
  }
};

onMounted(loadStats);
</script>

<template>
  <section>
    <h1>统计分析</h1>
    <p>学生成绩统计信息</p>

    <p v-if="error" class="error">{{ error }}</p>

    <div v-if="loading" class="loading">加载中...</div>

    <div v-else class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">👥</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats.total }}</div>
          <div class="stat-label">学生总人数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">📊</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats.avg }}</div>
          <div class="stat-label">平均分</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">✅</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats.pass_rate }}%</div>
          <div class="stat-label">及格率</div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.error {
  color: #dc2626;
}

.loading {
  padding: 40px;
  text-align: center;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 16px;
  margin-top: 20px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.stat-icon {
  font-size: 36px;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f3f4f6;
  border-radius: 12px;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #1f2937;
}

.stat-label {
  font-size: 14px;
  color: #6b7280;
  margin-top: 4px;
}
</style>
