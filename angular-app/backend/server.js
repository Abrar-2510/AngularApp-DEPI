const express = require('express');
const cors = require('cors');
const db = require('./db'); // Import the connection pool
const client = require('prom-client'); // Prometheus client

const app = express();
app.use(cors());

// Create Prometheus metrics registry
const register = new client.Registry();

// Define default and custom metrics
client.collectDefaultMetrics({ register });

// Custom metrics
const httpRequestDurationMicroseconds = new client.Histogram({
  name: 'http_request_duration_milliseconds',
  help: 'Duration of HTTP requests in ms',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [50, 100, 200, 300, 400, 500, 1000]
});
register.registerMetric(httpRequestDurationMicroseconds);

// Middleware to measure request durations
app.use((req, res, next) => {
  const end = httpRequestDurationMicroseconds.startTimer();
  res.on('finish', () => {
    end({ method: req.method, route: req.route ? req.route.path : req.path, status_code: res.statusCode });
  });
  next();
});

// API route
app.get('/', (req, res) => {
  db.getConnection((err, connection) => {
    if (err) {
      console.error('Error getting a connection from the pool:', err.message);
      res.status(500).json({
        message: 'Node.js backend is running',
        dbStatus: 'Database connection failed',
        error: err.message
      });
      return;
    }

    connection.ping((pingErr) => {
      connection.release();
      if (pingErr) {
        console.error('Error pinging the database:', pingErr.message);
        res.status(500).json({
          message: 'Node.js backend is running',
          dbStatus: 'Database connection failed',
          error: pingErr.message
        });
      } else {
        console.log('Database connection successful');
        res.status(200).json({
          message: 'Node.js backend is running',
          dbStatus: 'Database connection successful'
        });
      }
    });
  });
});

// Expose Prometheus metrics at `/metrics`
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

// Start server
app.listen(3200, () => {
  console.log('Server is running on http://localhost:3200');
  console.log('Prometheus metrics available at http://localhost:3200/metrics');
});
