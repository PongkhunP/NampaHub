const express = require("express");
const ActivityController = require("../controller/activity.controller");
const authenticateToken = require("../middleware/authenticateToken");
const upload = require("../configuration/upload");

const router = express.Router();

router.post(
  "/create-activity",
  authenticateToken,
  upload.fields([
    { name: "activity_image", maxCount: 1 },
    { name: "reward_images", maxCount: 10 },
  ]),
  ActivityController.createActivity
);

router.get("/", authenticateToken, ActivityController.getActivities);
router.get("/activity-details", authenticateToken, ActivityController.getActivity);

module.exports = router;
