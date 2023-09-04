<template>
    <v-container>
        <v-card>
            <v-card-title>Registro de Usuario</v-card-title>
            <v-card-text>
                <v-form @submit.prevent="registrarUsuario">
                    <v-text-field v-model="usuario.nombre" label="Nombre"></v-text-field>
                    <v-text-field v-model="usuario.apellidos" label="Apellidos"></v-text-field>
                    <v-text-field v-model="usuario.email" label="Email"></v-text-field>
                    <v-text-field v-model="usuario.password" label="Contraseña" type="password"></v-text-field>
                    <v-btn type="submit" color="primary">Registrar</v-btn>
                </v-form>
            </v-card-text>
        </v-card>
    </v-container>
</template>
  
<script>
import { useAuthStore } from '../stores/auth';
export default {
    setup() {
        const authStore = useAuthStore();

        const register = (usuario) => {
            authStore.register(usuario.nombre, usuario.apellidos, usuario.email, usuario.password);
        };
        return {
            register
        };
    },
    data() {
        return {
            usuario: {
                nombre: '',
                apellidos: '',
                email: '',
                password: '',
            },
        };
    },
    methods: {
        registrarUsuario() {
            // Aquí puedes enviar los datos del usuario al servidor o realizar la lógica de registro
            console.log('Registrando usuario', this.usuario);

            this.register(this.usuario);
            // Limpia los campos después de registrar
            this.usuario = {
                nombre: '',
                apellidos: '',
                email: '',
                password: '',
            };
        }
    }
}
</script>