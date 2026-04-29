<script setup>
import { ref, onMounted } from "vue"
import { getGrades, createGrade, updateGrade, deleteGrade } from "../api/grades"
import { getStudents } from "../api/student"

const list = ref([])
const students = ref([])
const showModal = ref(false)
const isEdit = ref(false)
const currentId = ref(null)
const sortBy = ref("desc")
const form = ref({
  student_id: "",
  course: "",
  score: ""
})
const error = ref("")

const loadGrades = async () => {
  try {
    const res = await getGrades({ sort: sortBy.value })
    list.value = res
  } catch (e) {
    error.value = e.message
  }
}

const loadStudents = async () => {
  try {
    const res = await getStudents()
    students.value = res
  } catch (e) {
    error.value = e.message
  }
}

const handleSortChange = () => {
  loadGrades()
}

const openAddModal = () => {
  isEdit.value = false
  currentId.value = null
  form.value = { student_id: "", course: "", score: "" }
  showModal.value = true
}

const openEditModal = (item) => {
  isEdit.value = true
  currentId.value = item.id
  form.value = {
    student_id: item.student_id.toString(),
    course: item.course,
    score: item.score.toString()
  }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  error.value = ""
}

const handleSubmit = async () => {
  error.value = ""
  if (!form.value.student_id || !form.value.course || !form.value.score) {
    error.value = "请填写完整信息"
    return
  }
  
  try {
    if (isEdit.value) {
      await updateGrade(currentId.value, {
        student_id: parseInt(form.value.student_id),
        course: form.value.course,
        score: parseFloat(form.value.score)
      })
    } else {
      await createGrade({
        student_id: parseInt(form.value.student_id),
        course: form.value.course,
        score: parseFloat(form.value.score)
      })
    }
    closeModal()
    loadGrades()
  } catch (e) {
    error.value = e.message
  }
}

const handleDelete = async (id) => {
  if (!confirm("确定要删除这条记录吗？")) {
    return
  }
  try {
    await deleteGrade(id)
    loadGrades()
  } catch (e) {
    error.value = e.message
  }
}

onMounted(() => {
  loadGrades()
  loadStudents()
})
</script>

<template>
  <div class="grades-container">
    <h2>成绩管理</h2>
    
    <p v-if="error" class="error">{{ error }}</p>
    
    <div class="actions">
      <button class="btn btn-primary" @click="openAddModal">新增</button>
      
      <div class="sort-select">
        <label>排序：</label>
        <select v-model="sortBy" @change="handleSortChange">
          <option value="desc">分数降序</option>
          <option value="asc">分数升序</option>
        </select>
      </div>
    </div>
    
    <table class="table">
      <thead>
        <tr>
          <th>学生</th>
          <th>课程</th>
          <th>分数</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in list" :key="item.id">
          <td>{{ item.student_name }}</td>
          <td>{{ item.course }}</td>
          <td>{{ item.score }}</td>
          <td>
            <button class="btn btn-secondary" @click="openEditModal(item)">编辑</button>
            <button class="btn btn-danger" @click="handleDelete(item.id)">删除</button>
          </td>
        </tr>
      </tbody>
    </table>
    
    <div v-if="list.length === 0" class="empty">
      <p>暂无数据</p>
    </div>
    
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal">
        <h3>{{ isEdit ? '编辑成绩' : '新增成绩' }}</h3>
        
        <p v-if="error" class="error">{{ error }}</p>
        
        <div class="form-group">
          <label>学生</label>
          <select v-model="form.student_id">
            <option value="">请选择学生</option>
            <option v-for="student in students" :key="student.id" :value="student.id">
              {{ student.name }}
            </option>
          </select>
        </div>
        
        <div class="form-group">
          <label>课程</label>
          <input v-model="form.course" type="text" placeholder="请输入课程名称" />
        </div>
        
        <div class="form-group">
          <label>分数</label>
          <input v-model="form.score" type="number" placeholder="请输入分数" />
        </div>
        
        <div class="modal-actions">
          <button class="btn btn-primary" @click="handleSubmit">提交</button>
          <button class="btn btn-secondary" @click="closeModal">取消</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.grades-container {
  max-width: 1000px;
}

.error {
  color: #dc2626;
  margin: 8px 0;
}

.actions {
  margin: 16px 0;
  display: flex;
  align-items: center;
  gap: 16px;
}

.sort-select {
  display: flex;
  align-items: center;
  gap: 8px;
}

.sort-select select {
  padding: 6px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-secondary {
  background: #6b7280;
  color: white;
  margin-right: 8px;
}

.btn-danger {
  background: #dc2626;
  color: white;
}

.table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.table th,
.table td {
  padding: 12px 16px;
  text-align: left;
  border-bottom: 1px solid #e5e7eb;
}

.table th {
  background: #f9fafb;
  font-weight: 600;
  color: #374151;
}

.table tr:hover {
  background: #f9fafb;
}

.empty {
  padding: 40px;
  text-align: center;
  color: #6b7280;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal {
  background: white;
  padding: 24px;
  border-radius: 12px;
  width: 90%;
  max-width: 400px;
}

.modal h3 {
  margin: 0 0 20px;
  font-size: 18px;
}

.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  margin-bottom: 6px;
  font-weight: 500;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  box-sizing: border-box;
}

.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 24px;
}
</style>
