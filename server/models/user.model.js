const pool = require('../configuration/db');

class UserModel {
  static async createUserAccount(email, password, conn) {
    try {
      const query = 'INSERT INTO user_account (email, password) VALUES (?, ?)';
      const result = await conn.query(query, [email, password]);
      return result;
    } catch (err) {
      throw err;
    }
  }

  static async createUserPersonal(firstname , middlename , lastname , age , phone, user_id, conn )
  {
    try {
      const query = 'INSERT INTO user_personal_data (first_name, middle_name, last_name, age, phone, user_id) VALUES (?, ?, ?, ?, ?, ?)';
      const result = await conn.query(query , [firstname , middlename , lastname, age ,phone, user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createUserLocation(country , city, user_id, conn)
  {
    try {
      const query = 'INSERT INTO user_location (country, city, user_id) VALUES (?, ?, ?)';
      const result = await conn.query(query , [country , city, user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createUserWork(company_name , job, user_id, conn)
  {
    try {
      const query = 'INSERT INTO user_work_data (company_name, jobs, user_id) VALUES (?, ?, ?)';
      const result = await conn.query(query , [company_name , job, user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createUserEdu(institution_name , start_year , end_year, user_id, conn)
  {
    try {
      const query = 'INSERT INTO user_education_data (edu_name, start_year, end_year, user_id) VALUES (?, ?, ?, ?)';
      const result = await conn.query(query , [institution_name , start_year, end_year, user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async checkUser(email) {
    let conn;
    try {
      conn = await pool.getConnection();
      const query = 'SELECT * FROM user_account WHERE email = ?';
      const rows = await conn.query(query, [email]);
      return rows[0]; 
    } catch (err) {
      throw err;
    } finally {
      if (conn) conn.release();
    }
  }
}

module.exports = UserModel;
