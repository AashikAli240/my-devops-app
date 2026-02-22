const express = require('express');
const client = require('prom-client');
const path = require('path');

const app = express();

client.collectDefaultMetrics();

const httpRequestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
});

app.use((req, res, next) => {
  httpRequestCounter.inc();
  next();
});

app.use(express.static(path.join(__dirname)));

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(8280, () => console.log("App running on port 8280"));
