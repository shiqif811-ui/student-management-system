<script setup>
import { onMounted, reactive, ref } from "vue";
import { createStudent, deleteStudent, getStudents, searchStudents } from "../api/student";

const loading = ref(false);
const saving = ref(false);
const deletingId = ref(null);
const error = ref("");
const students = ref([]);

const queryForm = reactive({
  q: ""
});

const searchInput = ref("");
const searchResults = ref([]);
const showDropdown = ref(false);

const addForm = reactive({
  stu_no: "",
  name: "",
  gender: "",
  age: "",
  major: ""
});

async function loadStudents() {
  loading.value = true;
  error.value = "";
  try {
    const params = {};
    if (queryForm.q.trim()) params.q = queryForm.q.trim();
    const res = await getStudents(params);
    students.value = Array.isArray(res) ? res : [];
  } catch (e) {
    error.value = e.message;
  } finally {
    loading.value = false;
  }
}

async function handleSearchInput() {
  if (!searchInput.value.trim()) {
    searchResults.value = [];
    showDropdown.value = false;
    return;
  }
  
  try {
    const res = await searchStudents(searchInput.value);
    searchResults.value = Array.isArray(res) ? res : [];
    showDropdown.value = searchResults.value.length > 0;
  } catch (e) {
    console.error("搜索失败:", e);
    searchResults.value = [];
  }
}

function selectStudent(item) {
  searchInput.value = item.name;
  queryForm.q = item.name;
  showDropdown.value = false;
  loadStudents();
}

function closeDropdown() {
  setTimeout(() => {
    showDropdown.value = false;
  }, 200);
}

async function handleAddStudent() {
  saving.value = true;
  error.value = "";
  try {
    await createStudent({
      stu_no: addForm.stu_no,
      name: addForm.name,
      gender: addForm.gender || null,
      age: addForm.age === "" ? null : Number(addForm.age),
      major: addForm.major || null
    });
    addForm.stu_no = "";
    addForm.name = "";
    addForm.gender = "";
    addForm.age = "";
    addForm.major = "";
    await loadStudents();
  } catch (e) {
    error.value = e.message;
  } finally {
    saving.value = false;
  }
}

async function handleDeleteStudent(id) {
  const confirmed = window.confirm("确定删除该学生吗？");
  if (!confirmed) return;

  deletingId.value = id;
  error.value = "";
  try {
    await deleteStudent(id);
    await loadStudents();
  } catch (e) {
    error.value = e.message;
  } finally {
    deletingId.value = null;
  }
}

onMounted(loadStudents);
</script>

<template>
  <section>
    <h1>学生管理</h1>
    <p>学生管理（查询、添加、删除）</p>

    <div class="panel">
      <h3>学生搜索（输入联想）</h3>
      <div class="search-container" @mouseleave="closeDropdown">
        <input 
          v-model="searchInput" 
          placeholder="输入学生姓名搜索..." 
          @input="handleSearchInput"
          @focus="handleSearchInput"
        />
        <div v-if="showDropdown && searchResults.length > 0" class="dropdown">
          <div 
            v-for="item in searchResults" 
            :key="item.id" 
            class="dropdown-item"
            @click="selectStudent(item)"
          >
            <span>{{ item.name }}</span>
            <span class="id-tag">#{{ item.id }}</span>
          </div>
        </div>
      </div>
    </div>

    <div class="panel">
      <h3>添加学生</h3>
      <form class="grid" @submit.prevent="handleAddStudent">
        <input v-model="addForm.stu_no" required placeholder="学号" />
        <input v-model="addForm.name" required placeholder="姓名" />
        <input v-model="addForm.gender" placeholder="性别（男/女）" />
        <input v-model="addForm.age" type="number" min="0" placeholder="年龄" />
        <input v-model="addForm.major" placeholder="专业" />
        <button type="submit" :disabled="saving">{{ saving ? "提交中..." : "添加" }}</button>
      </form>
    </div>

    <p v-if="error" class="error">{{ error }}</p>
    <p v-if="loading">加载中...</p>

    <table v-if="!loading" class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>学号</th>
          <th>姓名</th>
          <th>性别</th>
          <th>年龄</th>
          <th>专业</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in students" :key="item.id">
          <td>{{ item.id }}</td>
          <td>{{ item.stu_no }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.gender || "-" }}</td>
          <td>{{ item.age ?? "-" }}</td>
          <td>{{ item.major || "-" }}</td>
          <td>
            <button :disabled="deletingId === item.id" @click="handleDeleteStudent(item.id)">
              {{ deletingId === item.id ? "删除中..." : "删除" }}
            </button>
          </td>
        </tr>
        <tr v-if="students.length === 0">
          <td colspan="7">暂无数据</td>
        </tr>
      </tbody>
    </table>
  </section>
</template>

<style scoped>
.panel {
  background: #fff;
  border-radius: 10px;
  padding: 14px;
  margin-bottom: 14px;
}

.search-container {
  position: relative;
  width: 300px;
}

.search-container input {
  width: 100%;
  padding: 10px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  font-size: 14px;
}

.dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  margin-top: 4px;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  z-index: 100;
}

.dropdown-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  cursor: pointer;
  border-bottom: 1px solid #f3f4f6;
}

.dropdown-item:hover {
  background: #f9fafb;
}

.dropdown-item:last-child {
  border-bottom: none;
}

.id-tag {
  font-size: 12px;
  color: #9ca3af;
  background: #f3f4f6;
  padding: 2px 6px;
  border-radius: 4px;
}

.row {
  display: flex;
  gap: 8px;
}

.grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(160px, 1fr));
  gap: 8px;
}

input,
button {
  padding: 8px 10px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
}

button {
  background: #2563eb;
  color: #fff;
  border: none;
}

.error {
  color: #dc2626;
}

.table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 10px;
  overflow: hidden;
}

.table th,
.table td {
  border-bottom: 1px solid #e5e7eb;
  padding: 10px;
  text-align: left;
}
</style>
