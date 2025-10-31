# Aapli Ghar - Architecture Documentation

## Overview

Aapli Ghar is built using a modern, scalable architecture that separates concerns and promotes maintainability. The application uses a hybrid backend approach combining Firebase for real-time features and a custom Node.js backend for complex business logic.

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Mobile App                    │
│  ┌────────────────────────────────────────────────────┐ │
│  │              Presentation Layer                     │ │
│  │  - Screens, Widgets, Theme                         │ │
│  └────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────┐ │
│  │              Business Logic Layer                   │ │
│  │  - Cubits/BLoCs, State Management                  │ │
│  └────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────┐ │
│  │              Data Layer                             │ │
│  │  - Repositories, API Clients, Models               │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
                        │
                        │
        ┌───────────────┴───────────────┐
        │                               │
┌───────▼────────┐            ┌────────▼────────┐
│   Firebase     │            │  Custom Backend │
│   Backend      │            │   (Node.js)     │
├────────────────┤            ├─────────────────┤
│ - Auth         │            │ - AI Services   │
│ - Firestore    │            │ - OCR Scanning  │
│ - Storage      │            │ - API Gateway   │
│ - Functions    │            │ - Business Logic│
└────────────────┘            └─────────────────┘
```

## Frontend Architecture

### State Management Pattern (BLoC)

```
UI Layer (Screens/Widgets)
    ↓
Business Logic Layer (Cubits/BLoCs)
    ↓
Data Layer (Repositories)
    ↓
API/Services
```

**Benefits:**
- Clear separation of concerns
- Testable business logic
- Predictable state flow
- Reusable UI components

### Feature-Driven Structure

Each feature is self-contained with its own:
- **data/**: Data sources and repositories
- **presentation/cubit/**: State management
- **presentation/widgets/**: Feature-specific UI components
- **presentation/screens/**: Top-level screens

**Features:**
1. `auth/` - Authentication and user management
2. `grocery_management/` - Grocery lists and pantry
3. `meal_planning/` - Meal planning and recipes
4. `chores/` - Task management
5. `budget/` - Financial tracking
6. `festivals/` - Calendar and events

### Dependency Injection

Using `get_it` for service location and dependency injection:

```dart
// Register dependencies
getIt.registerSingleton<AuthRepository>(AuthRepository());
getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
```

## Backend Architecture

### Hybrid Approach

**Firebase (Real-Time Features):**
- User authentication
- Real-time data sync (groceries, chores)
- Image storage
- Push notifications

**Custom Node.js API (Business Logic):**
- AI meal planning
- OCR receipt scanning
- Festival calendar integration
- Complex data processing

### API Design

**RESTful Architecture:**
- Clear resource-based URLs
- Standard HTTP methods (GET, POST, PUT, DELETE)
- JSON request/response format
- Consistent error handling

**Authentication:**
- Firebase ID tokens for all requests
- Token verification middleware
- Role-based access control

**API Structure:**
```
/api/v1/
  ├── mealplan/
  │   └── generate
  ├── calendar/
  │   └── festivals
  └── receipt/
      └── scan
```

## Database Design

### Firestore Schema

```javascript
families/
  {familyId}/
    ├── familyName: string
    ├── adminId: string
    ├── members: array<string>
    ├── inviteCode: string
    ├── pantry: array<object>
    ├── groceryLists: map<object>
    └── chores: array<object>

users/
  {userId}/
    ├── email: string
    ├── name: string
    ├── familyId: string
    ├── role: string (admin/member)
    ├── createdAt: timestamp
    └── lastLoginAt: timestamp

recipes/
  {recipeId}/
    ├── title: string
    ├── region: string
    ├── isVegetarian: boolean
    ├── uploadedBy: string
    ├── familyId: string
    └── ingredients: array<object>

receipts/
  {receiptId}/
    ├── userId: string
    ├── storeName: string
    ├── date: timestamp
    ├── total: number
    ├── items: array<object>
    └── createdAt: timestamp

expenses/
  {userId}_YYYY-MM/
    ├── userId: string
    ├── month: string
    ├── total: number
    └── lastUpdated: timestamp
```

### MongoDB Schema (Future Use)

For analytics and complex queries:
```javascript
{
  userId: ObjectId,
  date: Date,
  category: String,
  amount: Number,
  metadata: Object
}
```

## Security

### Authentication Flow

1. User signs in via Firebase Auth
2. Client receives Firebase ID token
3. Token sent in Authorization header for all API requests
4. Backend verifies token with Firebase Admin SDK
5. User role checked from Firestore
6. Access granted/denied based on role

### Data Security

- Firestore security rules for read/write permissions
- Encrypted data in transit (HTTPS)
- Input validation on backend
- SQL injection protection (MongoDB drivers)

## Performance Optimization

### Frontend
- Lazy loading of features
- Image caching
- Efficient state management
- Widget optimization

### Backend
- Connection pooling (MongoDB)
- Caching frequently accessed data
- Efficient queries
- Load balancing for scaling

## Deployment Strategy

### Mobile App
- **Android**: Google Play Store
- **iOS**: App Store
- Continuous delivery with CI/CD

### Backend
- **Firebase**: Automatic scaling
- **Node.js API**: 
  - Google Cloud Run (recommended)
  - Heroku
  - AWS Elastic Beanstalk

## Testing Strategy

### Frontend
- Unit tests for business logic (Cubits)
- Widget tests for UI components
- Integration tests for user flows

### Backend
- Unit tests for services
- Integration tests for API endpoints
- E2E tests for critical paths

## Monitoring & Analytics

- Firebase Analytics for user behavior
- Crashlytics for error tracking
- Performance monitoring
- Custom logging for API calls

## Future Enhancements

1. **Microservices**: Split backend into smaller services
2. **GraphQL**: Alternative to REST for complex queries
3. **Real-time Sync**: WebSocket for live updates
4. **Offline Support**: Local database with sync
5. **Multi-language**: i18n support for regional languages

## Scalability Considerations

### Current Architecture
- Supports ~10,000 concurrent users
- Firestore handles vertical scaling
- Node.js API on single instance

### Scaling Path
1. Horizontal scaling of Node.js API
2. Database replication and sharding
3. CDN for static assets
4. Redis for caching
5. Message queues for async processing

