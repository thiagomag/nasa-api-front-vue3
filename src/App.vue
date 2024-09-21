<template>
  <div id="app">
    <header class="app-header">
      <img src="./assets/nasa_logo.png" alt="NASA Logo" class="logo" />
      <h1 class="title">Encontre NEOs (Near Earth Objects) do banco de dados da NASA</h1>
    </header>

    <NeosScreen />
  </div>
</template>

<script>
import NeosScreen from './components/NeosScreen.vue';

export default {
  name: 'App',
  components: {
    NeosScreen
  }
};
</script>

<style scoped>
.app-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20px;
}

.logo {
  height: 160px;
  margin-bottom: 10px;
  background-color: transparent;
}

.title {
  font-size: 48px;
  text-align: center;
  color: #fff;
}
</style>
