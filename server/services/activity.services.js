const ActivityModel = require("../models/activity.model");
const pool = require("../configuration/db");

class ActivityService {
  static async createActivity(
    activityData,
    user_id,
    user_email,
    activityImage,
    rewardImages
  ) {
    const conn = await pool.getConnection();

    try {
      await conn.beginTransaction();

      console.log("Creating activity info...");
      const goals = activityData.goals
        ? JSON.stringify(activityData.goals)
        : "[]";

      const activityInfo = await ActivityModel.createActivityInfo(
        activityData.title,
        activityData.description,
        goals,
        activityData.activity_type,
        activityData.contact_email || user_email,
        activityData.organizer || user_email,
        activityData.status || "On-going",
        // activityData.rating || 0,
        user_id,
        conn
      );

      const activity_id = activityInfo.insertId;
      console.log(`Activity created with ID: ${activity_id}`);

      console.log("Creating activity location...");
      await ActivityModel.createActivityLocation(
        activityData.activity_location.event_location,
        activityData.activity_location.meet_location,
        activity_id,
        conn
      );

      console.log("Creating activity date...");
      await ActivityModel.createActivityDate(
        activityData.activity_date.start_regis_date,
        activityData.activity_date.end_regis_date,
        activityData.activity_date.start_event_date,
        activityData.activity_date.end_event_date,
        activity_id,
        conn
      );

      console.log("Creating activity support...");
      await ActivityModel.createActivitySupport(
        activityData.activity_support.max_donation,
        activityData.activity_support.participants,
        activityData.activity_support.attend_fee || 0,
        activityData.activity_support.budget || 0,
        activityData.activity_support.current_participants || 0,
        activity_id,
        conn
      );

      console.log("Creating activity expenses...");
      for (const expense of activityData.expenses) {
        await ActivityModel.createActivityExpense(
          expense.name,
          expense.expense,
          activity_id,
          conn
        );
      }

      if (activityImage) {
        console.log("Creating activity media...");
        await ActivityModel.createActivityMedia(
          activityImage.buffer,
          activity_id,
          conn
        );
      }

      for (const rewardImage of rewardImages) {
        const rewardData = activityData.rewards.find(
          (reward) => reward.name === rewardImage.originalname
        );
        if (rewardData) {
          await ActivityModel.createActivityReward(
            rewardData.name,
            rewardImage.buffer,
            rewardData.description,
            activity_id,
            conn
          );
        }
      }

      await conn.commit();
      return { success: true, activity_id };
    } catch (error) {
      console.error("Error creating activity:", error);
      await conn.rollback();
      throw error;
    } finally {
      conn.release();
    }
  }

  static async getAllActivity(activity_type) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      if (activity_type != "Forest" && activity_type != "Marine") {
        activity_type = "Other";
      }

      const activities = await ActivityModel.getActivityInfo(conn, {
        field: "activity_type",
        operator: "=",
        value: activity_type,
      });

      for (const activity of activities) {
        const location = await ActivityModel.getActivityLocation(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["event_location"]
        );
        if (location.length > 0) {
          activity.event_location = location[0];
        }

        const media = await ActivityModel.getActivityMedia(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["activity_image"]
        );

        if (media.length > 0) {
          activity.activity_image = media[0].activity_image;
        }
      }

