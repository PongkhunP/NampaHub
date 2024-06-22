require('dotenv').config();
const jwt = require('jsonwebtoken');
const ActivityService = require('../services/activity.services');
const UserService = require('../services/user.services');

exports.createActivity = async (req, res, next) => {
    try {
        const user_id = req.user._id;
        const user_email = req.user.email;
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
        // const userId = req.user._id;
        const activity = await ActivityService.getActivity(activity_id);
        const userId = activity.user_id;
        const user = await UserService.showUserInfo(userId);
        
        const body = {activity : activity , user : user};
        res.json({status : true, success : body});
    } catch (error) {
        next(error);
    }
};

exports.getHistory = async (req, res, next) => {
    try {
        const status = req.query.status;
        const activities = await ActivityService.getHistoryActivity(status);

        res.json({status : true , success : activities});
    } catch (error) {
        next(error);
    }
}

exports.getActivityCount = async (req, res, next) => {
    try {
        const user_id = req.user._id;
        const activityStatus = await ActivityService.getActivityCount(user_id);

        res.json({status : true , success : activityStatus});
    } catch (error) {
        next(error);
    }
}

exports.editActivity = async (req, res, next) => {
    try {
        
    } catch (error) {
        next(error);
    }
}