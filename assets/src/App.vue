<template>
  <v-app>
    <v-app-bar :elevation="2" rounded>
      <v-spacer></v-spacer>
      <RouterLink to="/">Home</RouterLink>
      <v-spacer></v-spacer>
      <RouterLink to="/login">Login</RouterLink>
      <v-spacer></v-spacer>
      <template v-if="authStore.user" v-slot:append>
        <!-- Opciones para usuarios autenticados -->
        <v-btn to="/profile">Profile</v-btn>
        <v-btn @click="authStore.logout()">Logout</v-btn>
      </template>
    </v-app-bar>
    <v-main>
      <RouterView />
    </v-main>
  </v-app>
</template>
<script>
import { computed } from 'vue';
import { useAuthStore } from './stores/auth';
import { RouterLink, RouterView } from 'vue-router'
export default {
  setup() {
    const authStore = useAuthStore();

    return {
      authStore,
    };
  },
  
};
</script>
