/**
 * Meal Plan Controller
 * Handles AI-powered meal plan generation
 */
const mealPlanService = require('../services/mealPlan.service');

const generateMealPlan = async (req, res) => {
  try {
    const { dietType, festival, preferences, familySize } = req.body;
    const userId = req.user.uid;

    // Validate input
    if (!dietType) {
      return res.status(400).json({ error: 'Diet type is required' });
    }

    // Generate meal plan
    const mealPlan = await mealPlanService.generateMealPlan({
      userId,
      dietType,
      festival,
      preferences: preferences || [],
      familySize: familySize || 4,
    });

    res.json({
      success: true,
      data: mealPlan,
    });
  } catch (error) {
    console.error('Error generating meal plan:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to generate meal plan',
    });
  }
};

module.exports = {
  generateMealPlan,
};

