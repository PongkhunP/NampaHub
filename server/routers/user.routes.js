const express = require('express');
const UserController = require('../controller/user.controller');

const router = express.Router();

router.post('/registeration',UserController.register);
router.post('/login',UserController.login);

module.exports = router;