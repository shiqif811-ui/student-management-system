import os
import re
from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func, or_
from datetime import datetime, timedelta
import hashlib

app = Flask(__name__)
CORS(app)

app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://root:Fsq125131@localhost:3306/student_db?charset=utf8mb4"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SECRET_KEY"] = "student_management_secret_key"

db = SQLAlchemy(app)

# ===================== 模型 =====================
class Student(db.Model):
    __tablename__ = "students"
    id = db.Column(db.Integer, primary_key=True)
    stu_no = db.Column(db.String(20), unique=True)
    name = db.Column(db.String(20))
    gender = db.Column(db.String(10))
    age = db.Column(db.Integer)
    major = db.Column(db.String(50))


class Grade(db.Model):
    __tablename__ = "grades"
    id = db.Column(db.Integer, primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey("students.id"))
    course = db.Column(db.String(50))
    score = db.Column(db.Float)


class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True)
    password = db.Column(db.String(100))


# 初始化数据库
with app.app_context():
    db.create_all()
    try:
        if not User.query.first():
            admin = User(username="admin", password="admin123")
            db.session.add(admin)
            db.session.commit()
    except Exception as e:
        print(f"User table not ready yet: {e}")

# ===================== 登录接口 =====================
@app.route("/api/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")
    
    if username == "admin" and password == "admin123":
        token = hashlib.md5(f"admin_{datetime.now().timestamp()}".encode()).hexdigest()
        return jsonify({"token": token, "msg": "登录成功"})
    
    return jsonify({"msg": "用户名或密码错误"}), 401

# ===================== Dashboard 接口 =====================
@app.route("/api/dashboard", methods=["GET"])
def get_dashboard():
    student_count = Student.query.count()
    grades = Grade.query.all()
    course_count = len(set(g.course for g in grades)) if grades else 0
    
    if grades:
        avg_score = sum(g.score for g in grades) / len(grades)
        has_grades_count = len(set(g.student_id for g in grades))
        excellent_count = sum(1 for g in grades if g.score >= 90)
    else:
        avg_score = 0
        has_grades_count = 0
        excellent_count = 0
    
    return jsonify({
        "student_count": student_count,
        "course_count": course_count,
        "avg_score": round(avg_score, 2),
        "has_grades_count": has_grades_count,
        "excellent_count": excellent_count,
        "overall_avg": round(avg_score, 2)
    })

# ===================== 学生接口 =====================
@app.route("/api/students", methods=["GET"])
def get_students():
    q = request.args.get("q", "")
    if q:
        students = Student.query.filter(or_(
            Student.name.like(f"%{q}%"),
            Student.stu_no.like(f"%{q}%")
        )).all()
    else:
        students = Student.query.all()
    return jsonify([
        {
            "id": s.id,
            "stu_no": s.stu_no,
            "name": s.name,
            "gender": s.gender,
            "age": s.age,
            "major": s.major
        }
        for s in students
    ])


@app.route("/api/students/search", methods=["GET"])
def search_students():
    name = request.args.get("name", "")
    if not name:
        return jsonify([])
    
    students = Student.query.filter(Student.name.like(f"%{name}%")).all()
    return jsonify([
        {
            "id": s.id,
            "name": s.name
        }
        for s in students
    ])


@app.route("/api/students", methods=["POST"])
def add_student():
    data = request.get_json()

    stu = Student(
        stu_no=data["stu_no"],
        name=data["name"],
        gender=data.get("gender"),
        age=data.get("age"),
        major=data.get("major")
    )

    db.session.add(stu)
    db.session.commit()

    return jsonify({"msg": "添加成功"})


@app.route("/api/students/<int:id>", methods=["PUT"])
def update_student(id):
    student = Student.query.get(id)
    if not student:
        return jsonify({"msg": "学生不存在"}), 404
    
    data = request.get_json()
    if "name" in data:
        student.name = data["name"]
    if "gender" in data:
        student.gender = data["gender"]
    if "age" in data:
        student.age = data["age"]
    if "major" in data:
        student.major = data["major"]
    
    db.session.commit()
    return jsonify({"msg": "修改成功"})


@app.route("/api/students/<int:id>", methods=["DELETE"])
def delete_student(id):
    student = Student.query.get(id)
    if not student:
        return jsonify({"msg": "学生不存在"}), 404
    
    db.session.delete(student)
    db.session.commit()
    return jsonify({"msg": "删除成功"})

# ===================== 成绩接口 =====================
@app.route("/api/grades", methods=["GET"])
def get_grades():
    sort = request.args.get("sort", "desc")
    
    if sort == "asc":
        rows = db.session.query(Grade, Student).join(Student).order_by(Grade.score.asc()).all()
    else:
        rows = db.session.query(Grade, Student).join(Student).order_by(Grade.score.desc()).all()

    return jsonify([
        {
            "id": g.id,
            "student_id": s.id,
            "student_name": s.name,
            "course": g.course,
            "score": g.score
        }
        for g, s in rows
    ])


@app.route("/api/grades", methods=["POST"])
def add_grade():
    data = request.get_json()

    grade = Grade(
        student_id=data["student_id"],
        course=data["course"],
        score=data["score"]
    )

    db.session.add(grade)
    db.session.commit()

    return jsonify({"msg": "添加成功"})


@app.route("/api/grades/<int:id>", methods=["PUT"])
def update_grade(id):
    grade = Grade.query.get(id)
    if not grade:
        return jsonify({"msg": "成绩不存在"}), 404
    
    data = request.get_json()
    if "student_id" in data:
        grade.student_id = data["student_id"]
    if "course" in data:
        grade.course = data["course"]
    if "score" in data:
        grade.score = data["score"]
    
    db.session.commit()
    return jsonify({"msg": "修改成功"})


@app.route("/api/grades/<int:id>", methods=["DELETE"])
def delete_grade(id):
    g = Grade.query.get(id)
    if not g:
        return jsonify({"msg": "不存在"}), 404

    db.session.delete(g)
    db.session.commit()

    return jsonify({"msg": "删除成功"})


# ===================== 统计接口 =====================
@app.route("/api/stats", methods=["GET"])
def get_stats():
    total = Student.query.count()
    
    avg_score_result = db.session.query(func.avg(Grade.score)).first()
    avg = round(avg_score_result[0] or 0, 2)
    
    total_grades = Grade.query.count()
    if total_grades > 0:
        pass_count = Grade.query.filter(Grade.score >= 60).count()
        pass_rate = round((pass_count / total_grades) * 100, 2)
    else:
        pass_rate = 0
    
    return jsonify({
        "total": total,
        "avg": avg,
        "pass_rate": pass_rate
    })


# ===================== 系统信息接口 =====================
@app.route("/api/system/info", methods=["GET"])
def get_system_info():
    student_count = Student.query.count()
    
    return jsonify({
        "status": "running",
        "student_count": student_count,
        "timestamp": int(datetime.now().timestamp())
    })


@app.route("/api/majors", methods=["GET"])
def get_majors():
    majors = db.session.query(Student.major).distinct().filter(Student.major.isnot(None)).all()
    return jsonify([m[0] for m in majors])


if __name__ == "__main__":
    app.run(debug=True)
