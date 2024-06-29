const PaysmentService = require('../services/payments.services');

exports.createPayment = async (req, res, next) => {
    try {
        const amount = req.body.amount;

        const payment = PaysmentService.createPayment(amount);
        res.send({
            clientSecret: payment.client_secret,
        });
    } catch (error) {
        next(error);
    }
}