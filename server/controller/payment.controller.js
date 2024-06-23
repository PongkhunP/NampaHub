const PaymentService = require('../services/payment.services');

exports.handleCreateOrder = async (req ,res ,next) => {
    try {
        const order = await PaymentService.createDonate();
        const approvalUrl = order.links.find(link => link.rel === 'approve').href;
        console.log("handle redirect payment page");
        res.json({status: true, id: order.id , approvalUrl: approvalUrl});
    } catch (error) {
        next(error);
    }
}

exports.handleCreateAttend = async (req, res, next) => {
    try {
        const totalAmount = req.body.amount;
        const percentage = 15;
        const organizerAccount = 'sb-ja47fi31312304@business.example.com';

        console.log("totalAmount : " + totalAmount);
        
        const order = await PaymentService.createAttend(organizerAccount, totalAmount, percentage);

        const approvalUrl = order.links.find(link => link.rel === 'approve').href;
        res.json({status: true, id: order.id , approvalUrl: approvalUrl});

        console.log("approvalUrl : " + approvalUrl);
    } catch (error) {
        next(error);
    }
}

exports.handleCapture = async (req ,res ,next) => {
    try {
        const orderId = req.query.order_id;
        console.log("Order Id : " + orderId);
        console.log("This path was being called");
        // if (!orderId) {
        //     throw new Error('Order ID is missing');
        // }
        const capture = await PaymentService.captureOrder(orderId);
        console.log('Payment captured:', JSON.stringify(capture.result, null, 2));
        res.json({status: true, success : capture.result});
    } catch (error) {
        next(error);
    }
}

exports.successPayment = async (req, res, next) => {
    const { token, PayerID } = req.query;
    if (!token || !PayerID) {
        return res.status(400).send('Missing token or PayerID');
    }

    const request = await PaymentService.successHandle(token);
    try {
        const capture = await PaymentService.executeHandle(request);
        res.send('Payment successful!');
    } catch (error) {
        res.status(500).send('Error capturing payment');
    }
}

exports.cancelPayment = async (req, res, next) => {
    res.send('Payment cancelled');
}