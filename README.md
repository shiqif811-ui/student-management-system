# Student Management (前后端分离)

## 项目结构

```text
student_management/
  backend/   # Flask API
  frontend/  # Vue3 + Vite
```

## Backend 启动

```bash
cd backend
python -m pip install -r requirements.txt
python app.py
```

后端默认地址：
- `http://127.0.0.1:5000`

## Frontend 启动

```bash
cd frontend
npm install
npm run dev
```

前端默认地址（Vite）：
- `http://127.0.0.1:5173`

## 对接说明

- 前端 API 基础地址在 `frontend/src/api/http.js`
- 当前配置：`http://127.0.0.1:5000`
- Students 页面已接入：
  - 获取学生列表：`GET /api/students`
  - 添加学生：`POST /api/students`
  - 删除学生：`DELETE /api/students/<id>`
## 项目截图

### 登录页面

![登录页面](image/login.png)

### 学生管理页面

![学生管理页面](images/student.png)

### 成绩管理页面

![成绩管理页面](images/grade.png)
