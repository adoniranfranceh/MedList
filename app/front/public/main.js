import { initializeElements, MyElements, showUploadForm, closeUploadForm, goBackToList } from './domFunctions.js';
import { fetchDataAndUpdate, handleSearchInputChangeName , handleSearchInputChangeToken, handleUploadFormSubmit, handleSearchLinkToken, handleSearchLinkName } from './dataFunctions.js';

document.addEventListener('DOMContentLoaded', () => {
  const elements = [
    'patientList', 'patientDetails', 'backButton',
    'searchInputPerName', 'searchInputPerToken', 'searchLinkToken', 
    'searchLinkName', 'tokenResult', 'patientName', 'patientCpf', 
    'patientEmail', 'patientBirthday', 'patientAddress', 'testsList', 
    'doctorName', 'doctorCrm', 'doctorCrmState', 'doctorDetails', 
    'processingMessage', 'uploadForm', 'uploadContainer', 
    'showUploadForm', 'closeUploadForm'
  ];

  initializeElements(elements);

  MyElements.showUploadForm.addEventListener('click', showUploadForm);
  MyElements.closeUploadForm.addEventListener('click', closeUploadForm);
  MyElements.backButton.addEventListener('click', goBackToList);
  MyElements.uploadForm.addEventListener('submit', async (event) => {
    event.preventDefault();
    const file = MyElements.uploadForm.querySelector('#csv-file').files[0];
    await handleUploadFormSubmit(file);
  });
  MyElements.searchInputPerName.addEventListener('input', handleSearchInputChangeName);
  MyElements.searchInputPerToken.addEventListener('input', handleSearchInputChangeToken);
  MyElements.searchLinkToken.addEventListener('click', handleSearchLinkToken)
  MyElements.searchLinkName.addEventListener('click', handleSearchLinkName)

  fetchDataAndUpdate();
});
