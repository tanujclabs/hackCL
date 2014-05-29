var mysql = require('mysql');
connection = mysql.createConnection({host: 'localhost', user: 'root', password: 'nodejs', database: 'empspot'});
connection.connect();