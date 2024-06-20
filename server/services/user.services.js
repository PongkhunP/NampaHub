const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const UserModel = require("../models/user.model");
const pool = require("../configuration/db");
const { fields } = require("../configuration/upload");

class UserService {
  static async registerUser(userDetails) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(
        userDetails.password,
        saltRounds
      );

      const user_account = await UserModel.createUserAccount(
        userDetails.email,
        hashedPassword,
        conn
      );
      const userId = user_account.insertId;

      const user_personal = await UserModel.createUserPersonal(
        userDetails.firstname,
        userDetails.middlename,
        userDetails.lastname,
        userDetails.age,
        userDetails.phone,
        userId,
        conn
      );

      const user_location = await UserModel.createUserLocation(
        userDetails.country,
        userDetails.city,
        userId,
        conn
      );

      if (userDetails.company_name && userDetails.job) {
        const user_work = await UserModel.createUserWork(
          userDetails.company_name,
          userDetails.job,
          userId,
          conn
        );
      }

      if (
        userDetails.start_year &&
        userDetails.end_year &&
        userDetails.edu_name
      ) {
        const startYear = new Date(userDetails.start_year, 0, 1);
        const endYear = new Date(userDetails.end_year, 0, 1);
        const user_edu = await UserModel.createUserEdu(
          userDetails.edu_name,
          startYear,
          endYear,
          userId,
          conn
        );
      }

      await conn.commit();
      return { insertId: userId, ...user_account };
    } catch (err) {
      throw err;
    }
  }

  static async checkUser(email) {
    return await UserModel.checkUser(email);
  }

  static async validatePassword(inputPassword, actualPassword) {
    if (!inputPassword || !actualPassword) {
      throw new Error("Password validation failed due to missing data");
    }
    return await bcrypt.compare(inputPassword, actualPassword);
  }

  static async generateToken(tokenData, secreteKey, jwt_expired) {
    return jwt.sign(tokenData, secreteKey, { expiresIn: jwt_expired });
  }

  static async showUserInfo(user_id)
  {
    let conn; 
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction;

      const user_account = await UserModel.showUserAccount(user_id, conn);
      const user_personal = await UserModel.showUserPersonal(user_id, conn);
      const user_edu = await UserModel.showUserEdu(user_id, conn);
      const user_work = await UserModel.showUserWork(user_id, conn);
      const user_location = await UserModel.showUserlocation(user_id, conn);

      
      await conn.commit();
      const userInfo = {...user_account[0] , ...user_personal[0] , ...user_edu[0] , ...user_work[0] , ...user_location[0]}
      // const userInfo = {user_account , user_personal , user_edu , user_work, user_location}
      return userInfo;
    } catch (error) {
      throw error;
    }
  }

  static async EditUser(userDetails, user_Id){
    let conn;
    try {
        // {email: '', passowd: ""}
        conn = await pool.getConnection();
        conn.beginTransaction();

        await UserModel.updateUserAccount(userDetails.email,userDetails.password,user_Id,conn)
        await UserModel.updateUserEdu(userDetails.edu_name,userDetails.start_year,userDetails.end_year,user_Id,conn)
        await UserModel.updateUserLocation(userDetails.country,userDetails.city,user_Id,conn)
        await UserModel.updateUserPersonal(userDetails.firstname,userDetails.lastname,userDetails.middlename,userDetails.age,userDetails.phone,user_Id,conn)
        await UserModel.updateUserWorkData(userDetails.company_name,userDetails.job,user_Id,conn)
        
        await conn.commit();
        return true;
    } catch (error) {
        throw error;
    }

}
}


module.exports = UserService;
