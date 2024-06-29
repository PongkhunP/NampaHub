require('dotenv').config();
const Stripe = require('stripe')
const bodyParser = require('body-parser')

const stripe = Stripe(process.env.TESTKEY);

class PaymentsService {
    static async createPayment(amount)
    {
        try {
            const paymentIntent = await stripe.paymentIntents.create({
                amount,
                currency: 'usd',
                payment_method_types:['card'],
            });

            return paymentIntent;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = PaymentsService;