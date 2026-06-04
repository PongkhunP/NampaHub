const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const UserModel = require("../models/user.model");
const ActivityModel = require("../models/activity.model");
const pool = require("../configuration/db");
const { fields } = require("../configuration/upload");

class UserService {
  static async registerUser(userDetails, user_image) {
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
        userDetails.rating,
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
        const startYearFormat = parseInt(userDetails.start_year, 10);
        const endYearFormat = parseInt(userDetails.end_year, 10);
        
        const startYear = `${startYearFormat}-01-01`;
        const endYear = `${endYearFormat}-01-01`;

        const user_edu = await UserModel.createUserEdu(
          userDetails.edu_name,
          startYear,
          endYear,
          userId,
          conn
        );
      }

      const user_media = await UserModel.createUserMedia(
        user_image.buffer,
        userId,
        conn
      );

      await conn.commit();
      return { insertId: userId, ...user_account };
    } catch (err) {
      throw err;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }
  static async showUserInfo(user_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction;

      const user_account = await UserModel.showUserAccount(user_id, conn);
      const user_personal = await UserModel.showUserPersonal(user_id, conn);
      const user_edu = await UserModel.showUserEdu(user_id, conn);
      const user_work = await UserModel.showUserWork(user_id, conn);
      const user_location = await UserModel.showUserlocation(user_id, conn);
      const user_media = await UserModel.showUserMedia(user_id, conn);

      await conn.commit();
      const userInfo = {
        ...user_account[0],
        ...user_personal[0],
        ...user_edu[0],
        ...user_work[0],
        ...user_location[0],
        user_media: user_media[0],
      };

      return userInfo;
    } catch (error) {
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }

  static async EditUser(userDetails, user_image_file, user_Id) {
    let conn;
    try {
      conn = await pool.getConnection();
      conn.beginTransaction();

      await UserModel.updateUserEdu(
        userDetails.edu_name,
        userDetails.start_year,
        userDetails.end_year,
        user_Id,
        conn
      );
      await UserModel.updateUserLocation(
        userDetails.country,
        userDetails.city,
        user_Id,
        conn
      );
      await UserModel.updateUserPersonal(
        userDetails.firstname,
        userDetails.lastname,
        userDetails.middlename,
        user_Id,
        userDetails.age,
        userDetails.phone,
        conn
      );
      await UserModel.updateUserWorkData(
        userDetails.company_name,
        userDetails.job,
        user_Id,
        conn
      );
      await UserModel.updateUserMediaData(
        user_image_file.buffer,
        user_Id,
        conn
      );

      await conn.commit();
      return true;
    } catch (error) {
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }

  static async deleteUserAccount(user_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction;

      const activity_ids = await ActivityModel.getActivityOfUser(user_id, conn);

      for (const activity_id in activity_ids) {
        await UserModel.deleteActivityData(activity_id, conn);
      }
      const delete_user = await UserModel.deleteAllUserRelatedData(
        user_id,
        conn
      );

      await conn.commit();
      return true;
    } catch (error) {
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }

  static async validateDeleteUser(user_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      const activitys = await ActivityModel.getActivityInfo(conn, {
        field: "user_id",
        operator: "=",
        value: user_id,
      });

      const currentDate = new Date();
      let isAbleToDeleteAcc = true;

      for (const activity of activitys) {
        const dates = await ActivityModel.getActivityDate(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["end_event_date"]
        );

        if (dates.length > 0 && dates[0].end_event_date instanceof Date) {
          const endEventDate = dates[0].end_event_date;
          if (currentDate <= endEventDate) {
            isAbleToDeleteAcc = false;
          }
        }
      }
      await conn.commit();

      return isAbleToDeleteAcc;
    } catch (error) {
      throw error;
    } finally {
      if(conn)
      {
        await conn.release();
      }
    }
  }

  static async updateUserRating(rating, activity_id) {
    let conn;
    try {
      conn = await pool.getConnection();

      const userId = await ActivityModel.getActivityInfo(
        conn,
        { field: "Id", operator: "=", value: activity_id },
        ["user_id"]
      );

      const result = await UserModel.updateUserRating(
        userId[0].user_id,
        rating,
        conn
      );

      if (!result) {
        throw new Error("User not found or rating not updated.");
      }

      return result;
    } catch (error) {
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
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

}

module.exports = UserService;
