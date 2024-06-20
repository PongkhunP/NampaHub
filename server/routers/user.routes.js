const express = require('express');
const UserController = require('../controller/user.controller');
const authenticateToken = require("../middleware/authenticateToken");

const router = express.Router();

router.post('/registration',UserController.register);
router.post('/login',UserController.login);
router.get('/show-user', authenticateToken, UserController.show_user)

module.exports = router;