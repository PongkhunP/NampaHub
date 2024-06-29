const PaymentService = require("../services/payment.services");

exports.handleCreateOrder = async (req, res, next) => {
  try {
    const payerEmail = "sb-rf0ra31423729@business.example.com";
    if (!req.body.donation_amount || req.body.donation_amount <= 0) {
      throw new Error("Invalid transaction amount.");
    }
    const donationAmount = req.body.donation_amount;
    console.log("create order activate");
    const order = await PaymentService.createOrder(payerEmail, donationAmount);
    console.log("Order Id : " + order.id);
    res.json({ status: true, id: order.id });
  } catch (error) {
    next(error);
  }
};

exports.handleCreateAttend = async (req, res, next) => {
  try {
    const totalAmount = req.body.amount;
    const percentage = 15;
    const organizerAccount = "sb-ykv6d31387745@business.example.com";

    console.log("totalAmount : " + totalAmount);

    const order = await PaymentService.createAttend(
      organizerAccount,
      totalAmount,
      percentage
    );
    res.json({ status: true, id: order.id });
  } catch (error) {
    next(error);
  }
};

exports.handleCapture = async (req, res, next) => {
  try {
    const orderId = req.body.order_id || req.query.order_id;
    console.log("Order Id received in backend: " + orderId);
    if (!orderId) {
      throw new Error("Order ID is missing");
    }
    const capture = await PaymentService.captureOrder(orderId);
    console.log("Payment captured: ", JSON.stringify(capture, null, 2));
    res.json({ status: true, success: capture });
  } catch (error) {
    if (error.message.includes("ORDER_ALREADY_CAPTURED")) {
      console.log("Order already captured.");
      res.status(200).json({ status: true, message: "Order already captured" });
    } else {
      next(error);
    }
  }
};

exports.successPayment = async (req, res, next) => {
  const { token, PayerID } = req.query;
  if (!token || !PayerID) {
    return res.status(400).send("Missing token or PayerID");
  }

  try {
    const request = await PaymentService.captureOrder(token);
    res.send("Payment successful!");
  } catch (error) {
    res.status(500).send("Error capturing payment");
  }
};

exports.cancelPayment = async (req, res, next) => {
  res.send("Payment cancelled");
};
