# Contributing to Aapli Ghar

Thank you for your interest in contributing to Aapli Ghar! We welcome contributions from everyone.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:

1. **Clear title** describing the bug
2. **Steps to reproduce** the issue
3. **Expected behavior** vs actual behavior
4. **Screenshots** if applicable
5. **Environment details** (OS, device, Flutter version)

### Suggesting Features

Feature suggestions are welcome! Please create an issue with:

1. **Clear description** of the feature
2. **Use case** explaining why it's useful
3. **Mockups** or examples if possible

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Write/update tests
5. Ensure all tests pass
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## Development Guidelines

### Code Style

**Flutter/Dart:**
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Format code: `flutter format lib`

**JavaScript/Node.js:**
- Follow [JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use ESLint for linting
- Run `npm run lint` before committing

### Commit Messages

Use clear, descriptive commit messages:

```
feat: Add grocery list filtering
fix: Resolve authentication token expiry issue
docs: Update setup instructions
refactor: Optimize database queries
test: Add unit tests for auth cubit
```

### Branch Naming

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Adding/updating tests

## Testing

### Frontend Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/auth/auth_test.dart

# Generate coverage report
flutter test --coverage
```

### Backend Tests

```bash
cd server

# Run all tests
npm test

# Run specific test
npm test -- auth.test.js
```

## Code Review Process

1. At least one maintainer must approve
2. All CI checks must pass
3. Code must be properly tested
4. Documentation must be updated

## Questions?

Open an issue or contact the maintainers.

Thank you for contributing! 🎉

