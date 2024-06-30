require("dotenv").config();
const Stripe = require("stripe");
const bodyParser = require("body-parser");
const { application } = require("express");

const stripe = Stripe(process.env.TESTKEY);

class PaymentsService {
  static async createPayment(amount) {
    try {
      const paymentIntent = await stripe.paymentIntents.create({
        amount,
        currency: "usd",
        payment_method_types: ["card"],
      });

      return paymentIntent;
    } catch (error) {
      throw error;
    }
  }

  static async createPayout(amount) {
    try {
      let actual_amount = 0;
      if (amount) {
        actual_amount = Math.round(amount * 100);
      } else {
        throw new Error("Undefined amount");
      }

      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        line_items: [
          {
            price_data: {
              currency: "thb",
              product_data: {
                name: "Donate",
              },
              unit_amount: actual_amount,
            },
            quantity: 1,
          },
        ],
        mode: "payment",
        success_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-success`,
        cancel_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-cancel`,
      });
      return session;
    } catch (error) {
      throw error;
    }
  }

  static async createOnboard() {
    try {
      const account = await stripe.accounts.create({
        type: "standard",
      });

      const accountLink = await stripe.accountLinks.create({
        account: account.id,
        refresh_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-cancel`,
        return_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-cancel`,
        type: "account_onboarding",
      });

      return { accountLink: accountLink.url, accountId: account.id };
    } catch (error) {
      throw error;
    }
  }

  static async createSplitAttend(amount, connectedAccountId, activity_id , user_id) {
    try {
      if (amount < 1000) {
        throw new Error('Amount must be at least ฿10.00');
      }

      const platformFee = Math.round(amount * 0.15);
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        line_items: [{
          price_data: {
            currency: "thb",
            product_data: {
              name: "Attend the activity",
            },
            unit_amount: amount,
          },
          quantity: 1,
        }],
        payment_intent_data: {
          transfer_data: {
            destination: connectedAccountId,
          },
          application_fee_amount: platformFee,
        },
        mode: "payment",
        success_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-success-attend?activity_id=${activity_id}&user_id=${user_id}`,
        cancel_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-cancel`,
      });


      return session;
    } catch (error) {
      throw error;
    }
  }

  static async createDonation(amount, connectedAccountId, activityId) {
    try {
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        line_items: [{
          price_data: {
            currency: "thb",
            product_data: {
              name: "Donate",
            },
            unit_amount: amount,
          },
          quantity: 1,
        }],
        payment_intent_data: {
          transfer_data: {
            destination: connectedAccountId,
          },
        },
        mode: "payment",
        success_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-success-donate?activity_id=${activityId}&amount=${amount}`,
        cancel_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-cancel`,
      });
  
      return session;
    } catch (error) {
      throw error;
    }
  }

  static async createDonationAttendFee(amount, connectedAccountId, activityId, attend_fee, current_participants) {
    try {
      const total = current_participants * attend_fee;
      const new_total = total - (amount / 100);
      const new_attend_fee = new_total / current_participants;

      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        line_items: [{
          price_data: {
            currency: "thb",
            product_data: {
              name: "Donate",
            },
            unit_amount: amount,
          },
          quantity: 1,
        }],
        payment_intent_data: {
          transfer_data: {
            destination: connectedAccountId,
          },
        },
        mode: "payment",
        success_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-success-donate-attend?activity_id=${activityId}&attend_fee=${new_attend_fee}`,
        cancel_url: `http://${process.env.BHOST}:${process.env.PORT}/api/payment/return-cancel`,
      });
  
      return session;
    } catch (error) {
      throw error;
    }
  }
  
}

module.exports = PaymentsService;
