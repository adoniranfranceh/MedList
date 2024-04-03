import { MyElements, showPatientDetails } from './domFunctions.js';

export const handleUploadFormSubmit = async (file) => {

  const fileName = file.name.toLowerCase();
  if (!fileName.endsWith('.csv')) {
    alert('Por favor, selecione um arquivo CSV válido.');
    return;
  }
  const formData = new FormData();
  formData.append('csv-file', file);
  try {
    const response = await fetch('/import', {
      method: 'POST',
      body: formData
    });
    if (response.ok) {
      MyElements.processingMessage.style.display = 'block';
      setTimeout(() => {
        MyElements.processingMessage.textContent = 'Dados enviados com sucesso';
        MyElements.processingMessage.style.color = 'green';
        fetchDataAndUpdate();
      }, 7000);
    } else {
      throw new Error('Falha ao importar o CSV');
    }
  } catch (error) {
    console.error('Erro ao importar o CSV:', error);
    alert('Erro ao importar o CSV');
  }
};

export const fetchDataAndUpdate = async () => {
  try {
    const response = await fetch('/tests');
    if (!response.ok) {
      throw new Error('Erro ao buscar os dados dos pacientes');
    }
    const data = await response.json();
    MyElements.patientList.innerHTML = '';
    if (data.patients && Array.isArray(data.patients)) {
      data.patients.forEach(patient => {
        const li = document.createElement('li');
        li.textContent = patient.name;
        li.addEventListener('click', () => {
          showPatientDetails(patient);
        });
        MyElements.patientList.appendChild(li);
      });
    } else if (data.patients && data.patients.message) {
      const message = document.createElement('h3');
      message.textContent = data.patients.message;
      MyElements.patientList.appendChild(message);
    } else {
      console.error('Formato de dados inválido:', data);
    }
  } catch (error) {
    console.error('Erro ao carregar dados dos pacientes:', error);
  }
};

export const handleSearchInputChangeName = async () => {
  const searchTerm = MyElements.searchInputPerName.value.trim();

  if (searchTerm.length == 0 ) { return fetchDataAndUpdate() }
  if (searchTerm.length < 3) { return }
  try {
    const response = await fetch(`/tests?search=${encodeURIComponent(searchTerm)}`);
    const data = await response.json();
    MyElements.patientList.innerHTML = '';
    if (data.patients && data.patients.length > 0) {
      data.patients.forEach(patient => {
        const li = document.createElement('li');
        li.textContent = patient.name;
        li.addEventListener('click', () => {
          showPatientDetails(patient);
        });
        MyElements.patientList.appendChild(li);
      });
    }else{
      const h3 = document.createElement('h3');
      h3.textContent = 'Nenhum resultado para a busca por nome';
      MyElements.patientList.appendChild(h3);
    }
  } catch (error) {
    console.error('Erro ao buscar resultados da pesquisa:', error);
  }
};

export const handleSearchInputChangeToken = async () => {

  const token = MyElements.searchInputPerToken.value.trim();

  const searchUrl = `/tests/${token}`;

  if (token.length == 0 ) { return fetchDataAndUpdate() }
  if (token.length < 3) { return }
  fetchAndDisplayPatients(searchUrl);
};

export const fetchAndDisplayPatients = async (searchUrl) => {
  try {
    const response = await fetch(searchUrl);
    const data = await response.json();
    MyElements.patientList.innerHTML = '';
    if(data.patients && data.patients.length > 0){
      data.patients.forEach(patient => {
        const li = document.createElement('li');
        li.textContent = patient.name;
        li.addEventListener('click', () => {
          showPatientDetails(patient);
        });
        MyElements.patientList.appendChild(li);
      });
    }else{
      const h3 = document.createElement('h3');
      h3.textContent = 'Nenhum resultado para a busca por token';
      MyElements.patientList.appendChild(h3);
    }
  } catch (error) {
    console.error('Erro ao buscar resultados da pesquisa:', error);
  }
};

export const handleSearchLinkToken = (event) => {
  event.preventDefault();

  MyElements.searchInputPerName.style.display = 'none';
  MyElements.searchInputPerToken.style.display = 'block';
  MyElements.searchLinkToken.style.display = 'none';
  MyElements.searchLinkName.style.display = 'block';
  MyElements.searchInputPerToken.focus();
};

export const handleSearchLinkName = (event) => {
  event.preventDefault();

  MyElements.searchInputPerToken.style.display = 'none';
  MyElements.searchInputPerName.style.display = 'block';
  MyElements.searchLinkToken.style.display = 'block';
  MyElements.searchLinkName.style.display = 'none';
  MyElements.searchInputPerName.focus();
};