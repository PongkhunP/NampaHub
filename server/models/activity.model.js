const pool = require("../configuration/db");
const getFunctions = require("./getter.model");

class ActivityModel {
  static async createActivityInfo(
    title,
    description,
    goals,
    activity_type,
    contact_email,
    organizer,
    status,
    rating,
    user_id,
    conn
  ) {
    try {
      const query =
        "INSERT INTO activity (title, description, goals, activity_type, contact_email, organizer, status, rating, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
      const result = await conn.query(query, [
        title,
        description,
        goals,
        activity_type,
        contact_email,
        organizer,
        status,
        rating,
        user_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createActivityLocation(
    event_location,
    meet_location,
    activity_id,
    conn
  ) {
    try {
      const query =
        "INSERT INTO activity_location (event_location, meet_location, activity_id) VALUES (?, ?, ?)";
      const result = await conn.query(query, [
        event_location,
        meet_location,
        activity_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createActivityDate(
    start_regis_date,
    end_regis_date,
    start_event_date,
    end_event_date,
    activity_id,
    conn
  ) {
    try {
      const query =
        "INSERT INTO activity_date (start_regis_date, end_regis_date, start_event_date, end_event_date, activity_id) VALUES (?, ?, ?, ?, ?)";
      const result = await conn.query(query, [
        start_regis_date,
        end_regis_date,
        start_event_date,
        end_event_date,
        activity_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createActivitySupport(
    max_donation,
    participants,
    attend_fee,
    budget,
    current_participants,
    activity_id,
    conn
  ) {
    try {
      const query =
        "INSERT INTO activity_support (max_donation, participants, attend_fee, current_participants , budget, activity_id) VALUES (?, ?, ?, ?, ?, ?)";
      const result = await conn.query(query, [
        max_donation,
        participants,
        attend_fee,
        budget,
        current_participants,
        activity_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createActivityMedia(activity_image, activity_id, conn) {
    try {
      const query =
        "INSERT INTO activity_media (activity_image, activity_id) VALUES (?, ?)";
      const result = await conn.query(query, [activity_image, activity_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createActivityReward(
    reward_name,
    reward_images,
    description,
    activity_id,
    conn
  ) {
    try {
      const query =
        "INSERT INTO reward (name, reward_image, description, activity_id) VALUES (?, ?, ?, ?)";
      const result = await conn.query(query, [
        reward_name,
        reward_images,
        description,
        activity_id,
      ]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createActivityExpense(name, expense, activity_id, conn) {
    try {
      const query =
        "INSERT INTO expense (name, expense, activity_id) VALUES (?, ?, ?)";
      const result = await conn.query(query, [name, expense, activity_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  //get basic activity information
  static async getActivityInfo(conn, condition = null, data_columns = ["*"]) {
    const allowedConditions = [
      "activity_type",
      "organizer",
      "Id",
      "status",
      "user_id",
      "rating",
    ];
    const table = "activity";

    const queryBuilder = getFunctions(conn)
      .table(table)
      .allow(allowedConditions)
      .select(data_columns);

    if (condition) {
      queryBuilder.where(condition);
    }
    const result = await queryBuilder.execute();
    return result;
  }

  //get activity location
  static async getActivityLocation(
    conn,
    condition = null,
    data_columns = ["*"]
  ) {
    const allowedConditions = [
      "Id",
      "event_location",
      "meet_location",
      "activity_id",
    ];
    const table = "activity_location";

    const queryBuilder = getFunctions(conn)
      .table(table)
      .allow(allowedConditions)
      .select(data_columns);

    if (condition) {
      queryBuilder.where(condition);
    }
    const result = await queryBuilder.execute();
    return result;
  }

  //get activity media information
  static async getActivityMedia(conn, condition = null, data_columns = ["*"]) {
    const allowedConditions = ["Id", "activity_id"];
    const table = "activity_media";

    const queryBuilder = getFunctions(conn)
      .table(table)
      .allow(allowedConditions)
      .select(data_columns);

    if (condition) {
      queryBuilder.where(condition);
    }

    const result = await queryBuilder.execute();

    result.forEach((media) => {
      if (media.activity_image) {
        media.activity_image = Buffer.from(media.activity_image).toString(
          "base64"
        );
      }
    });

    return result;
  }

  //get activity support information
  static async getActivitySupport(
    conn,
    condition = null,
    data_columns = ["*"]
  ) {
    const allowedConditions = [
      "Id",
      "max_donation",
      "participants",
      "attend_fee",
      "budget",
      "activity_id",
      "current_participants",
    ];
    const table = "activity_support";

    const queryBuilder = getFunctions(conn)
      .table(table)
      .allow(allowedConditions)
      .select(data_columns);

    if (condition) {
      queryBuilder.where(condition);
    }

    const result = await queryBuilder.execute();
    return result;
  }

  //get activity date time information
  static async getActivityDate(conn, condition = null, data_columns = ["*"]) {
    const allowedConditions = [
      "Id",
      "start_regis_date",
      "end_regis_date",
      "start_event_date",
      "end_event_date",
      "event_id",
      "activity_id",
    ];
    const table = "activity_date";

    const queryBuilder = getFunctions(conn)
      .table(table)
      .allow(allowedConditions)
      .select(data_columns);

    if (condition) {
      queryBuilder.where(condition);
    }

    const result = await queryBuilder.execute();
    return result;
  }

  //get activity expense table information
  static async getActivityExpense(
    conn,
    condition = null,
    data_columns = ["*"]
  ) {
    const allowedConditions = ["Id", "name", "expense", "activity_id"];
    const table = "expense";

    const queryBuilder = getFunctions(conn)
      .table(table)
      .allow(allowedConditions)
      .select(data_columns);

    if (condition) {
      queryBuilder.where(condition);
    }

    const result = await queryBuilder.execute();
    return result;
  }
  //get activity reward table information
  static async getActivityReward(conn, condition = null, data_columns = ["*"]) {
    const allowedConditions = [
      "Id",
      "name",
      "reward_image",
      "description",
      "activity_id",
    ];
    const table = "reward";

    const queryBuilder = getFunctions(conn)
      .table(table)
      .allow(allowedConditions)
      .select(data_columns);

    if (condition) {
      queryBuilder.where(condition);
    }

    const result = await queryBuilder.execute();
    result.forEach((reward) => {
      if (reward.reward_images) {
        reward.reward_image = Buffer.from(reward.reward_image).toString(
          "base64"
        );
      }
    });

    return result;
  }

  //get participation_list table information
  static async getParticipationList(
    conn,
    condition = null,
    data_columns = ["*"]
  ) {
    const allowedConditions = [
      "Id",
      "isParticipated",
      "activity_id",
      "user_id",
    ];
    const table = "participation_list";

    const queryBuilder = getFunctions(conn)
      .table(table)
      .allow(allowedConditions)
      .select(data_columns);

    if (condition) {
      queryBuilder.where(condition);
    }

    const result = await queryBuilder.execute();
    return result;
  }

  static async getActivityOfUser(user_id, conn) {
    try {
      const query = "SELECT Id FROM activity WHERE user_id = ?";
      const result = await conn.query(query, [user_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async updateActivityRating(activity_id, rating, conn) {
    try {
      const query = "UPDATE activity SET rating = ? WHERE Id = ?";
      const result = await conn.query(query, [rating, activity_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }



  static async getActivityRating(activity_id, conn) {
    try {
      const query = "SELECT rating from activity WHERE Id = ?";
      const result = await conn.query(query, [activity_id]);
      return result;
    } catch (error) {
      throw error;
    }
  }

  static async createActivityAttendance(acitivity_id, user_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      const query = `INSERT INTO participation_list (isParticipated, activity_id, user_id) VALUES (? , ? , ?)`;
      const result = await conn.query(query, [false, acitivity_id, user_id]);

      return result;
    } catch (error) {
      throw error;
    } finally {
      if (conn) {
        conn.release();
      }
    }
  }

  static async getAttendees(activity_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      const query = `SELECT user_id , isParticipated FROM participation_list WHERE activity_id = ?`;
      const result = await conn.query(query, [activity_id]);

      return result;
    } catch (error) {
      throw error;
    } finally {
      if (conn) {
        conn.release();
      }
    }
  }

  static async updateAttendance(activity_id, checkin_list) {
    let conn;
    try {
      conn = await pool.getConnection();
      const updates = Object.entries(checkin_list).map(
        ([user_id, isParticipated]) => {
          const query = `
          UPDATE participation_list 
          SET isParticipated = ? 
          WHERE activity_id = ? AND user_id = ?
        `;
          return conn.query(query, [
            isParticipated,
            activity_id,
            parseInt(user_id, 10),
          ]);
        }
      );

      await Promise.all(updates);
      return { message: "Update successful" };
    } catch (error) {
      throw error;
    } finally {
      if (conn) {
        conn.release();
      }
    }
  }

  static async validateAttendee(activity_id, user_id) {
    let conn;
    try {
      conn = await pool.getConnection();

      const query = `SELECT * FROM participation_list WHERE activity_id = ? AND user_id = ?`;
      const result = await conn.query(query, [activity_id, user_id]);

      return result[0];
    } catch (error) {
      throw error;
    }
  }

  static async validateDeleteUser(activity_id, end_event_date) {
    let conn;
    try {
      conn = await pool.getConnection();

      const query = `SELECT * FROM activity_date WHERE activity_id = ? AND  end_event_date = ?`;
      const result = await conn.query(query, [activity_id, end_event_date]);

      return result[0];
    } catch (error) {
      throw error;
    }
  }

}


module.exports = ActivityModel;
