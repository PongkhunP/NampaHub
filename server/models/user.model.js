const pool = require('../configuration/db');

class UserModel {
  static async createUser(email, password) {
    let conn;
    try {
      conn = await pool.getConnection();
      const query = 'INSERT INTO user_account (email, password) VALUES (?, ?)';
      const result = await conn.query(query, [email, password]);
      return result;
    } catch (err) {
      throw err;
    } finally {
      if (conn) conn.release();
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
