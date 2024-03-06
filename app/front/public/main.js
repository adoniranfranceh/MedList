window.onload = () => {
  const url = 'http://localhost:4567/tests';
  const patientList = document.getElementById('patient-list');
  const patientDetails = document.getElementById('patient-details');
  const backButton = document.getElementById('back-button');
  const patientName = document.getElementById('patient-name');
  const patientCpf = document.getElementById('patient-cpf');
  const patientEmail = document.getElementById('patient-email');
  const patientBirthday = document.getElementById('patient-birthday');
  const patientAddress = document.getElementById('patient-address');
  const patientMedicalCrm = document.getElementById('patient-medical-crm');

  const showPatientDetails = (patient) => {
    patientName.textContent = patient.name;
    patientCpf.textContent = patient.cpf;
    patientEmail.textContent = patient.email;
    patientBirthday.textContent = patient.birthday;
    patientAddress.textContent = `${patient.address}, ${patient.city} - ${patient.state}`;
    patientMedicalCrm.textContent = patient.medical_crm;

    patientList.style.display = 'none';
    patientDetails.style.display = 'block';
  };

  const goBackToList = () => {
    patientDetails.style.display = 'none';
    patientList.style.display = 'block';
  };

  backButton.addEventListener('click', goBackToList);

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
