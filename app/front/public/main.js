const fragment = new DocumentFragment();
const url = 'http://localhost:4567/tests';

fetch(url)
  .then((response) => response.json())
  .then((data) => {
    data.patients.forEach((patient) => {
      const li = document.createElement('li');
      li.textContent = `${patient.name}`;
      fragment.appendChild(li);
    });
  })
  .then(() => {
    document.querySelector('ul').appendChild(fragment);
  })
  .catch((error) => {
    console.log(error);
  });
