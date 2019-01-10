const express = require('express');
const app = express();

// welcome in various languages
const welcomes = ['Willkommen', 'Welcome', 'Bienvenue', 'Fáilte', 'स्वागत'];

// route that returns a welcome in a random language
app.get('/', (request, response) => {
  const index = Math.floor((Math.random() * welcomes.length));
  response.send(welcomes[index]);
});

// start express
const port = process.env.PORT || 3000
app.listen(port, () => {
    console.log(`API running on http://localhost:${port}/welcome`);
});
