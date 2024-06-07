const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const UserModel = require('../models/user.model');

class UserService{
    static async registerUser(email , password)
    {
        try
        {
            const saltRounds = 10;
            const hashedPassword = await bcrypt.hash(password , saltRounds);

            return await UserModel.createUser(email , hashedPassword);
        }
        catch(err)
        {
            throw err;
        }
    }

    static async checkUser(email)
    {
        return await UserModel.checkUser(email);
    }

    static async validatePassword(inputPassword , actualPassword)
    {
        if(!inputPassword || !actualPassword)
        {
            throw new Error('Password validation failed due to missing data');
        }
        return await bcrypt.compare(inputPassword , actualPassword);
    }

    static async generateToken(tokenData, secreteKey , jwt_expired)
    {
        return jwt.sign(tokenData , secreteKey , {expiresIn : jwt_expired});
    }
}

module.exports = UserService;