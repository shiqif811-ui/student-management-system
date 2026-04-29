-- 学生信息管理系统（MySQL 8+）建表 SQL
-- 说明：与本项目 SQLAlchemy 模型一致，可用于课程作业提交

CREATE DATABASE IF NOT EXISTS `student_mis_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `student_mis_db`;

CREATE TABLE IF NOT EXISTS `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `role` VARCHAR(20) NOT NULL,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_username` (`username`),
  KEY `ix_users_username` (`username`),
  KEY `ix_users_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `classes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `grade_year` VARCHAR(20) NULL,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_classes_name` (`name`),
  KEY `ix_classes_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `students` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `stu_no` VARCHAR(20) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `gender` VARCHAR(10) NULL,
  `birthday` DATE NULL,
  `age` INT NULL,
  `major` VARCHAR(50) NULL,
  `phone` VARCHAR(30) NULL,
  `email` VARCHAR(120) NULL,
  `address` VARCHAR(255) NULL,
  `parent_name` VARCHAR(50) NULL,
  `parent_phone` VARCHAR(30) NULL,
  `parent_relation` VARCHAR(20) NULL,
  `class_id` INT NULL,
  `user_id` INT NULL,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_students_stu_no` (`stu_no`),
  UNIQUE KEY `uq_students_user_id` (`user_id`),
  KEY `ix_students_stu_no` (`stu_no`),
  KEY `ix_students_name` (`name`),
  KEY `ix_students_gender` (`gender`),
  KEY `ix_students_major` (`major`),
  KEY `ix_students_class_id` (`class_id`),
  CONSTRAINT `fk_students_class_id` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_students_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `courses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  `credit` DOUBLE NULL,
  `teacher_name` VARCHAR(50) NULL,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_courses_name` (`name`),
  KEY `ix_courses_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `enrollments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_enrollment_student_course` (`student_id`,`course_id`),
  KEY `ix_enrollments_student_id` (`student_id`),
  KEY `ix_enrollments_course_id` (`course_id`),
  CONSTRAINT `fk_enrollments_student_id` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_enrollments_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `grades` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `score` DOUBLE NOT NULL,
  `term` VARCHAR(30) NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_grade_student_course` (`student_id`,`course_id`),
  KEY `ix_grades_student_id` (`student_id`),
  KEY `ix_grades_course_id` (`course_id`),
  CONSTRAINT `fk_grades_student_id` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_grades_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `attendance` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `course_id` INT NULL,
  `day` DATE NOT NULL,
  `status` VARCHAR(20) NOT NULL,
  `note` VARCHAR(255) NULL,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_att_student_course_day` (`student_id`,`course_id`,`day`),
  KEY `ix_attendance_student_id` (`student_id`),
  KEY `ix_attendance_course_id` (`course_id`),
  KEY `ix_attendance_day` (`day`),
  CONSTRAINT `fk_attendance_student_id` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_attendance_course_id` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `settings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `key` VARCHAR(80) NOT NULL,
  `value` VARCHAR(255) NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_settings_key` (`key`),
  KEY `ix_settings_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

