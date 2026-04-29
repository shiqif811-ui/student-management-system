import http from "./http";

export function getGrades(params = {}) {
  return http.get("/grades", { params });
}

export function createGrade(payload) {
  return http.post("/grades", payload);
}

export function updateGrade(id, payload) {
  return http.put(`/grades/${id}`, payload);
}

export function deleteGrade(id) {
  return http.delete(`/grades/${id}`);
}
