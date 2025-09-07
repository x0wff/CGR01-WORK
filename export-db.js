const mysqldump = require('mysqldump');

// Change these credentials to match your DB
mysqldump({
  connection: {
    host: 'localhost',
    user: 'root',          // or your DB user
    password: 'yourpassword', // your DB password
    database: 'yourdbname',   // the DB name you’re using
  },
  dumpToFile: './backup.sql',
}).then(() => {
  console.log('✅ Database exported to backup.sql');
});
