const express = require('express');
const UserController = require('../controller/user.controller');
const authenticateToken = require("../middleware/authenticateToken");
const error = require('../middleware/error');

const router = express.Router();

router.post('/registration',UserController.register, error);
router.post('/login',UserController.login, error);
router.get('/show-user', authenticateToken, UserController.show_user, error)
router.delete('/delete-user', authenticateToken, UserController.delete_user, error)
router.patch('/edit-user',authenticateToken,UserController.editUser, error);

module.exports = router;