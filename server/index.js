require('dotenv').config();
const mariadb = require('mariadb');

const app = require('./app');
const port = process.env.PORT;

const pool = mariadb.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    connectionLimit: process.env.DB_CONNECTION_LIMIT
})

app.get('/data', async (req, res) => {
    let conn;
    try {
        conn = await pool.getConnection();
        const rows = await conn.query('SELECT * FROM user_account');
        res.json(rows);
    } catch (err) {
        console.error('Error acquiring connection:', err);
        res.status(500).send(err.toString());
    } finally {
        if (conn) {
            conn.release(); // Use release instead of end for connection pools
        }
    }
});


app.get('/' , (req , res)=> {
    res.send('Hello world!!!');
});


app.listen(port , () => {
    console.log(`Server listening on Port http://${process.env.DB_HOST}:${port}`);
});