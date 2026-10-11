# Contributing to Mahder Mobile

First off, thank you for considering contributing to Mahder Mobile! It's people like you that make Mahder Mobile such a great tool.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Project Structure](#project-structure)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: 3.5.0 or higher
- **Dart SDK**: 3.5.0 or higher
- **Git**: Latest version
- **Android Studio** or **Xcode** (depending on your target platform)
- **VS Code** or **Android Studio** (recommended IDEs)

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   # Replace YOUR_GITHUB_USERNAME with your GitHub account name
   git clone https://github.com/YOUR_GITHUB_USERNAME/hyperdata-mobile.git
   cd hyperdata-mobile
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/iCog-Labs-Dev/hyperdata-mobile.git
   ```

### Environment Setup

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Configure environment variables**:
   ```bash
   cp .env.example .env
   ```

   Edit `.env` with your configuration. See [docs/SETUP.md](docs/SETUP.md) for details.

3. **Verify setup**:
   ```bash
   flutter doctor
   flutter run
   ```

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs **actual behavior**
- **Screenshots** (if applicable)
- **Environment details** (OS, Flutter version, device)
- **Error logs** or stack traces

**Bug Report Template**:

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
 - Device: [e.g. iPhone 12, Samsung Galaxy S21]
 - OS: [e.g. iOS 15.0, Android 12]
 - Flutter Version: [e.g. 3.5.0]
 - App Version: [e.g. 1.0.0]

**Additional context**
Any other context about the problem.
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description**
- **Use case** - why is this enhancement needed?
- **Proposed solution** - how should it work?
- **Alternatives considered**
- **Additional context** - mockups, examples, etc.

### Your First Code Contribution

Unsure where to begin? Look for issues labeled:

- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `beginner friendly` - Easy to tackle

### Pull Requests

1. **Create a branch** for your feature:
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make your changes** following our [coding standards](#coding-standards)

3. **Test your changes** thoroughly

4. **Commit your changes** following our [commit guidelines](#commit-guidelines)

5. **Push to your fork**:
   ```bash
   git push origin feature/amazing-feature
   ```

6. **Open a Pull Request** on GitHub

## Development Setup

### Project Structure

```
hyperdata-mobile/
├── lib/
│   ├── core/              # Core functionality
│   │   ├── api/           # API client
│   │   ├── cache/         # Cache management
│   │   ├── localization/  # i18n
│   │   ├── services/      # Services
│   │   ├── theme/         # Theming
│   │   ├── utils/         # Utilities
│   │   └── widgets/       # Reusable widgets
│   ├── features/          # Feature modules
│   │   ├── auth/          # Authentication
│   │   ├── home/          # Home & tasks
│   │   ├── notification/  # Notifications
│   │   └── profile/       # User profile
│   ├── routes/            # Navigation
│   └── main.dart          # Entry point
├── assets/                # Images, fonts, etc.
├── test/                  # Tests
└── docs/                  # Documentation
```

### Running the App

```bash
# Development mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>

# With flavor (if configured)
flutter run --flavor dev
```

### Hot Reload

While the app is running, press:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit

## Coding Standards

### Dart Style Guide

Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:

- Use `lowerCamelCase` for variables, methods, and parameters
- Use `UpperCamelCase` for classes and types
- Use `lowercase_with_underscores` for libraries and file names
- Use `SCREAMING_CAPS` for constants

### Code Formatting

```bash
# Format all Dart files
dart format .

# Format specific file
dart format lib/main.dart

# Check formatting
dart format --set-exit-if-changed .
```

### Linting

```bash
# Run analyzer
flutter analyze

# Fix auto-fixable issues
dart fix --apply
```

### Architecture Guidelines

#### Clean Architecture

Follow the clean architecture pattern:

```
Feature/
├── data/
│   ├── datasources/    # Remote/Local data sources
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business logic
└── presentation/
    ├── controllers/    # State management
    ├── pages/          # Screens
    └── widgets/        # UI components
```

#### State Management

- Use **GetX** for state management
- Keep controllers focused and single-purpose
- Use reactive programming with `.obs` and `Obx()`
- Dispose resources properly in `onClose()`

#### Naming Conventions

**Files**:
- `snake_case.dart` for all Dart files
- `feature_name_page.dart` for pages
- `feature_name_controller.dart` for controllers
- `feature_name_widget.dart` for widgets

**Classes**:
- `FeatureNamePage` for pages
- `FeatureNameController` for controllers
- `FeatureNameWidget` for widgets
- `FeatureNameModel` for models
- `FeatureNameEntity` for entities

**Variables**:
```dart
// Good
final userName = 'John';
final isLoading = false.obs;
final userList = <User>[].obs;

// Bad
final user_name = 'John';
final loading = false.obs;
final list = <User>[].obs;
```

### Code Quality

#### Comments

```dart
// Good - Explain WHY, not WHAT
// Retry failed requests up to 3 times to handle network issues
final maxRetries = 3;

