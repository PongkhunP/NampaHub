const express = require("express");
const ActivityController = require("../controller/activity.controller");
const authenticateToken = require("../middleware/authenticateToken");
const upload = require("../configuration/upload");
const error = require("../middleware/error");

const router = express.Router();

// Existing routes
router.get("/", authenticateToken, ActivityController.getActivities, error);
router.get("/activity-details", authenticateToken, ActivityController.getActivity, error);
router.get("/history" , authenticateToken , ActivityController.getHistory, error);
router.get("/activity-count", authenticateToken , ActivityController.getActivityCount, error);
router.get("/rating", authenticateToken , ActivityController.getRating, error);
router.get("/attendee-list", authenticateToken , ActivityController.getAttendees , error);


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
router.post("/attend", authenticateToken, ActivityController.updateAttend,error);

router.patch("/edit-activity" , authenticateToken , ActivityController.editActivity, error);
router.patch("/check-in" , authenticateToken , ActivityController.checkIn, error);
router.patch("/update-rating", authenticateToken, ActivityController.updateRating, error);

module.exports = router;