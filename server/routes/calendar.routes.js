const express = require('express');
const router = express.Router();
const calendarController = require('../controllers/calendar.controller');
const { verifyToken } = require('../middleware/auth.middleware');

// All routes require authentication
router.use(verifyToken);

router.get('/festivals', calendarController.getFestivals);

module.exports = router;

