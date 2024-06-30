const express = require('express');
const UserController = require('../controller/user.controller');
const authenticateToken = require("../middleware/authenticateToken");
const error = require('../middleware/error');
const upload = require('../configuration/upload');

const router = express.Router();

router.post('/registration', upload.single('user_image') ,UserController.register, error);
router.get('/validate',UserController.validateEmail, error);
router.post('/login',UserController.login, error);

router.get('/show-user', authenticateToken, UserController.show_user, error)
router.delete('/delete-user', authenticateToken, UserController.delete_user, error)
router.patch('/edit-user',authenticateToken, upload.single('user_image') ,UserController.editUser, error);
router.patch('/updateuser-rating', authenticateToken , UserController.updateUserRating, error);
router.get('/validate-delete', authenticateToken , UserController.validateDeletion, error);

router.post('/create-payment', authenticateToken, UserController.createUserPayment, error);
router.get('/user-payment', authenticateToken, UserController.getUserPayment, error);

module.exports = router;