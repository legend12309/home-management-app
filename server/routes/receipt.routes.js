const express = require('express');
const router = express.Router();
const multer = require('multer');
const receiptController = require('../controllers/receipt.controller');
const { verifyToken } = require('../middleware/auth.middleware');

const upload = multer({ storage: multer.memoryStorage() });

// All routes require authentication
router.use(verifyToken);

router.post('/scan', upload.single('image'), receiptController.scanReceipt);

module.exports = router;

