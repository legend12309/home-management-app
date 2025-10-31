/**
 * Receipt Controller
 * Handles OCR-based receipt scanning and expense tracking
 */
const receiptService = require('../services/receipt.service');

const scanReceipt = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No image file provided' });
    }

    const userId = req.user.uid;
    const imageBuffer = req.file.buffer;

    // Scan receipt using OCR service
    const receiptData = await receiptService.scanReceipt(imageBuffer);

    // Save receipt data to database
    await receiptService.saveReceipt(userId, receiptData);

    res.json({
      success: true,
      data: receiptData,
    });
  } catch (error) {
    console.error('Error scanning receipt:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to scan receipt',
    });
  }
};

module.exports = {
  scanReceipt,
};

