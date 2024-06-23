require("dotenv").config();
const jwt = require("jsonwebtoken");
const ActivityService = require("../services/activity.services");
const UserService = require("../services/user.services");

exports.createActivity = async (req, res, next) => {
  try {
    const user_id = req.user._id;
    const user_email = req.user.email;
    const activityData = JSON.parse(req.body.activityData);
    console.log("Parsed activity data:", activityData);
    const activityImage = req.files["activity_image"]
      ? req.files["activity_image"][0]
      : null;
    const rewardImages = req.files["reward_images"] || [];

    const result = await ActivityService.createActivity(
      activityData,
      user_id,
      user_email,
      activityImage,
      rewardImages
    );

    res
      .status(201)
      .json({ status: true, success: "Create Activity successfully" });
  } catch (error) {
    next(error);
  }
};

exports.getActivities = async (req, res, next) => {
  try {
    const activity_type = req.query.activity_type || "Other";
    const activities = await ActivityService.getAllActivity(activity_type);
    res.json({ status: true, success: activities });
  } catch (error) {
    next(error);
  }
};

exports.getActivity = async (req, res, next) => {
  try {
    const activity_id = req.query.activity_id;
    const userFromReqId = req.user._id;
    const activity = await ActivityService.getActivity(activity_id);
    const userId = activity.user_id;
    const user = await UserService.showUserInfo(userId);
    const isOwner = user.Id == userFromReqId;

    const body = { activity: activity, user: user };
    res.json({ status: true, success: body, is_owner: isOwner });
  } catch (error) {
    next(error);
  }
};

exports.getHistory = async (req, res, next) => {
  try {
    const status = req.query.status;
    const userId = req.user._id;
    const activities = await ActivityService.getHistoryActivity(status, userId);

    res.json({ status: true, success: activities });
  } catch (error) {
    next(error);
  }
};

exports.updateRating = async (req, res, next) => {
  try {
    const { activity_id, rating } = req.body;

    // Validate input
    if (!activity_id || !rating) {
      return res
        .status(400)
        .json({
          success: false,
          message: "Activity ID and rating are required",
        });
    }

    // Convert rating to number if it's a string
    const numericRating = parseFloat(rating);

    // Call the service method to update the rating
    const result = await ActivityService.updateActivityRating(
      activity_id,
      numericRating
    );

    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

exports.getActivityCount = async (req, res, next) => {
  try {
    const user_id = req.user._id;
    const activityStatus = await ActivityService.getActivityCount(user_id);

    res.json({ status: true, success: activityStatus });
  } catch (error) {
    next(error);
  }
};

exports.editActivity = async (req, res, next) => {
  try {
    const activity_id = req.params.activity_id; 
    const activityDetail = JSON.parse(req.body.activityData); 
    const result = await ActivityService.editActivities(activityDetail, activity_id);

    if (result) {
      res.json({ status: true, success: "Activity updated successfully" });
    } else {
      res.status(404).json({ status: false, message: "Activity not found" });
    }
  } catch (error) {
    next(error);
  }
};

exports.getRating = async (req, res, next) => {
  try {
    const acitivity_id = req.query.activity_id;
    const ratingData = await ActivityService.getRating(acitivity_id);
    res.json({ status: true, success: ratingData });
  } catch (error) {
    next(error);
  }
};

exports.updateAttend = async (req, res, next) => {
  try {
    const userId = req.user._id;
    const activity_id = req.body.activity_id;

    const user = await ActivityService.valiateParticipants(activity_id, userId);

    if(user)
    {
        throw new Error("You are already attend this activity.");
    }

    const attend = await ActivityService.updateAttendance(activity_id, userId);
    res.json({ status: true, success: "Attend activity successfully" });
  } catch (error) {
    next(error);
  }
};

exports.getAttendees = async (req, res, next) => {
  try {
    const activity_id = req.query.activity_id;

    const attendees = await ActivityService.getAttendeeList(activity_id);
    res.json({ status: true, success: attendees });
  } catch (error) {
    next(error);
  }
};

exports.checkIn = async (req, res, next) => {
  try {
    const { activity_id, checkin_list } = req.body;
    
    if (!activity_id || !checkin_list || typeof checkin_list !== 'object') {
        return res.status(400).json({ status: false, message: 'Invalid input' });
    }

    const checkinListParsed = Object.entries(checkin_list).reduce((acc, [key, value]) => {
        acc[parseInt(key, 10)] = value;
        return acc;
    }, {});

    const result = await ActivityService.updateAttend(activity_id, checkinListParsed);
    res.json({ status: true, success: result });
  } catch (error) {
    next(error);
  }
};

