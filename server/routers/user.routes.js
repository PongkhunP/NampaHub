const express = require('express');
const UserController = require('../controller/user.controller');
const authenticateToken = require("../middleware/authenticateToken");

const router = express.Router();

router.post('/registration',UserController.register);
router.post('/login',UserController.login);
router.get('/show-user', authenticateToken, UserController.show_user)
router.delete('/delete-user', authenticateToken, UserController.delete_user)
router.patch('/edit-user',authenticateToken,UserController.editUser);

module.exports = router;