require('dotenv').config();
const jwt = require('jsonwebtoken');
const ActivityService = require('../services/activity.services');

exports.createActivity = async (req, res, next) => {
    try {
        const user_id = req.user._id;
        const user_email = req.user.email;
        console.log("User id: " + user_id);
        console.log("User_email: " + user_email);
        const activityData = JSON.parse(req.body.activityData);
        console.log('Parsed activity data:', activityData);
        const activityImage = req.files['activity_image'] ? req.files['activity_image'][0] : null;
        const rewardImages = req.files['reward_images'] || [];

        const result = await ActivityService.createActivity(activityData, user_id, user_email, activityImage, rewardImages);

        res.status(201).json({status : true, success : "Create Activity successfully"});
    } catch (error) {
        next(error);
    }
};

exports.getActivities = async (req, res, next) => {
    try {
        const activity_type = req.query.activity_type || 'Other';
        const activities = await ActivityService.getAllActivity(activity_type);
        res.json({status : true, success : activities});
    } catch (error) {
        next(error);
    }
};

exports.getActivity = async (req, res, next) => {
    try {
        const activity_id = req.query.activity_id;
        const activity = await ActivityService.getActivity(activity_id);
        res.json({status : true, success : activity});
    } catch (error) {
        next(error);
    }
};