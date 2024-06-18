const express = require('express');
const cors = require('cors');
const body_parser = require('body-parser');
const userRouter = require('./routers/user.routes');
const activityRouter = require('./routers/activity.routes');

const app = express();
app.use(cors())
app.use(body_parser.json());
app.use('/', userRouter);
app.use('/activity', activityRouter);

module.exports = app;