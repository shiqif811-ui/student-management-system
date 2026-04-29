import { createRouter, createWebHistory } from "vue-router";
import DashboardView from "../views/Dashboard.vue";
import StudentsView from "../views/Students.vue";
import GradesView from "../views/Grades.vue";
import QueryView from "../views/Query.vue";
import StatsView from "../views/Stats.vue";
import LoginView from "../views/Login.vue";

const routes = [
  { path: "/login", name: "login", component: LoginView },
  { 
    path: "/", 
    name: "dashboard", 
    component: DashboardView,
    meta: { requiresAuth: true }
  },
  { 
    path: "/students", 
    name: "students", 
    component: StudentsView,
    meta: { requiresAuth: true }
  },
  { 
    path: "/grades", 
    name: "grades", 
    component: GradesView,
    meta: { requiresAuth: true }
  },
  { 
    path: "/query", 
    name: "query", 
    component: QueryView,
    meta: { requiresAuth: true }
  },
  { 
    path: "/stats", 
    name: "stats", 
    component: StatsView,
    meta: { requiresAuth: true }
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem("token");
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    next("/login");
  } else if (to.path === "/login" && isAuthenticated) {
    next("/");
  } else {
    next();
  }
});

export default router;
