// store.js
import { defineStore } from 'pinia';
import axios from 'axios';
import api from '../services/api'

export const useAuthStore = defineStore({
  id: 'auth',
  state: () => ({
    user: null,
    loading: {},
  }),
  actions: {
    login(email, password) {
      api
        .post('/auth', { "email": email, "password": password })
        .then(response => {
          sessionStorage.setItem('token', response.data.token);
          api.defaults.headers.common['Authorization'] = 'Bearer '+response.data.token;
          this.getUserAuth(email);
        })
    },
    getUserAuth(email) {
      this.loading = true;
      api
        .post('/api/getUserAuth', { "email": email })
        .then(response => {
          this.user = response.data.user;
          this.loading = false;
        })
    },
    register(nombre, apellidos, email, password) {
      this.loading = true;
      api
        .post('/register', { "email": email, "password": password, "nombre": nombre, "apellidos": apellidos })
        .then(response => {
          this.user = response.data.user;
          this.loading = false;
        })
    },
    logout() {
      api
        .get('/logout').then(response => {
          this.user = null;
          sessionStorage.removeItem('token');
        })
    },
  },
});