// Bad - Obvious comment
// Set max retries to 3
final maxRetries = 3;
```

#### Documentation

Use dartdoc comments for public APIs:

```dart
/// Fetches user data from the API.
///
/// Returns a [User] object if successful, or throws a [NetworkException]
/// if the request fails.
///
/// Example:
/// ```dart
/// final user = await fetchUser('123');
/// ```
Future<User> fetchUser(String userId) async {
  // Implementation
}
```

#### Error Handling

```dart
// Good - Specific error handling
try {
  final result = await apiClient.fetchData();
  return Right(result);
} on DioException catch (e) {
  return Left(NetworkFailure(e.message));
} catch (e) {
  return Left(UnknownFailure(e.toString()));
}

// Bad - Generic error handling
try {
  final result = await apiClient.fetchData();
  return result;
} catch (e) {
  print(e);
  return null;
}
```

### Widget Guidelines

#### Stateless vs Stateful

- Prefer `StatelessWidget` when possible
- Use `StatefulWidget` only when you need lifecycle methods
- Use GetX controllers for state management instead of `setState()`

#### Widget Composition

```dart
// Good - Small, focused widgets
class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildAvatar(),
          _buildName(),
          _buildEmail(),
        ],
      ),
    );
  }

  Widget _buildAvatar() => CircleAvatar(/* ... */);
  Widget _buildName() => Text(user.name);
  Widget _buildEmail() => Text(user.email);
}

// Bad - Large, monolithic widget
class UserCard extends StatelessWidget {
  // 200+ lines of build method
}
```

#### Performance

- Use `const` constructors when possible
- Avoid rebuilding entire widget trees
- Use `ListView.builder` for long lists
- Implement `shouldRebuild` for custom widgets
- Cache expensive computations

## Commit Guidelines

### Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `build`: Build system changes

#### Examples

```bash
# Feature
feat(auth): add biometric authentication

# Bug fix
fix(home): resolve task list refresh issue

# Documentation
docs(readme): update installation instructions

# Refactoring
refactor(api): simplify error handling logic

# Performance
perf(home): optimize task list rendering

# Breaking change
feat(api)!: change authentication flow

BREAKING CHANGE: Authentication now requires email verification
```

### Commit Best Practices

- Write clear, concise commit messages
- Use present tense ("add feature" not "added feature")
- Limit subject line to 50 characters
- Separate subject from body with blank line
- Wrap body at 72 characters
- Reference issues and PRs in footer

## Pull Request Process

### Before Submitting

1. **Update your branch** with latest upstream:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run tests**:
   ```bash
   flutter test
   ```

3. **Run analyzer**:
   ```bash
   flutter analyze
   ```

4. **Format code**:
   ```bash
   dart format .
   ```

5. **Update documentation** if needed

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests pass locally

## Screenshots (if applicable)
Add screenshots here

## Related Issues
Closes #123
```

### Review Process

1. **Automated checks** must pass (CI/CD)
2. **Code review** by at least one maintainer
3. **Address feedback** and update PR
4. **Approval** from maintainer
5. **Merge** by maintainer

### After Merge

1. **Delete your branch**:
   ```bash
   git branch -d feature/amazing-feature
   git push origin --delete feature/amazing-feature
   ```

2. **Update your fork**:
   ```bash
   git checkout main
   git pull upstream main
   git push origin main
   ```

## Testing Guidelines

### Unit Tests

```dart
// test/unit/user_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('should create user from JSON', () {
      final json = {'id': '1', 'name': 'John'};
      final user = User.fromJson(json);

      expect(user.id, '1');
      expect(user.name, 'John');
    });
  });
}
```

### Widget Tests

```dart
// test/widget/login_page_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login page shows email field', (tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });
}
```

### Integration Tests

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete login flow', (tester) async {
    // Test implementation
  });
}
```

### Running Tests

```bash
# All tests
flutter test

# Specific test
flutter test test/unit/user_test.dart

# With coverage
flutter test --coverage

# Integration tests
flutter test integration_test/
```

## Documentation

### Code Documentation

- Document all public APIs
- Use dartdoc comments (`///`)
- Include examples for complex functions
- Keep documentation up to date

### Project Documentation

When adding features, update:

- `README.md` - If it affects getting started
- Feature-specific docs in root directory
- API documentation if applicable
- Architecture diagrams if structure changes

### Documentation Style

```dart
/// Authenticates a user with email and password.
///
/// Throws [AuthException] if authentication fails.
/// Returns [User] object on success.
///
/// Example:
/// ```dart
/// final user = await authService.login(
///   email: 'user@example.com',
///   password: 'password123',
/// );
/// ```
Future<User> login({
  required String email,
  required String password,
}) async {
  // Implementation
}
```

## Questions?

- Check existing [documentation](README.md#documentation)
- Search [existing issues](https://github.com/mahder-opensource-platform/mahder-mobile/issues)
- Ask in [discussions](https://github.com/mahder-opensource-platform/mahder-mobile/discussions)
- Contact maintainers

## Recognition

Contributors will be recognized in release notes and project documentation.

Thank you for contributing to Mahder Mobile! 🎉

---

**Happy Coding!** 💻
