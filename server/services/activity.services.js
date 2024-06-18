const ActivityModel = require("../models/activity.model");
const pool = require("../configuration/db");
const { json } = require("body-parser");

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
        activityData.activity_date.event_date,
        activity_id,
        conn
      );

      console.log("Creating activity support...");
      await ActivityModel.createActivitySupport(
        activityData.activity_support.max_donation,
        activityData.activity_support.participants,
        activityData.activity_support.attend_fee || 0,
        activityData.activity_support.budget || 0,
        activity_id,
        conn
      );

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
          console.log(`Creating reward: ${rewardData.name}`);
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
        ["start_regis_date", "end_regis_date", "event_date"]
      );

      const activity_media = await ActivityModel.getActivityMedia(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["activity_image"]
      );
      console.log(activity_media);

      const activity_reward = await ActivityModel.getActivityReward(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["name", "reward_image", "description"]
      );

      // console.log('Rewards : ' + activity_reward[0].reward_image);

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
}

module.exports = ActivityService;
