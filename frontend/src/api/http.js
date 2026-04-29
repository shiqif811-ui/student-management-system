import axios from "axios";

const http = axios.create({
  baseURL: "http://127.0.0.1:5000/api",
  timeout: 10000,
  headers: {
    "Content-Type": "application/json"
  }
});

http.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

http.interceptors.response.use(
  (response) => {
    console.log("HTTP Response:", response);
    return response.data;
  },
  (error) => {
    console.error("HTTP Error:", error);
    let message = "请求失败";
    if (error.response) {
      console.error("Error Response:", error.response);
      const status = error.response.status;
      if (status === 401) {
        message = "未登录或登录已过期，请重新登录";
        localStorage.removeItem("token");
        window.location.href = "/login";
      } else if (status === 403) {
        message = "没有权限访问此资源";
      } else if (status === 404) {
        message = "请求的资源不存在";
      } else if (status === 500) {
        message = "服务器内部错误，请稍后重试";
      } else {
        message = error.response.data?.msg || error.response.data?.message || "请求失败";
      }
    } else if (error.request) {
      console.error("Network Error - No Response Received:", error.request);
      message = "网络连接失败，请检查网络";
    } else {
      console.error("Request Setup Error:", error.message);
      message = error.message || "请求失败";
    }
    return Promise.reject(new Error(message));
  }
);

export default http;
