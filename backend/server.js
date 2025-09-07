
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3001;

// Enable CORS for frontend communication
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

app.get('/', (req, res) => {
  res.json({ message: 'CGR01-WORK backend is running successfully!' });
});

app.listen(PORT, 'localhost', () => {
  console.log(`Backend server running on localhost:${PORT}`);
});
