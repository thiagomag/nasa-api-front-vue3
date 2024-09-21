<template>
    <div class="neos-container">
      <!-- Seleção de data de início -->
      <div class="form-group">
        <label for="start-date">Data de início</label>
        <input id="start-date" type="date" v-model="selectedStartDate" />
      </div>
  
      <!-- Seleção de data final -->
      <div class="form-group">
        <label for="end-date">Data final</label>
        <input id="end-date" type="date" v-model="selectedEndDate" />
      </div>
  
      <!-- Botão para buscar os NEOs -->
      <button class="fetch-btn" @click="fetchNeos">Recupere NEOs</button>
  
      <!-- Exibição dos NEOs -->
      <div v-if="neos.length" class="neos-list">
        <div v-for="(neoByDate, index) in neos" :key="index" class="neo-date-section">
          <!-- Divisão por Data usando "accordion" -->
          <div class="date-header" @click="toggleDate(index)">
            <h3>Data: {{ neoByDate.date }} <span v-if="!neoByDate.open">+</span><span v-if="neoByDate.open">-</span></h3>
          </div>
  
          <!-- Exibir tabela de NEOs ao expandir -->
          <div v-if="neoByDate.open" class="neos-table-container">
            <table class="neos-table">
              <thead>
                <tr>
                  <th>Nome</th>
                  <th>ID</th>
                  <th>Magnitude</th>
                  <th>É Perigoso?</th>
                  <th>Diâmetro (km)</th>
                  <th>Data de Aproximação</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(neo, idx) in neoByDate.neos" :key="idx">
                  <td>{{ neo.name }}</td>
                  <td>{{ neo.id }}</td>
                  <td>{{ neo.absolute_magnitude_h }}</td>
                  <td>{{ neo.is_potentially_hazardous_asteroid ? 'Sim' : 'Não' }}</td>
                  <td>
                    {{ neo.estimated_diameter.kilometers.estimated_diameter_min }} -
                    {{ neo.estimated_diameter.kilometers.estimated_diameter_max }}
                  </td>
                  <td>{{ neo.close_approach_data[0].close_approach_date_full }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        selectedStartDate: null,
        selectedEndDate: null,
        neos: []
      };
    },
    methods: {
      async fetchNeos() {
        if (!this.selectedStartDate || !this.selectedEndDate) {
          alert('Por favor, selecione as datas de início e fim.');
          return;
        }
  
        try {
          const response = await axios.post('http://localhost:8080/api/neos', {
            start_date: this.selectedStartDate,
            end_date: this.selectedEndDate
          });
  
          if (response.status === 200) {
            this.neos = response.data.neosByDateList.map(neoByDate => ({
              ...neoByDate,
              open: false // Adiciona a propriedade 'open' para controlar a expansão
            }));
          } else {
            throw new Error('Falha ao carregar NEOs');
          }
        } catch (error) {
          console.error(error);
          alert('Ocorreu um erro ao buscar os NEOs.');
        }
      },
      toggleDate(index) {
        this.neos[index].open = !this.neos[index].open;
      }
    }
  };
  </script>
  
  <style scoped>
  /* Container da página */
  .neos-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
  }
  
  /* Estilo dos inputs e form */
  .form-group {
    margin-bottom: 20px;
  }
  
  label {
    font-weight: bold;
    margin-bottom: 5px;
    display: block;
  }
  
  input[type="date"] {
    padding: 8px;
    width: 100%;
    max-width: 300px;
    border: 1px solid #ccc;
    border-radius: 4px;
    margin-bottom: 10px;
  }
  
  .fetch-btn {
    background-color: #007bff;
    color: white;
    border: none;
    padding: 10px 20px;
    font-size: 16px;
    cursor: pointer;
    border-radius: 4px;
    transition: background-color 0.3s;
  }
  
  .fetch-btn:hover {
    background-color: #0056b3;
  }
  
  /* Estilo da seção por data */
  .neo-date-section {
    margin-top: 20px;
    border: 1px solid #333;
    border-radius: 5px;
    padding: 10px;
  }
  
  .date-header {
    cursor: pointer;
    background-color: #333;
    padding: 10px;
    border-bottom: 1px solid #ddd;
  }
  
  .date-header:hover {
    background-color: #333;
  }
  
  /* Estilo das tabelas */
  .neos-table-container {
    margin-top: 10px;
  }
  
  .neos-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
  }
  
  .neos-table th, .neos-table td {
    border: 1px solid #333;
    padding: 10px;
    text-align: left;
  }
  
  .neos-table th {
    background-color: #333;
    font-weight: bold;
  }
  
  .neos-table td {
    background-color: #333;
  }
  
  h3 {
    margin: 0;
  }
  </style>
  