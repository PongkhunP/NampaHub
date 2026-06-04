require("dotenv").config();
const UserModel = require("../models/user.model");
const Userservice = require("../services/user.services");

exports.register = async (req, res, next) => {
  try {
    const userDetails = JSON.parse(req.body.userDetails);
    if (!userDetails.password) {
      console.error("Password is missing in request body"); // Log missing password error
    }
    const userImage = req.file ? req.file : null;

    const userAccount = await Userservice.registerUser(userDetails, userImage);
    const userId = userAccount.insertId;

    let tokenData = { _id: userId.toString(), email: userDetails.email };
    const token = await Userservice.generateToken(
      tokenData,
      process.env.SECRETKEY,
      process.env.JWTEXPIRED
    );

    res.json({
      status: true,
      success: "User Registered Successfully",
      token: token,
    });
  } catch (err) {
    next(err);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const user = await Userservice.checkUser(email);

    if (!user) {
      throw new Error("The following user does not exist.");
    }

    const isPasswordValid = await Userservice.validatePassword(
      password,
      user.password
    );

    if (!isPasswordValid) {
      throw new Error("Password is invalid.");
    }

    let tokenData = { _id: user.Id, email: user.email };

    const token = await Userservice.generateToken(
      tokenData,
      process.env.SECRETKEY,
      process.env.JWTEXPIRED
    );

    res.status(200).json({ status: true, token: token });
  } catch (err) {
    next(err);
  }
};

exports.show_user = async (req, res, next) => {
  try {
    const user_id = req.user._id;
    const user_data = await Userservice.showUserInfo(user_id);
    res.json({ status: true, success: user_data });
  } catch (err) {
    next(err);
  }
};

exports.delete_user = async (req, res, next) => {
  try {
    const user_id = req.user._id;
    const user_data = await Userservice.deleteUserAccount(user_id);
    res.json({ status: true, success: user_data });
  } catch (err) {
    next(err);
  }
};

exports.editUser = async (req, res, next) => {
  try {
    const userDetails = JSON.parse(req.body.userDetails);
    const user_id = req.user._id;

    let profileImage = req.file;

    const user_update = await Userservice.EditUser(userDetails, profileImage, user_id);
    res.status(200).json({ status: true, success: "Edit user successfully" });
  } catch (error) {
    next(error);
  }
};

exports.validateEmail = async (req, res, next) => {
  try {
    const email = req.query.email;

    const user = await Userservice.checkUser(email);
    const isUserExist = user != null;
    res.status(200).json({ status: true, exists: isUserExist });
  } catch (error) {
    next(error);
  }
};

exports.validateDeletion = async (req, res, next) => {
  try {
    const userId = req.user._id;

    const isValid = await Userservice.validateDeleteUser(userId);
    res.status(200).json({status: true, is_valid_payload : isValid});
  } catch (error) {
    next(error);
  }
}

exports.updateUserRating = async (req, res, next) => {
  try {
    const activity_id = req.body.activity_id;
    const rating = req.body.rating;

    if (!activity_id || !rating) {
      return res
        .status(400)
        .json({
          success: false,
          message: "User ID and rating are required",
        });
    }

    const numericRating = parseFloat(rating);

    const result = await Userservice.updateUserRating(
      numericRating,
      activity_id
    );

    res.status(200).json({status: true, success: result});
  } catch (error) {
    next(error);
  }
};

exports.createUserPayment = async (req, res, next) => {
  try {
    const accountId = req.body.accountId;
    const userId = req.user._id;

    const paymentCretedResult = await UserModel.createUserPayment(accountId, userId);
    res.status(200).json({status: true , success : 'Create User payment successfully.'});
  } catch (error) {
    next(error);
  }
};

exports.getUserPayment = async (req, res, next) => {
  try {
    const userId = req.user._id;

    const accountId = await UserModel.getUserPaymentId(userId);
    res.status(200).json({status: true, accountId : accountId});
  } catch (error) {
    next(error);
  }
};