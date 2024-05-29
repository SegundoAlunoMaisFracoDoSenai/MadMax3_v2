const express = require('express');
const path = require('path');
const mysql = require('mysql2');

const app = express();

app.set('views', path.join(__dirname, './MVC/views/public'));
app.use(express.static('mvc/views/public'))

app.set('view engine', 'ejs');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'botania'
});

db.connect(err => {
  if (err) {
    console.error('Erro ao conectar ao banco de dados:', err);
    return;
  }
  console.log('Conectado ao banco de dados MySQL');
});

app.get('/', (req, res) => {
  const query = 'SELECT Especime_Planta AS especie, Tipo_Planta AS nome, Foto1_Planta AS imagem, Desc_planta as descricao FROM plantas';
  db.query(query, (err, results) => {
    if (err) throw err;
    results.forEach(result => {
      result.imagem = `data:image/jpeg;base64,${result.imagem.toString('base64')}`;
    });
    res.render('index', { plantas: results });
  });
});

const port = process.env.PORT || 3008;
app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
