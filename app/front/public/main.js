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
  const doctorName = document.getElementById('doctor-name')
  const doctorCrm = document.getElementById('doctor-crm')
  const doctorCrmState = document.getElementById('doctor-crm-state')
  doctorDetails = document.getElementById('doctor-details')

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
  };  

  const goBackToList = () => {
    patientDetails.style.display = 'none';
    patientList.style.display = 'block';
    searchInput.style.display = 'block';
  };

  backButton.addEventListener('click', goBackToList);

  searchInput.addEventListener('input', () => {
    const searchTerm = searchInput.value.trim();

    fetch(`${url}?search=${encodeURIComponent(searchTerm)}`)
      .then(response => response.json())
      .then(data => {
        patientList.innerHTML = '';
        data.patients.forEach(patient => {
          const li = document.createElement('li');
          li.textContent = patient.name;
          li.addEventListener('click', () => {
            showPatientDetails(patient);
          });
          patientList.appendChild(li);
        });
      })
      .catch(error => {
        console.error('Erro ao buscar resultados da pesquisa:', error);
      });
  });

  fetch(url)
    .then(response => response.json())
    .then(data => {
      data.patients.forEach(patient => {
        const li = document.createElement('li');
        li.textContent = patient.name;
        li.addEventListener('click', () => {
          showPatientDetails(patient);
        });
        patientList.appendChild(li);
      });
    })
    .catch(error => {
      console.error('Erro ao carregar dados:', error);
    });
};
