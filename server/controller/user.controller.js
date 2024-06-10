require('dotenv').config();
const Userservice = require('../services/user.services');

exports.register = async(req,res,next) => {
    try
    {
        const {userDetails} = req.body;
        const response = await Userservice.registerUser(userDetails);

        res.json({status: true, success: `User Registered Successfully with data  user_account : ${response}`});
    }catch(err)
    {
        throw err;
    }
}

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

        let tokenData = {_id: user.Id , email: user.email};

        const token = await Userservice.generateToken(tokenData, process.env.SECRETKEY, process.env.JWTEXPIRED);

        res.status(200).json({status: true , token: token});
    }catch(err)
    {
        throw err;
    }
}

