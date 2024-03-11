window.onload = () => {
  const url = 'http://localhost:4567/tests';
  const patientList = document.getElementById('patient-list');
  const patientDetails = document.getElementById('patient-details');
  const backButton = document.getElementById('back-button');
  const searchInput = document.getElementById('search-input');
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

  const showPatientDetails = (patient) => {
    patientName.textContent = patient.name;
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
    searchInput.style.display = 'none';
    patientDetails.style.display = 'block';
    uploadForm.style.display = 'none'
  };  

  const goBackToList = () => {
    patientDetails.style.display = 'none';
    patientList.style.display = 'block';
    searchInput.style.display = 'block';
    uploadForm.style.display = 'block'
  };

  backButton.addEventListener('click', goBackToList);

  const uploadForm = document.getElementById('upload-form');
  uploadForm.addEventListener('submit', (event) => {
    event.preventDefault();
  
    const fileInput = document.getElementById('csv-file');
    const file = fileInput.files[0];
  
    if (!file) {
      alert('Por favor, selecione um arquivo CSV.');
      return;
    }
  
    const fileName = file.name;
    const fileExtension = fileName.split('.').pop().toLowerCase();
    if (fileExtension !== 'csv') {
      alert('Por favor, selecione um arquivo CSV válido.');
      return;
    }
  
    const formData = new FormData();
    formData.append('csv-file', file);
  
    processingMessage.style.display = 'block';
  
    fetch('http://localhost:4567/import', {
      method: 'POST',
      body: formData
    })
    .then(response => {
      if (response.ok) {
        setTimeout(() => {
          processingMessage.textContent = 'Dados enviados com sucesso';
          processingMessage.style = 'color: green;'
          fetchDataAndUpdate();
        }, 10000);
      } else {
        throw new Error('Falha ao importar o CSV');
      }
    })
    .catch(error => {
      console.error('Erro ao importar o CSV:', error);
      alert('Erro ao importar o CSV');
    });
  });
  
  
  function fetchDataAndUpdate() {
    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error('Erro ao buscar os dados dos pacientes');
        }
        return response.json();
      })
      .then(data => {
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
      })
      .catch(error => {
        console.error('Erro ao carregar dados dos pacientes:', error);
      });
  }
  fetchDataAndUpdate();
};