      await conn.commit(); // Commit transaction
      return activities;
    } catch (error) {
      if (conn) {
        await conn.rollback(); // Rollback transaction on error
      }
      console.error("Error fetching activities:", error);
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }

  static async getHistoryActivity(status) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      const activities = await ActivityModel.getActivityInfo(conn, {
        field: "status",
        operator: "=",
        value: status,
      });

      for (const activity of activities) {
        const location = await ActivityModel.getActivityLocation(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["event_location"]
        );
        if (location.length > 0) {
          activity.event_location = location[0];
        }

        const media = await ActivityModel.getActivityMedia(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["activity_image"]
        );

        if (media.length > 0) {
          activity.activity_image = media[0].activity_image;
        }

        const support = await ActivityModel.getActivitySupport(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["participants"]
        );

        if (support.length > 0) {
          activity.participants = support[0].participants;
        }
      }

      await conn.commit(); // Commit transaction
      return activities;
    } catch (error) {
      if (conn) {
        await conn.rollback(); // Rollback transaction on error
      }
      console.error("Error fetching activities:", error);
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }

  static async getActivityCount(user_id)
  {
    let conn;
    try {
      conn = await pool.getConnection();

      const activity_info = await ActivityModel.getActivityInfo(conn, null , ['status' , 'user_id']);

      let counts = {
        'On-going': 0,
        'Success': 0,
        'Created': 0
      };

      activity_info.forEach(activity => {
        if (activity.user_id === user_id) {
          counts['Created']++;
        }
  
        if (activity.status === 'On-going') {
          counts['On-going']++;
        } else if (activity.status === 'Success') {
          counts['Success']++;
        }
      });

      return counts;
    } catch (error) {
      throw(error);
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }

  static async getActivity(activity_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      const activityInfo = await ActivityModel.getActivityInfo(conn, {
        field: "Id",
        operator: "=",
        value: activity_id,
      });

      const activity_support = await ActivityModel.getActivitySupport(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        [
          "max_donation",
          "participants",
          "attend_fee",
          "budget",
          "current_participants",
        ]
      );

      const activity_location = await ActivityModel.getActivityLocation(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["event_location", "meet_location"]
      );

      const activity_date = await ActivityModel.getActivityDate(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["start_regis_date", "end_regis_date", "start_event_date","end_event_date"]
      );

      const activity_media = await ActivityModel.getActivityMedia(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["activity_image"]
      );

      const activity_reward = await ActivityModel.getActivityReward(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["name", "reward_image", "description"]
      );

      const activity_expense = await ActivityModel.getActivityExpense(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["name", "expense"]
      );

      await conn.commit(); // Commit transaction

      const activity = {
        ...activityInfo[0],
        activity_support: activity_support[0],
        activity_location: activity_location[0],
        activity_date: activity_date[0],
        activity_media: activity_media[0],
        rewards: activity_reward,
        expenses: activity_expense,
      };

      return activity;
    } catch (error) {
      if (conn) {
        await conn.rollback(); // Rollback transaction on error
      }
      console.error("Error fetching activities:", error);
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }

  static async getSearchActivity(query)
  {
    
  }

  static logObject(obj, indent = 0) {
    for (const key in obj) {
      if (Object.prototype.hasOwnProperty.call(obj, key)) {
        const value = obj[key];
        if (typeof value === "object" && value !== null) {
          console.log(`${" ".repeat(indent)}${key}: `);
          ActivityService.logObject(value, indent + 2); // Use ActivityService.logObject recursively
        } else {
          console.log(`${" ".repeat(indent)}${key}: ${value}`);
        }
      }
    }
  }

  static async getHistory(status) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      

      const activities = await ActivityModel.getActivityInfo(conn, {
        field: "status",
        operator: "=",
        value: status,
      });
      console.log("status:" + status)
      console.log("acitivity id: "+ activities)

      for (const activity of activities) {
        const location = await ActivityModel.getActivityLocation(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["event_location"]
        );
        if (location.length > 0) {
          activity.event_location = location[0];
        }

        const media = await ActivityModel.getActivityMedia(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["activity_image"]
        );

        if (media.length > 0) {
          activity.activity_image = media[0].activity_image;
        }
        const support = await ActivityModel.getActivitySupport(
        conn,
        {field: 'activity_id', operator : "=", value:activity.Id},
        ["participants"]
        );
        if(support.length > 0){
          activity.participants = support[0].participants;
        }
      }

      await conn.commit(); // Commit transaction
      return activities;
    } catch (error) {
      if (conn) {
        await conn.rollback(); // Rollback transaction on error
      }
      console.error("Error fetching activities:", error);
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }
}

module.exports = ActivityService;
