require('dotenv').config();
const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    console.log("authHeader : " + authHeader)
    const token = authHeader && authHeader.split(' ')[1];
    console.log("token : " + token);
    if(!token) return res.status(401).send('Access Token required');

    jwt.verify(token, process.env.SECRETKEY, (err, user) => {
        if(err) return res.status(403).send('Invalid token');
        req.user = user;
        console.log("user: "+ user)
        next();
    })
};

module.exports = authenticateToken;