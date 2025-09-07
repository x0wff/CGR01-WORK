const express = require('express');
const path = require('path');
const app = express();
const PORT = 5000;

// Serve static files from current directory
app.use(express.static(__dirname));

// Serve index.html for the root route
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Frontend server running on 0.0.0.0:${PORT}`);
});