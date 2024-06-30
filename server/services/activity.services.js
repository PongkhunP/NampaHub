const ActivityModel = require("../models/activity.model");
const UserService = require("../services/user.services");
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
        activityData.rating || 0,
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

      console.log("Initialize participation list for activity...");
      const participated = true;
      await ActivityModel.createActivityAttendance(activity_id, user_id, participated, conn);

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

  static async editActivity(
    activityData,
    activityImage,
    rewardImages
  ) {
    const conn = await pool.getConnection();

    try {
      await conn.beginTransaction();

      console.log("Updating activity info...");
      const goals = activityData.goals
        ? JSON.stringify(activityData.goals)
        : "[]";

      const activityInfo = await ActivityModel.editActivityInfo(
        activityData.id,
        activityData.title,
        activityData.description,
        goals,
        activityData.activity_type,
        activityData.contact_email,
        activityData.organizer,
        activityData.status,
        activityData.rating,
        conn
      );

      console.log("Updating activity location...");
      await ActivityModel.editActivityLocation(
        activityData.id,
        activityData.activity_location.event_location,
        activityData.activity_location.meet_location,
        conn
      );

      console.log("Updating activity date...");
      await ActivityModel.editActivityDate(
        activityData.id,
        activityData.activity_date.start_regis_date,
        activityData.activity_date.end_regis_date,
        activityData.activity_date.start_event_date,
        activityData.activity_date.end_event_date,
        conn
      );

      console.log("Updating activity support...");
      await ActivityModel.editActivitySupport(
        activityData.id,
        activityData.activity_support.max_donation,
        activityData.activity_support.participants,
        activityData.activity_support.attend_fee,
        activityData.activity_support.budget,
        activityData.activity_support.current_participants,
        conn
      );

      console.log("Updating activity expenses...");
      for (const expense of activityData.expenses) {
        await ActivityModel.editActivityExpense(
          expense.id,
          expense.name,
          expense.expense,
          activityData.id,
          conn
        );
      }

      console.log("Activity Image : "+ activityImage); 

      if (activityImage) {
        console.log("Updating activity media...");
        await ActivityModel.editActivityMedia(
          activityData.id,
          activityImage.buffer,
          conn
        );
      }

      console.log("reward images : " + rewardImages);

      for (const rewardImage of rewardImages) {
        const rewardData = activityData.rewards.find(
          (reward) => reward.name === rewardImage.originalname
        );
        if (rewardData) {
          await ActivityModel.editActivityReward(
            rewardData.id,
            rewardData.name,
            rewardImage.buffer,
            rewardData.description,
            activityData.id,
            conn
          );
        }
      }

      await conn.commit();
      return { success : true};
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
  
      const activities = await ActivityModel.getActivityInfo(conn, [
        {
          field: "activity_type",
          operator: "=",
          value: activity_type,
        },
        {
          field: "status",
          operator: "!=",
          value: "Success",
        },
      ]);
  
      const currentDate = new Date();
      console.log("Current Date:", currentDate);
  
      const filteredActivities = [];
  
      for (const activity of activities) {

        const dates = await ActivityModel.getActivityDate(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["end_event_date"]
        );
  
        if (dates.length > 0 && dates[0].end_event_date instanceof Date) {
          const endEventDate = dates[0].end_event_date;

          if (currentDate <= endEventDate) {
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
  
            filteredActivities.push(activity);
          } else {
            console.log("Activity ended:", activity.Id);
          }
        } else {
          console.log("No valid end event date found for activity:", activity.Id);
        }
      }
  
      await conn.commit(); // Commit transaction
      return filteredActivities;
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

  static async getHistoryActivity(status, user_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      const activities = await ActivityModel.getActivityInfo(conn, {
        field: "status",
        operator: "=",
        value: status,
      });

      const filteredActivities = [];

      for (const activity of activities) {
        const participation = await ActivityModel.getParticipationList(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["user_id"]
        );

        const isUserParticipating = participation.some(
          (record) => record.user_id === user_id
        );

        if (isUserParticipating) {
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

          filteredActivities.push(activity);
        }
      }

      await conn.commit(); // Commit transaction
      return filteredActivities;
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

  static async getOwnHistory(user_id)
  {
    let conn;
    try {
      conn = await pool.getConnection();
      await conn.beginTransaction();

      const activities = await ActivityModel.getActivityInfo(conn, {
        field: "user_id",
        operator: "=",
        value: user_id,
      }); 

      const filteredActivities = [];

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

          filteredActivities.push(activity);
        
      }

      return filteredActivities;
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

  static async getActivityCount(user_id) {
    let conn;
    try {
      conn = await pool.getConnection();

      const activity_info = await ActivityModel.getActivityInfo(conn, null, [
        "status",
        "user_id",
        "Id",
      ]);

      let counts = {
        "On-going": 0,
        Success: 0,
        Created: 0,
      };

      for (const activity of activity_info) {
        if (activity.user_id === user_id) {
          counts["Created"]++;
        }

        // if (activity.status === "On-going") {
        //   counts["On-going"]++;
        // } else if (activity.status === "Success") {
        //   counts["Success"]++;
        // }

        const participation = await ActivityModel.getParticipationList(
          conn,
          { field: "activity_id", operator: "=", value: activity.Id },
          ["user_id"]
        );

        const isUserParticipating = participation.some(
          (record) => record.user_id === user_id
        );

        if (isUserParticipating) {
          // Increment count if user is participating
          if (activity.status === "On-going") {
            counts["On-going"]++;
          } else if (activity.status === "Success") {
            counts["Success"]++;
          }
        }
      }

      return counts;
    } catch (error) {
      throw error;
    } finally {
      if (conn) {
        await conn.release();
      }
    }
  }

  static async updateActivityRating(activity_id, rating) {
    let conn;
    try {
      conn = await pool.getConnection();

      const result = await ActivityModel.updateActivityRating(
        activity_id,
        rating,
        conn
      );

      if (!result || result.affectedRows === 0) {
        throw new Error("Activity not found or rating not updated.");
      }

      return { success: true, message: "Rating updated successfully" };
    } catch (error) {
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
        [
          "start_regis_date",
          "end_regis_date",
          "start_event_date",
          "end_event_date",
        ]
      );

      const activity_media = await ActivityModel.getActivityMedia(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["activity_image"]
      );

      const activity_reward = await ActivityModel.getActivityReward(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["Id","name", "reward_image", "description"]
      );

      const activity_expense = await ActivityModel.getActivityExpense(
        conn,
        { field: "activity_id", operator: "=", value: activity_id },
        ["Id","name", "expense"]
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

  static async getRating(acitivity_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      const ratingData = await ActivityModel.getActivityRating(
        acitivity_id,
        conn
      );
      return ratingData[0].rating;
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

  static async createAttendance(activity_id, user_id) {
    let conn;
    try {
      conn = await pool.getConnection();
      conn.beginTransaction();

      const participated = false;
      const attendance = await ActivityModel.createActivityAttendance(
        activity_id,
        user_id,
        participated,
        conn,
      );
      const current_participation = await ActivityModel.updateCurrentParticipants(activity_id,conn);

      conn.commit();

      return attendance;
    } catch (error) {
      throw error;
    } finally {
      if(conn)
      {
        conn.release();
      }
    }
  }

  static async getAttendeeList(activity_id) {
    try {
      const attendees = await ActivityModel.getAttendees(activity_id);

      const userInfoList = [];

      for (const attendee of attendees) {
        const user = await UserService.showUserInfo(attendee.user_id);
        const userInfo = {
          id: attendee.user_id,
          first_name: user.first_name,
          last_name: user.last_name,
          phone: user.phone,
          isParticipated: attendee.isParticipated === 1,
        };
        userInfoList.push(userInfo);
      }

      return userInfoList;
    } catch (error) {
      throw error;
    }
  }

  static async updateAttend(activity_id, checkin_list) {
    try {
      const updateAttend = await ActivityModel.updateAttendance(
        activity_id,
        checkin_list
      );
      return updateAttend;
    } catch (error) {
      throw error;
    }
  }

  // static async editActivities(activityDetail, activity_id) {
  //   let conn;
  //   try {
  //     conn = await pool.getConnection();
  //     conn.beginTransaction();
  //     await ActivityModel.updateActivity(
  //       activityDetail.title,
  //       activityDetail.description,
  //       activity_id,
  //       conn
  //     );
  //     await ActivityModel.updateActivityLocation(
  //       activityDetail.event_location,
  //       activityDetail.meet_location,
  //       activity_id,
  //       conn
  //     );

  //     await ActivityModel.updateActivitySupport(
  //       activityDetail.max_donation,
  //       activityDetail.participants,
  //       activityDetail.attend_fee,
  //       activity_id,
  //       conn
  //     );
  //     await conn.commit();
  //     return true;
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  static async valiateParticipants(acitivity_id, user_id) {
    return await ActivityModel.validateAttendee(acitivity_id, user_id);
  }

  // static async editActivities(activityDetail, activity_id) {
  //   let conn;
  //   try {
  //     conn = await pool.getConnection();
  //     conn.beginTransaction();
  //     await ActivityModel.updateActivity(
  //       activityDetail.title,
  //       activityDetail.description,
  //       activity_id,
  //       conn
  //     );
  //     await ActivityModel.updateActivityLocation(
  //       activityDetail.event_location,
  //       activityDetail.meet_location,
  //       activity_id,
  //       conn
  //     );

  //     await ActivityModel.updateActivitySupport(
  //       activityDetail.max_donation,
  //       activityDetail.participants,
  //       activityDetail.attend_fee,
  //       activity_id,
  //       conn
  //     );
  //     await conn.commit();
  //     return true;
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  static async deleteReward(reward_id)
  {
    try {
      const deleteReward = await ActivityModel.deleteReward(reward_id);
      return true;
    } catch (error) {
      throw error;
    }
  }

  static async deleteExpense(expense_id)
  {
    try {
      const deleteExpense = await ActivityModel.deleteExpense(expense_id);
      return true;
    } catch (error) {
      throw error;
    }
  }

  static async getUserId(activity_id)
  {
    let conn;
    try {
      conn = await pool.getConnection();

      const result = await ActivityModel.getActivityInfo(conn, {field : 'Id', operator: '=', value: activity_id}, ['user_id']);

      return result[0].user_id;
    } catch (error) {
      throw error;
    } 
  }
}

module.exports = ActivityService;
