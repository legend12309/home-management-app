# 🚀 Backend Deployment Guide

## Overview
Deploy your Node.js backend to production so your Flutter app can use the API.

---

## 🎯 Deployment Options

### Option 1: Heroku (Easiest - Free)

**Pros:** Free tier, easy setup, automatic HTTPS
**Cons:** Sleeps after 30 min inactivity

#### Steps:

1. **Create Heroku Account**
   → https://www.heroku.com

2. **Install Heroku CLI**
   → https://devcenter.heroku.com/articles/heroku-cli

3. **Prepare for Deployment**
   
   Create `Procfile` in `server/` folder:
   ```
   web: node server.js
   ```

4. **Deploy**
   ```bash
   cd server
   heroku login
   heroku create gharsethu-api
   git init
   git add .
   git commit -m "Initial backend deployment"
   git push heroku main
   ```

5. **Set Environment Variables**
   ```bash
   heroku config:set FIREBASE_PROJECT_ID=your-project-id
   heroku config:set PORT=5000
   heroku config:set MONGODB_URI=your-mongo-uri
   ```

6. **Upload Service Account**
   ```bash
   heroku config:set FIREBASE_SERVICE_ACCOUNT="$(cat config/serviceAccountKey.json)"
   ```

7. **Done!** Your backend is live at: `https://gharsethu-api.herokuapp.com`

---

### Option 2: Railway (Simple - Free/Paid)

**Pros:** Modern, good free tier, easy MongoDB
**Cons:** Credit card required for free tier

#### Steps:

1. **Sign up:** https://railway.app

2. **New Project** → **Deploy from GitHub**

3. **Connect Repository:**
   - Select `home-management-app`
   - Root directory: `server/`

4. **Configure:**
   - Build command: `npm install`
   - Start command: `node server.js`
   - Port: `5000`

5. **Add Environment Variables:**
   - `FIREBASE_PROJECT_ID`
   - `PORT=5000`
   - `MONGODB_URI`
   - `FIREBASE_SERVICE_ACCOUNT` (paste JSON content)

6. **Deploy!** Railway auto-deploys on push!

---

### Option 3: Render (Free Tier - Easy)

**Pros:** Good free tier, simple setup
**Cons:** Free tier is limited

#### Steps:

1. **Sign up:** https://render.com

2. **New → Web Service**

3. **Connect GitHub:**
   - Select `home-management-app`
   - Root: `server/`

4. **Configure:**
   - Build: `npm install`
   - Start: `node server.js`

5. **Add Environment Variables** (same as above)

6. **Deploy!**

---

### Option 4: Google Cloud Run (Scalable)

**Pros:** Scales automatically, pay-per-use
**Cons:** Setup more complex

#### Steps:

1. **Install gcloud CLI**
2. **Create Dockerfile** in `server/`:
   ```dockerfile
   FROM node:18
   WORKDIR /app
   COPY package*.json ./
   RUN npm install
   COPY . .
   EXPOSE 5000
   CMD ["node", "server.js"]
   ```

3. **Deploy:**
   ```bash
   gcloud run deploy gharsethu-api \
     --source . \
     --region us-central1 \
     --allow-unauthenticated
   ```

---

### Option 5: MongoDB Atlas Setup (Required for Production)

All backends need a MongoDB database:

1. **Sign up:** https://www.mongodb.com/cloud/atlas

2. **Create Cluster** (Free M0 tier)

3. **Create Database User:**
   - Username & password
   - Save credentials!

4. **Whitelist IP:**
   - Add `0.0.0.0/0` (allows all - for development)
   - Or add specific IPs for production

5. **Get Connection String:**
   - Atlas → Connect → Connect your application
   - Copy the connection string
   - Replace `<password>` with your password

6. **Add to Environment Variables:**
   ```
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/gharsethu
   ```

---

## 🔧 Update Flutter App

After deploying backend, update API URL:

1. Open `lib/core/api/api_client.dart`
2. Find base URL
3. Replace with your deployed URL:
   ```dart
   static const String baseUrl = 'https://your-backend-url.com/api';
   ```

---

## ✅ Deployment Checklist

- [ ] Backend deployed to hosting service
- [ ] MongoDB Atlas database created
- [ ] Environment variables set
- [ ] Service account uploaded
- [ ] API accessible via HTTPS
- [ ] Flutter app updated with new URL
- [ ] Health check endpoint works
- [ ] All features tested

---

## 🧪 Test Your Deployment

1. **Health Check:**
   ```bash
   curl https://your-backend-url.com/health
   ```

2. **Should return:**
   ```json
   {"status":"OK","message":"Gharsethu API is running"}
   ```

---

## 🎯 Recommended Setup

For starting out:
1. **Backend:** Heroku or Railway (easy)
2. **Database:** MongoDB Atlas (free tier)
3. **Firebase:** Already set up
4. **Test:** Using Postman or curl

For production scale:
1. **Backend:** Google Cloud Run or AWS
2. **Database:** MongoDB Atlas (paid tier)
3. **CDN:** CloudFlare
4. **Monitoring:** Sentry

---

## 📚 Next Steps

After deployment:
1. Test all API endpoints
2. Monitor logs
3. Set up error tracking
4. Configure analytics
5. Launch!

---

**Need Help?** Check logs in your hosting platform's dashboard!

