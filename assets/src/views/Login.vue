<!-- Login.vue -->
<template>
  <v-container>
    <v-row justify="center">
        <v-card>
          <v-card-title class="headline">
            Iniciar Sesión
          </v-card-title>
          <v-card-text>
            <v-form @submit.prevent="login">
              <v-text-field v-model="email" label="Correo Electrónico" outlined required></v-text-field>
              <v-text-field v-model="password" label="Contraseña" type="password" outlined required></v-text-field>
              <v-btn color="primary" class="mr-4" type="submit">
                Iniciar Sesión
              </v-btn>
              <v-btn color="primary" class="mr-4" to="register">
                Registarse
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>

    </v-row>
  </v-container>
</template>

<script>
import { computed } from 'vue';
import { useAuthStore } from '../stores/auth';

export default {
  setup() {
    const authStore = useAuthStore();

    const login = (email, password) => {
      authStore.login(email, password);
    };

    return {
      login,
    };
  },
  data() {
    return {
      email: '',
      password: '',
    };
  },
  methods: {
    login() {
      this.login(this.email, this.password);
    }
  },
};
</script>
