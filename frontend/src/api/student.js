import http from "./http";

export function getStudents(params = {}) {
  return http.get("/students", { params });
}

export function searchStudents(name) {
  return http.get("/students/search", { params: { name } });
}

export function createStudent(payload) {
  return http.post("/students", payload);
}

export function updateStudent(id, payload) {
  return http.put(`/students/${id}`, payload);
}

export function deleteStudent(id) {
  return http.delete(`/students/${id}`);
}
