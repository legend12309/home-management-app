const admin = require('../config/firebase-admin');

/**
 * Middleware to verify Firebase ID Token
 */
const verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Unauthorized: No token provided' });
    }

    const idToken = authHeader.split('Bearer ')[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);

    req.user = {
      uid: decodedToken.uid,
      email: decodedToken.email,
    };

    next();
  } catch (error) {
    console.error('Token verification error:', error);
    return res.status(401).json({ error: 'Unauthorized: Invalid token' });
  }
};

/**
 * Middleware to check if user has admin role
 * Requires verifyToken to be called first
 */
const checkAdmin = async (req, res, next) => {
  try {
    // TODO: Implement role check by fetching user data from Firestore
    // For now, we'll allow all authenticated users
    // In production, fetch from Firestore and check role === 'admin'
    next();
  } catch (error) {
    console.error('Admin check error:', error);
    return res.status(403).json({ error: 'Forbidden: Admin access required' });
  }
};

module.exports = {
  verifyToken,
  checkAdmin,
};

