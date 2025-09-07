
async function fetchData() {
  try {
    const res = await fetch('https://d185713b-7753-4adc-bc24-dfd1a8b8197c-00-z264jrnwr1ph.sisko.replit.dev:3001/');
    const data = await res.json();
    document.getElementById('output').innerText = JSON.stringify(data, null, 2);
  } catch (error) {
    document.getElementById('output').innerText = 'Error fetching data: ' + error.message;
  }
}
