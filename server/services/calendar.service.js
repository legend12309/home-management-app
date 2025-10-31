/**
 * Calendar Service
 * Fetches Hindu calendar and festival data
 */
const axios = require('axios');

const HINDU_CALENDAR_API_BASE_URL = 'https://api.calendar-in-india.com/v1/calendar';

const getFestivals = async (month, year) => {
  try {
    // TODO: Integrate with actual Hindu Calendar API
    // For now, return mock data
    
    const mockFestivals = [
      {
        name: 'Diwali',
        date: '2025-11-01',
        type: 'major',
        description: 'Festival of Lights',
        region: 'All India',
      },
      {
        name: 'Dussehra',
        date: '2025-10-15',
        type: 'major',
        description: 'Victory of Good over Evil',
        region: 'North & Central India',
      },
      {
        name: 'Krishna Janmashtami',
        date: '2025-09-07',
        type: 'major',
        description: 'Birth of Lord Krishna',
        region: 'All India',
      },
    ];

    return mockFestivals.filter(festival => {
      const festivalMonth = new Date(festival.date).getMonth() + 1;
      return festivalMonth === parseInt(month);
    });
  } catch (error) {
    console.error('Error fetching festivals:', error);
    throw error;
  }
};

module.exports = {
  getFestivals,
};

