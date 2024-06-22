const express = require("express");
const ActivityController = require("../controller/activity.controller");
const authenticateToken = require("../middleware/authenticateToken");
const upload = require("../configuration/upload");
const error = require("../middleware/error");

const router = express.Router();


router.get("/", authenticateToken, ActivityController.getActivities, error);
router.get("/activity-details", authenticateToken, ActivityController.getActivity, error);
router.get("/history" , authenticateToken , ActivityController.getHistory, error);
router.get("/activity-count", authenticateToken , ActivityController.getActivityCount, error);

router.post(
  "/create-activity",
  authenticateToken,
  upload.fields([
    { name: "activity_image", maxCount: 1 },
    { name: "reward_images", maxCount: 10 },
  ]),
  ActivityController.createActivity,
  error
);

router.patch("/edit-activity" , authenticateToken , ActivityController.editActivity, error);

module.exports = router;
