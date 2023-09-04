import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:9899', // Reemplaza esto con la URL de tu API
});

export default api;
