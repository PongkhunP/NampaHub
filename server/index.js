require('dotenv').config();

const app = require('./app');
const port = process.env.PORT;

app.get('/' , (req , res)=> {
    res.send('Hello world!!!');
});

app.listen(port , () => {
    console.log(`Server listening on Port http://${process.env.BHOST}:${port}`);
});