require('dotenv').config();
const Userservice = require('../services/user.services');

exports.register = async (req, res, next) => {
  try {
    const userDetails = req.body;
    console.log('User details received:', userDetails); // Log to verify the request body

    if (!userDetails.password) {
      console.error('Password is missing in request body'); // Log missing password error
    }

    const userAccount = await Userservice.registerUser(userDetails);
    const userId = userAccount.insertId;
    console.log("Id : " + userId);

    let tokenData = {_id : userId.toString() , email : userDetails.email};
    const token = await Userservice.generateToken(tokenData , process.env.SECRETKEY, process.env.JWTEXPIRED);

    res.json({ status: true, success: 'User Registered Successfully', token : token });
  } catch (err) {
    console.error('Error in registration controller:', err);
    next(err); // Ensure error handling middleware is called
  }
};


exports.login = async(req,res,next) => {
    try
    {
        const {email , password} = req.body;
        const user = await Userservice.checkUser(email);

        if(!user)
        {
            throw new Error('The following user do not exists in database');
        }

        const isPasswordValid = Userservice.validatePassword(password , user.password);
        
        if(!isPasswordValid)
        {
            throw new Error('Password is Invalid');
        }
        console.log("User Id : " + user.Id);
        console.log("Email : " + user.email);
        
        let tokenData = {_id: user.Id , email: user.email};

        const token = await Userservice.generateToken(tokenData, process.env.SECRETKEY, process.env.JWTEXPIRED);

        res.status(200).json({status: true , token: token});
    }catch(err)
    {
        throw err;
    }
}

exports.show_user = async(req,res,next) => {
  try
  {
      const user_id = req.user._id;
      const user_data = await Userservice.showUserInfo(user_id)
      res.json({status :true , success : user_data});

  }catch(err)
  {
      throw err;
  }
}

