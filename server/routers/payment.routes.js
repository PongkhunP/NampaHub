const express = require('express');
const router = express.Router();
const PaymentsController = require('../controller/payments.controller');
const error = require('../middleware/error');
const authenticateToken = require('../middleware/authenticateToken');


router.post('/create-payment-intent', PaymentsController.createPayment, error);
router.post('/create-checkout-session' , PaymentsController.createPayout, error);
router.post('/create-donate' , authenticateToken, PaymentsController.createDonate, error);
router.post('/create-donate-attend', authenticateToken , PaymentsController.createDonateAttendFee, error);
router.get('/create-onboard-link',  PaymentsController.createOnboardingLink, error);
router.post('/create-attend', authenticateToken, PaymentsController.createAttend, error);
router.get('/return-success-attend' , PaymentsController.handleSuccessAttend, error);
router.get('/return-success-donate', PaymentsController.handleSuccessDonate, error);
router.get('/return-success-donate-attend', PaymentsController.handleSuccessDonateAttend,error)
router.get('/return-cancel' , PaymentsController.handleCancel, error);


module.exports = router;