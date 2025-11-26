const mysql = require("mysql2");

const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "sistema_facturacion",
});

connection.connect((error) => {
  if (error) throw error;
  console.log("Conexión exitosa a la base de datos.");
});

module.exports = connection;
