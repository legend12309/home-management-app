# Aapli Ghar Backend API

Backend API for the Aapli Ghar smart home management application.

## Tech Stack

- Node.js with Express.js
- MongoDB with Mongoose
- Firebase Admin SDK
- Multer for file uploads

## Setup Instructions

1. Install dependencies:
```bash
npm install
```

2. Configure environment variables:
   - Copy `.env.example` to `.env`
   - Fill in all required environment variables

3. Configure Firebase Admin:
   - Download `serviceAccountKey.json` from Firebase Console
   - Place it in the `config/` directory
   - Copy `serviceAccountKey.json.example` as a reference

4. Start the development server:
```bash
npm run dev
```

5. Start the production server:
```bash
npm start
```

## API Endpoints

### Health Check
- `GET /health` - Check API status

### Meal Planning
- `POST /api/v1/mealplan/generate` - Generate AI-powered meal plan
  - Headers: `Authorization: Bearer <firebase-id-token>`
  - Body: `{ dietType, festival, preferences, familySize }`

### Calendar
- `GET /api/v1/calendar/festivals` - Get festivals for a month
  - Headers: `Authorization: Bearer <firebase-id-token>`
  - Query params: `month`, `year`

### Receipt Scanning
- `POST /api/v1/receipt/scan` - Scan and extract receipt data
  - Headers: `Authorization: Bearer <firebase-id-token>`
  - Body: `multipart/form-data` with `image` file

## Authentication

All endpoints (except `/health`) require Firebase Authentication. Include the Firebase ID token in the Authorization header:

```
Authorization: Bearer <firebase-id-token>
```

## Testing

To test the API endpoints, use tools like Postman or curl. Make sure to include the Firebase ID token in your requests.

## Deployment

The backend can be deployed to:
- Google Cloud Run
- Heroku
- AWS Elastic Beanstalk
- Azure App Service

Make sure to configure environment variables in your hosting platform.

