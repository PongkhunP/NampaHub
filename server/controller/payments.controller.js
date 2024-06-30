const PaysmentService = require("../services/payments.services");
const UserModel = require('../models/user.model');
const ActivityService = require("../services/activity.services");
const ActivityModel = require("../models/activity.model");

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
};

exports.createPayout = async (req, res, next) => {
  try {
    const amount = req.body.amount;
    const payment = await PaysmentService.createPayout(amount);
    res.send({
      url: payment.url,
    });
  } catch (error) {
    next(error);
  }
};

exports.createOnboardingLink = async (req, res, next) => {
    try {
        const result = await PaysmentService.createOnboard();

        res.status(200).send({url : result.accountLink, id: result.accountId});
    } catch (error) {
        next(error);
    }
}

exports.createAttend = async (req, res, next) => {
  try {
    const amount = req.body.amount;
    const activityId = req.body.activity_id;
    const userId = req.user._id;

    const ownerId = await ActivityService.getUserId(activityId);

    const accountId = await UserModel.getUserPaymentId(ownerId);


    const session = await PaysmentService.createSplitAttend(amount, accountId.account_id, activityId, userId);

    res.status(200).json({url : session.url});
  } catch (error) {
    next(error);
  }
}

exports.createDonate = async (req, res, next) => {
  try {
    const amount = req.body.amount;
    const activityId = req.body.activity_id;

    const userId = await ActivityService.getUserId(activityId);


    const accountId = await UserModel.getUserPaymentId(userId);

    const session = await PaysmentService.createDonation(amount, accountId.account_id, activityId);

    res.status(200).json({url : session.url});
  } catch (error) {
    next(error);
  }
}

exports.createDonateAttendFee = async (req, res, next) => {
  try {
    const amount = req.body.amount;
    const currentParticipation = req.body.current_participants;
    const attendFee = req.body.attend_fee;
    const activityId = req.body.activity_id;

    const userId = await ActivityService.getUserId(activityId);

    const accountId = await UserModel.getUserPaymentId(userId);

    const session = await PaysmentService.createDonationAttendFee(amount, accountId.account_id, activityId, attendFee, currentParticipation);

    res.status(200).json({url : session.url});
  } catch (error) {
    next(error);
  }
}

exports.handleSuccessDonateAttend = async (req, res, next) => {
  try {
    const activityId = req.query.activity_id;
    const attend_fee = req.query.attend_fee;


    await ActivityModel.updateAttendFee(activityId, attend_fee);

    res.writeHead(302, { Location: "myapp://success" });
    res.end();
  } catch (error) {
    next(error);
  }
};

exports.handleSuccessDonate = async (req, res, next) => {
  try {
    const activityId = req.query.activity_id;
    const amount = Number(req.query.amount)/100; 

    await ActivityModel.updateBudget(amount,activityId);

    res.writeHead(302, { Location: "myapp://success" });
    res.end();
  } catch (error) {
    next(error);
  }
};

exports.handleSuccessAttend = async (req, res, next) => {
  try {
    const activityId = req.query.activity_id;
    const userId = req.query.user_id;

    await ActivityService.createAttendance(activityId, userId);

    res.writeHead(302, { Location: "myapp://success" });
    res.end();
  } catch (error) {
    next(error);
  }
};

exports.handleCancel = async (req, res, next) => {
  try {
    res.writeHead(302, { Location: "myapp://cancel" });
    res.end();
  } catch (error) {
    next(error);
  }
};
