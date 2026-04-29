-- 学生信息管理系统：示例数据（可选导入）
USE `student_mis_db`;

-- 账号说明：
-- 密码哈希来自 Werkzeug（示例默认密码：Admin123 / Teacher123 / Student123）
-- 如需重新生成哈希，可直接用系统注册页注册。

INSERT INTO `users` (`username`, `password_hash`, `role`, `created_at`)
VALUES
  ('admin',   'scrypt:32768:8:1$QIhGXFqex5PZRTuY$4a58f9d5083f8090a4626064019220e81321dff1100d19b0fd75c957ba51c70738b48abacfbf387fc1d6005e0a313b7369a4b8cfa094351fa9906e601f28f462', 'admin',   NOW()),
  ('teacher', 'scrypt:32768:8:1$SshW6M2TcbLbGAz1$8cc5a7d25209a8a8edb7943d799854eb7a86ecbc860aa934da66b224543157a603a602bf2ce14c47d312e7a603e33d64865d59d0d6d0528c1de5e8744d32886d', 'teacher', NOW()),
  ('student', 'scrypt:32768:8:1$xNSKszAj7jdryurp$22261e9a68cc626d1bcefa6436161468a82edb027303349851a0cc63a85f41795d167ecd64e89e5f7b5128108fb1d676010fe8de132e7fb5d6e3b38eab9f0850', 'student', NOW())
ON DUPLICATE KEY UPDATE `role`=VALUES(`role`);

INSERT INTO `classes` (`name`, `grade_year`, `created_at`)
VALUES
  ('软件工程1班', '2026', NOW()),
  ('计算机科学2班', '2026', NOW())
ON DUPLICATE KEY UPDATE `grade_year`=VALUES(`grade_year`);

INSERT INTO `courses` (`name`, `credit`, `teacher_name`, `created_at`)
VALUES
  ('高等数学', 4.0, '张老师', NOW()),
  ('大学英语', 2.0, '李老师', NOW()),
  ('数据结构', 3.5, '王老师', NOW())
ON DUPLICATE KEY UPDATE `credit`=VALUES(`credit`), `teacher_name`=VALUES(`teacher_name`);

-- 示例学生
INSERT INTO `students`
  (`stu_no`,`name`,`gender`,`age`,`major`,`phone`,`parent_name`,`parent_phone`,`parent_relation`,`class_id`,`created_at`)
VALUES
  ('20260001','张三','男',20,'软件工程','13800000001','张父','13900000001','父亲', (SELECT id FROM classes WHERE name='软件工程1班' LIMIT 1), NOW()),
  ('20260002','李四','女',19,'计算机科学','13800000002','李母','13900000002','母亲', (SELECT id FROM classes WHERE name='计算机科学2班' LIMIT 1), NOW())
ON DUPLICATE KEY UPDATE `major`=VALUES(`major`), `class_id`=VALUES(`class_id`);

-- 选课
INSERT IGNORE INTO `enrollments` (`student_id`,`course_id`,`created_at`)
SELECT s.id, c.id, NOW()
FROM students s
JOIN courses c ON c.name IN ('高等数学','大学英语','数据结构')
WHERE s.stu_no='20260001';

INSERT IGNORE INTO `enrollments` (`student_id`,`course_id`,`created_at`)
SELECT s.id, c.id, NOW()
FROM students s
JOIN courses c ON c.name IN ('高等数学','大学英语')
WHERE s.stu_no='20260002';

-- 成绩
INSERT INTO `grades` (`student_id`,`course_id`,`score`,`term`,`created_at`,`updated_at`)
SELECT s.id, c.id, v.score, '2026-2027-1', NOW(), NOW()
FROM students s
JOIN courses c
JOIN (
  SELECT '20260001' AS stu_no, '高等数学' AS course, 92.0 AS score
  UNION ALL SELECT '20260001','大学英语',88.0
  UNION ALL SELECT '20260001','数据结构',95.0
  UNION ALL SELECT '20260002','高等数学',86.0
  UNION ALL SELECT '20260002','大学英语',90.0
) v ON v.stu_no=s.stu_no AND v.course=c.name
ON DUPLICATE KEY UPDATE `score`=VALUES(`score`), `updated_at`=NOW();

