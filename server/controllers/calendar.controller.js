/**
 * Calendar Controller
 * Handles Hindu calendar and festival data
 */
const calendarService = require('../services/calendar.service');

const getFestivals = async (req, res) => {
  try {
    const { month, year } = req.query;

    // Default to current month/year if not provided
    const currentDate = new Date();
    const queryMonth = month || currentDate.getMonth() + 1;
    const queryYear = year || currentDate.getFullYear();

    const festivals = await calendarService.getFestivals(queryMonth, queryYear);

    res.json({
      success: true,
      data: festivals,
    });
  } catch (error) {
    console.error('Error fetching festivals:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch festivals',
    });
  }
};

module.exports = {
  getFestivals,
};

