document.addEventListener('DOMContentLoaded', () => {
  const patientList = document.getElementById('patient-list');
  const patientDetails = document.getElementById('patient-details');
  const backButton = document.getElementById('back-button');
  const searchInputPerName = document.getElementById('search-input-per-name');
  const searchInputPerToken = document.getElementById('search-input-per-token');
  const searchLinkToken = document.getElementById('search-link-token');
  const searchLinkName = document.getElementById('search-link-name');
  const tokenResult = document.getElementById('token-result')
  const patientName = document.getElementById('patient-name');
  const patientCpf = document.getElementById('patient-cpf');
  const patientEmail = document.getElementById('patient-email');
  const patientBirthday = document.getElementById('patient-birthday');
  const patientAddress = document.getElementById('patient-address');
  const testsList = document.getElementById('tests-list');
  const doctorName = document.getElementById('doctor-name');
  const doctorCrm = document.getElementById('doctor-crm');
  const doctorCrmState = document.getElementById('doctor-crm-state');
  const doctorDetails = document.getElementById('doctor-details');
  const processingMessage = document.getElementById('processing-message');
  const uploadForm = document.getElementById('upload-form');
  const uploadContainer = document.getElementById('upload-container')
  const btnShowUploadForm = document.getElementById('show-upload-form')

  btnShowUploadForm.addEventListener('click', function() {
    uploadContainer.style.display = 'block';
    btnShowUploadForm.style.display = 'none'
  });

  document.getElementById('close-upload-form').addEventListener('click', function() {
    uploadContainer.style.display = 'none';
    btnShowUploadForm.style.display = 'block'
  });

  const showPatientDetails = (patient) => {
    console.log(patient)
    patientName.textContent = patient.name;
    tokenResult.textContent = patient.result_token;
    patientCpf.textContent = patient.cpf;
    patientEmail.textContent = patient.email;
    patientBirthday.textContent = patient.birthday;
    patientAddress.textContent = `${patient.address}, ${patient.city} - ${patient.state}`;

    doctorName.textContent = patient.doctor.name;
    doctorCrm.textContent = patient.doctor.crm;
    doctorCrmState.textContent = patient.doctor.crm_state;
    doctorDetails.style.display = 'block';

    testsList.innerHTML = '';
    patient.tests.forEach(test => {
      const li = document.createElement('li');
      li.textContent = `${test.type}: ${test.result} (${test.limits})`;
      testsList.appendChild(li);
    });

    patientList.style.display = 'none';
    searchInputPerName.style.display = 'none';
    patientDetails.style.display = 'block';
    uploadForm.style.display = 'none';
    uploadContainer.style.display = 'none';
    searchInputPerName.style.display = 'none';
    searchInputPerToken.style.display = 'none';
    searchLinkName.style.display = 'none';
    searchLinkToken.style.display = 'none';
    btnShowUploadForm.style.display = 'none';
  };

  const goBackToList = () => {
    patientDetails.style.display = 'none';
    patientList.style.display = 'block';
    searchInputPerName.style.display = 'block';
    uploadForm.style.display = 'block';
    searchInputPerName.style.display = 'block';
    searchLinkToken.style.display = 'block';
    btnShowUploadForm.style.display = 'block';
  };

  searchLinkToken.addEventListener('click', (event) => {
    event.preventDefault();

    searchInputPerName.style.display = 'none';
    searchInputPerToken.style.display = 'block';
    searchLinkToken.style.display = 'none';
    searchLinkName.style.display = 'block';
    searchInputPerToken.focus();
  });

  searchLinkName.addEventListener('click', (event) => {
    event.preventDefault();

    searchInputPerToken.style.display = 'none';
    searchInputPerName.style.display = 'block';
    searchLinkToken.style.display = 'block';
    searchLinkName.style.display = 'none';
    searchInputPerName.focus();
  });

  const handleUploadFormSubmit = async (event) => {
    event.preventDefault();
    const file = uploadForm.querySelector('#csv-file').files[0];

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
        processingMessage.style.display = 'block';
        setTimeout(() => {
          processingMessage.textContent = 'Dados enviados com sucesso';
          processingMessage.style.color = 'green';
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

  const fetchDataAndUpdate = async () => {
    try {
      const response = await fetch('/tests');
      if (!response.ok) {
        throw new Error('Erro ao buscar os dados dos pacientes');
      }
      const data = await response.json();
      patientList.innerHTML = '';
      if (data.patients && Array.isArray(data.patients)) {
        data.patients.forEach(patient => {
          const li = document.createElement('li');
          li.textContent = patient.name;
          li.addEventListener('click', () => {
            showPatientDetails(patient);
          });
          patientList.appendChild(li);
        });
      } else if (data.patients && data.patients.message) {
        const message = document.createElement('h3');
        message.textContent = data.patients.message;
        patientList.appendChild(message);
      } else {
        console.error('Formato de dados inválido:', data);
      }
    } catch (error) {
      console.error('Erro ao carregar dados dos pacientes:', error);
    }
  };

  const handleSearchInputChange = async () => {
    const searchTerm = searchInputPerName.value.trim();
    try {
      const response = await fetch(`/tests?search=${encodeURIComponent(searchTerm)}`);
      const data = await response.json();
      patientList.innerHTML = '';
      if (data.patients && data.patients.length > 0) {
        data.patients.forEach(patient => {
          const li = document.createElement('li');
          li.textContent = patient.name;
          li.addEventListener('click', () => {
            showPatientDetails(patient);
          });
          patientList.appendChild(li);
        });
      }else{
        const h3 = document.createElement('h3');
        h3.textContent = 'Nenhum resultado para a busca por nome';
        patientList.appendChild(h3);
      }
    } catch (error) {
      console.error('Erro ao buscar resultados da pesquisa:', error);
    }
  };

  searchInputPerToken.addEventListener('input', (event) => {
    event.preventDefault();

    const token = searchInputPerToken.value.trim();

    if (token === '') {
      alert('Por favor, insira um token válido.');
      return;
    }

    const searchUrl = `/tests/${token}`;

    fetchAndDisplayPatients(searchUrl);
  });

  const fetchAndDisplayPatients = async (searchUrl) => {
    try {
      const response = await fetch(searchUrl);
      const data = await response.json();
      patientList.innerHTML = '';
      if(data.patients && data.patients.length > 0){
        data.patients.forEach(patient => {
          const li = document.createElement('li');
          li.textContent = patient.name;
          li.addEventListener('click', () => {
            showPatientDetails(patient);
          });
          patientList.appendChild(li);
        });
      }else{
        const h3 = document.createElement('h3');
        h3.textContent = 'Nenhum resultado para a busca por token';
        patientList.appendChild(h3);
      }
    } catch (error) {
      console.error('Erro ao buscar resultados da pesquisa:', error);
    }
  };

  backButton.addEventListener('click', goBackToList);
  uploadForm.addEventListener('submit', handleUploadFormSubmit);
  searchInputPerName.addEventListener('input', handleSearchInputChange);

  fetchDataAndUpdate();
});
