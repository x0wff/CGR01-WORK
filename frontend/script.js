
async function fetchData() {
  const res = await fetch('https://your-backend-url.onrender.com/');
  const text = await res.text();
  document.getElementById('output').innerText = text;
}
