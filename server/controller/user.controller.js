require("dotenv").config();
const Userservice = require("../services/user.services");

exports.register = async (req, res, next) => {
  try {
    const userDetails = req.body;

    if (!userDetails.password) {
      console.error("Password is missing in request body"); // Log missing password error
    }

    const userAccount = await Userservice.registerUser(userDetails);
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

exports.login = async(req,res,next) => {
    try
    {
        const {email , password} = req.body;
        const user = await Userservice.checkUser(email);

        if(!user)
        {
            throw new Error('The following user do not exists.');
        }

        const isPasswordValid = await Userservice.validatePassword(password , user.password);
        
        if(!isPasswordValid)
        {
            throw new Error('Password is Invalid.');
        }
        
        let tokenData = {_id: user.Id , email: user.email};

        const token = await Userservice.generateToken(tokenData, process.env.SECRETKEY, process.env.JWTEXPIRED);

        res.status(200).json({status: true , token: token});
    }catch(err)
    {
      next(err);
    }
};

exports.show_user = async (req, res, next) => {
  try {
    const user_id = req.user._id;
    const user_data = await Userservice.showUserInfo(user_id);
    res.json({ status: true, success: user_data });
  } catch (err) {
    throw err;
  }
};

exports.delete_user = async (req, res, next) => {
  try {
    const user_id = req.user._id;
    const user_data = await Userservice.deleteUserAccount(user_id);
    res.json({ status: true, success: user_data });
  } catch (err) {
    next(error);
  }
};

exports.editUser = async (req, res, next) => {
  try {
    const userDetails = req.body;
    const user_id = req.user._id;
    const user_email = req.user.email;

    console.log("User id : " + user_id);
    console.log("User email : " + user_email);

    const user_update = await Userservice.EditUser(userDetails,user_id);
    res.status(200).json({status: true, success: "Edit user succesfully"});
  } catch (error) {
    next(error);
  }
};

exports.validateEmail = async (req, res, next) => {
  try {
    const email = req.query.email;

    const user = await Userservice.checkUser(email);
    const isUserExist = user != null;
    res.status(200).json({status: true, exists: isUserExist});
  } catch (error) {
    next(error);
  }
}