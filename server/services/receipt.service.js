/**
 * Receipt Service
 * Handles OCR scanning and expense tracking
 */
const admin = require('../config/firebase-admin');
const fs = require('fs');
const path = require('path');
const axios = require('axios');

/**
 * Scan receipt using OCR
 * TODO: Integrate with Google Vision AI or similar OCR service
 */
const scanReceipt = async (imageBuffer) => {
  try {
    // TODO: Upload to Firebase Storage first
    // TODO: Then call Google Vision API for OCR
    // For now, return mock data

    const mockReceiptData = {
      storeName: 'Big Bazaar',
      date: new Date().toISOString(),
      total: 1245.50,
      items: [
        { name: 'Basmati Rice 5kg', price: 450, quantity: 1 },
        { name: 'Turmeric Powder 200g', price: 80, quantity: 1 },
        { name: 'Tomatoes 1kg', price: 45, quantity: 1 },
        { name: 'Onions 2kg', price: 70, quantity: 1 },
      ],
      paymentMethod: 'UPI',
    };

    return mockReceiptData;
  } catch (error) {
    console.error('Error scanning receipt:', error);
    throw error;
  }
};

/**
 * Save receipt data to Firestore
 */
const saveReceipt = async (userId, receiptData) => {
  try {
    const db = admin.firestore();
    
    const receiptDoc = {
      ...receiptData,
      userId,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await db.collection('receipts').add(receiptDoc);
    
    // Update budget/expenses
    await updateExpenses(userId, receiptData.total);
  } catch (error) {
    console.error('Error saving receipt:', error);
    throw error;
  }
};

/**
 * Update monthly expenses
 */
const updateExpenses = async (userId, amount) => {
  try {
    const db = admin.firestore();
    const now = new Date();
    const monthKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;

    const expenseRef = db
      .collection('expenses')
      .doc(`${userId}_${monthKey}`);

    await expenseRef.set(
      {
        userId,
        month: monthKey,
        total: admin.firestore.FieldValue.increment(amount),
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
  } catch (error) {
    console.error('Error updating expenses:', error);
  }
};

module.exports = {
  scanReceipt,
  saveReceipt,
  updateExpenses,
};

