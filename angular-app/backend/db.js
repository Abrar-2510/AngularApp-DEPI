const mysql = require('mysql2');

const pool = mysql.createPool({
  host: 'mysql', // MySQL container service name
  user: 'root',
  password: 'rootpassword',
  database: 'angular',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Retry mechanism
const connectWithRetry = () => {
  pool.getConnection((err, connection) => {
    if (err) {
      console.error('Error connecting to the database:', err.message);
      setTimeout(connectWithRetry, 5000);  // Retry after 5 seconds
    } else {
      console.log('Connected to the database');
      connection.release();
    }
  });
};

connectWithRetry();

module.exports = pool;

