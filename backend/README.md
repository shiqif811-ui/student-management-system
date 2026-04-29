# Backend (Flask API)

该目录是学生管理系统的后端 API 服务（前后端分离）。

## 技术栈
- Flask
- Flask-SQLAlchemy
- Flask-CORS
- MySQL（通过 `DATABASE_URL` 配置）

## 运行方式
在 `backend` 目录执行：

```bash
python -m pip install -r requirements.txt
python app.py
```

服务默认运行在：
- `http://127.0.0.1:5000`

## 主要 API
- `GET /api/health`
- `GET /api/students`
- `POST /api/students`
- `DELETE /api/students/<sid>`
- `GET /api/stats`
- `POST /api/students/<sid>/grades`

## 环境变量
- `DATABASE_URL`（可选）
  - 默认值：`mysql+pymysql://root:Fsq125131@localhost:3306/student_db?charset=utf8mb4`

