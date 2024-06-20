const pool = require("../configuration/db");
const getFunctions = require("./getter.model");

class UserModel {
  static async createUserAccount(email, password, conn) {
    try {
      const query = "INSERT INTO user_account (email, password) VALUES (?, ?)";
      const result = await conn.query(query, [email, password]);
      return result;
    } catch (err) {
      throw err;
    }
  }

  static async createUserPersonal(
    firstname,
    middlename,
    lastname,
    age,
    phone,
    user_id,
    conn
  ) {
    try {
      const query =
        "INSERT INTO user_personal_data (first_name, middle_name, last_name, age, phone, user_id) VALUES (?, ?, ?, ?, ?, ?)";
      const result = await conn.query(query, [
        firstname,
        middlename,
        lastname,
        age,
        phone,
        user_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createUserLocation(country, city, user_id, conn) {
    try {
      const query =
        "INSERT INTO user_location (country, city, user_id) VALUES (?, ?, ?)";
      const result = await conn.query(query, [country, city, user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createUserWork(company_name, job, user_id, conn) {
    try {
      const query =
        "INSERT INTO user_work_data (company_name, jobs, user_id) VALUES (?, ?, ?)";
      const result = await conn.query(query, [company_name, job, user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createUserEdu(
    institution_name,
    start_year,
    end_year,
    user_id,
    conn
  ) {
    try {
      const query =
        "INSERT INTO user_education_data (edu_name, start_year, end_year, user_id) VALUES (?, ?, ?, ?)";
      const result = await conn.query(query, [
        institution_name,
        start_year,
        end_year,
        user_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async checkUser(email) {
    let conn;
    try {
      conn = await pool.getConnection();
      const query = "SELECT * FROM user_account WHERE email = ?";
      const rows = await conn.query(query, [email]);
      return rows[0];
    } catch (err) {
      throw err;
    } finally {
      if (conn) conn.release();
    }
  }

  static async showUserAccount(user_id, conn) {
    try {
      const query = "Select email , rating from user_account where Id = ?";
      const result = await conn.query(query, [user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async showUserPersonal(user_id, conn) {
    try {
      const query =
        "Select first_name, middle_name, last_name, age , phone from user_personal_data where user_id = ?";
      const result = await conn.query(query, [user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async showUserEdu(user_id, conn) {
    try {
      const query =
        "Select edu_name, start_year, end_year from user_education_data where user_id = ?";
      const result = await conn.query(query, [user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async showUserWork(user_id, conn) {
    try {
      const query =
        "Select company_name, jobs from user_work_data where user_id = ?";
      const result = await conn.query(query, [user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async updateUserAccount(user_email, user_password, user_id, conn) {
    try {
      const query =
        "UPDATE user_account SET email = ? , password = ? WHERE Id = ?;";
      const result = await conn.query(query, [
        user_email,
        user_password,
        user_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async showUserlocation(user_id, conn) {
    try {
      const query = "Select country, city from user_location where user_id = ?";
      const result = await conn.query(query, [user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }
  static async updateUserEdu(edu_name, start_year, end_year, user_id, conn) {
    try {
      const query =
        "UPDATE user_education_data SET edu_name = ?, start_year =?, end_year = ? WHERE user_id = ?;";
      const result = await conn.query(query, [
        edu_name,
        start_year,
        end_year,
        user_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async deleteActivityData(activity_id, conn) {
    try {
      const deleteQueries = [
        "DELETE FROM activity_date WHERE activity_id = ?",
        "DELETE FROM activity_location WHERE activity_id = ?",
        "DELETE FROM activity_media WHERE activity_id = ?",
        "DELETE FROM activity_support WHERE activity_id = ?",
        "DELETE FROM expense WHERE activity_id = ?",
        "DELETE FROM reward WHERE activity_id = ?",
      ];

      for (const query of deleteQueries) {
        await conn.query(query, [activity_id]);
      }

      const deleteActivityQuery = "DELETE FROM activity WHERE Id = ?";
      await conn.query(deleteActivityQuery, [activity_id]);
    } catch (error) {
      throw error;
    }
  }
  static async updateUserLocation(country, city, user_id, conn) {
    try {
      const query =
        "UPDATE user_location SET country = ? , city = ? WHERE user_id = ?;";
      const result = await conn.query(query, [country, city, user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async deleteAllUserRelatedData(user_id, conn) {
    try {
      const activityIdsQuery = "SELECT id FROM activity WHERE user_id = ?";
      const activityIds = await conn.query(activityIdsQuery, [user_id]);

      for (const activity of activityIds) {
        await this.deleteActivityData(activity.id, conn);
      }

      const deleteQueries = [
        "DELETE FROM user_location WHERE user_id = ?",
        "DELETE FROM user_education_data WHERE user_id = ?",
        "DELETE FROM user_personal_data WHERE user_id = ?",
        "DELETE FROM user_work_data WHERE user_id = ?",
        "DELETE FROM user_payment WHERE user_id = ?",
      ];

      for (const query of deleteQueries) {
        await conn.query(query, [user_id]);
      }

      const deleteUserAccountQuery = "DELETE FROM user_account WHERE Id = ?";
      await conn.query(deleteUserAccountQuery, [user_id]);
    } catch (error) {
      throw error;
    }
  }
  static async updateUserPersonal(
    first_name,
    last_name,
    middle_name,
    user_id,
    age,
    phone,
    conn
  ) {
    try {
      const query =
        "UPDATE user_personal_data SET first_name = ? , last_name = ?  ,middle_name = ?, age = ?, phone = ? WHERE user_id = ?";
      const result = await conn.query(query, [
        first_name,
        last_name,
        middle_name,
        user_id,
        age,
        phone,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async deleteUser(user_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      await this.deleteAllUserRelatedData(user_id, conn);

      await conn.commit();
    } catch (error) {
      if (conn) await conn.rollback();
      throw error;
    } finally {
      if (conn) conn.release();
    }
  }
  static async updateUserWorkData(company, jobs, user_id, conn) {
    try {
      const query =
        "UPDATE user_work_data SET company_name = ? , jobs = ? WHERE user_id = ?;";
      const result = await conn.query(query, [(company, jobs, user_id)]);
      return result;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = UserModel;
