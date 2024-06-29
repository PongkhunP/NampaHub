require("dotenv").config();
const pool = require("../configuration/db");
const paypal = require("@paypal/checkout-server-sdk");

const environment = new paypal.core.SandboxEnvironment(
  process.env.CLIENT_ID,
  process.env.CLIENT_SECRET
);
const client = new paypal.core.PayPalHttpClient(environment);

class PaymentService {
  static async createOrder(organizerPayPalEmail, donationAmount) {
    const request = new paypal.orders.OrdersCreateRequest();
    request.prefer("return=representation");
    request.requestBody({
      intent: "CAPTURE",
      purchase_units: [
        {
          amount: {
            currency_code: "USD",
            value: donationAmount.toFixed(2),
          },
          payee: {
            email_address: organizerPayPalEmail,
          },
        },
      ],
      application_context: {
        return_url: `myapp://success`,
        cancel_url: `myapp://cancel`,
      },
    });
    console.log("Request Body:", JSON.stringify(request, null, 2));
    try {
      const order = await client.execute(request);
      console.log("Order success : " + order.result.id);
      const approvalUrl = order.result.links.find(
        (link) => link.rel === "approve"
      ).href;
      console.log("Approval URL: " + approvalUrl);
      return order.result;
    } catch (error) {
      throw new Error("Error creating order : " + error);
    }
  }

  static async createAttend(
    orgnaizerPayPalEmail,
    totalAmount,
    platformFeePercentage = 15
  ) {
    let platformFee = ((totalAmount * platformFeePercentage) / 100).toFixed(2);
    console.log("Platform fee : " + platformFee);
    let organizerAmount = (totalAmount - platformFee).toFixed(2);
    console.log("organization fee : " + organizerAmount);

    let request = new paypal.orders.OrdersCreateRequest();
    request.prefer("return=representation");
    request.requestBody({
      intent: "CAPTURE",
      purchase_units: [
        {
          amount: {
            currency_code: "USD",
            value: totalAmount.toFixed(2),
            breakdown: {
              item_total: {
                currency_code: "USD",
                value: totalAmount.toFixed(2),
              },
            },
          },
          payee: {
            email_address: orgnaizerPayPalEmail,
          },
          payment_instruction: {
            disbursement_mode: "INSTANT",
            platform_fees: [
              {
                amount: { 
                  currency_code: "USD",
                  value: platformFee,
                },
                payee: {
                  email_address: "sb-rf0ra31423729@business.example.com",
                },
              },
            ],
          },
        },
      ],
      application_context: {
        return_url: `myapp://success`,
        cancel_url: `myapp://cancel`,
      },
    });

    try {
      const order = await client.execute(request);
      console.log("Order created successfully:", order.result);
      return order.result;
    } catch (error) {
      throw new Error("Error creating order : " + error);
    }
  }

  static async captureOrder(orderId) {
    console.log("Services level order Id : " + orderId);
    try {
      const request = new paypal.orders.OrdersCaptureRequest(orderId);
      request.requestBody({});

      const capture = await client.execute(request);

      return capture.result;
    } catch (error) {
      console.log(error);
      throw new Error("Error captureing order : " + error);
    }
  }

  static async executeHandle(request) {
    return await client.execute(request);
  }
}

module.exports = PaymentService;
