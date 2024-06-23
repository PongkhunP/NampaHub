const express = require('express');
const router = express.Router();
const PaymentController = require('../controller/payment.controller');
const error = require('../middleware/error');
const authenticateToken = require('../middleware/authenticateToken');

router.post('/order', authenticateToken , PaymentController.handleCreateOrder , error);
// router.post('/capture', authenticateToken , PaymentController.handleCapture , error);
router.post('/attend-paid', authenticateToken , PaymentController.handleCreateAttend, error);
router.get('/return', PaymentController.handleCapture, error);
router.get('/cancel', PaymentController.cancelPayment, error);

module.exports = router;