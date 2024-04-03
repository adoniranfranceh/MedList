export const MyElements = {};

export const initializeElements = (elements) => {
  elements.forEach((element) => {
    MyElements[element] = document.getElementById(element.split(/(?=[A-Z])/).join('-').toLowerCase());
  });
};

export const showUploadForm = () => {
  MyElements.showUploadForm.style.display = 'none';
  MyElements.uploadContainer.style.display = 'block';
};

export const closeUploadForm = () => {
  MyElements.showUploadForm.style.display = 'block';
  MyElements.uploadContainer.style.display = 'none';
};

export const showPatientDetails = (patient) => {
  MyElements.patientName.textContent = patient.name;
  MyElements.tokenResult.textContent = patient.result_token;
  MyElements.patientCpf.textContent = patient.cpf;
  MyElements.patientEmail.textContent = patient.email;
  MyElements.patientBirthday.textContent = patient.birthday;
  MyElements.patientAddress.textContent = `${patient.address}, ${patient.city} - ${patient.state}`;

  MyElements.doctorName.textContent = patient.doctor.name;
  MyElements.doctorCrm.textContent = patient.doctor.crm;
  MyElements.doctorCrmState.textContent = patient.doctor.crm_state;
  MyElements.doctorDetails.style.display = 'block';

  MyElements.testsList.innerHTML = '';
  patient.tests.forEach(test => {
    const li = document.createElement('li');
    li.textContent = `${test.type}: ${test.result} (${test.limits})`;
    MyElements.testsList.appendChild(li);
  });

  MyElements.patientList.style.display = 'none';
  MyElements.searchInputPerName.style.display = 'none';
  MyElements.patientDetails.style.display = 'block';
  MyElements.uploadForm.style.display = 'none';
  MyElements.uploadContainer.style.display = 'none';
  MyElements.searchInputPerName.style.display = 'none';
  MyElements.searchInputPerToken.style.display = 'none';
  MyElements.searchLinkName.style.display = 'none';
  MyElements.searchLinkToken.style.display = 'none';
  MyElements.showUploadForm.style.display = 'none';
};

export const goBackToList = () => {
  MyElements.patientDetails.style.display = 'none';
  MyElements.patientList.style.display = 'block';
  MyElements.searchInputPerName.style.display = 'block';
  MyElements.uploadForm.style.display = 'block';
  MyElements.searchInputPerName.style.display = 'block';
  MyElements.searchLinkToken.style.display = 'block';
  MyElements.showUploadForm.style.display = 'block';
};
