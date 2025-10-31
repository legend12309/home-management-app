const express = require('express');
const router = express.Router();
const mealPlanController = require('../controllers/mealPlan.controller');
const { verifyToken } = require('../middleware/auth.middleware');

// All routes require authentication
router.use(verifyToken);

router.post('/generate', mealPlanController.generateMealPlan);

module.exports = router;

