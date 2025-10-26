# MVVM Architecture Guidelines for iOS/SwiftUI Projects

## Core MVVM Principles

When working on this project, ALWAYS follow these MVVM (Model-View-ViewModel) architecture rules:

---

## 1. MODEL Layer Rules

### What Models Should Do:
- **Pure data structures** - Only properties and computed properties
- **Conform to protocols**: `Codable`, `Identifiable`, `Equatable` where needed
- **No business logic** - No methods that change state
- **No UI dependencies** - Never import SwiftUI or UIKit

### What Models Should NOT Do:
- ❌ No network calls
- ❌ No database operations
- ❌ No notification scheduling
- ❌ No UI-related code
- ❌ No `@Published` or `@State` properties

### Example:
```swift
// ✅ GOOD - Pure data model
struct AlarmModel: Identifiable, Codable {
    let id: UUID
    let title: String
    let time: Date
    var isEnabled: Bool

    var formattedTime: String {
        // Computed property OK
        time.formatted()
    }
}

// ❌ BAD - Business logic in model
struct AlarmModel {
    var alarms: [Alarm]

    func save() {  // ❌ NO!
        UserDefaults.save(self)
    }
}
```

---

## 2. VIEW Layer Rules

### What Views Should Do:
- **Display data only** - Render UI based on ViewModel state
- **Forward user actions** - Call ViewModel methods on button taps, etc.
- **Use @EnvironmentObject or @ObservedObject** - Subscribe to ViewModel
- **Keep it simple** - Extract complex UI to separate View components

### What Views Should NOT Do:
- ❌ No business logic
- ❌ No data persistence (UserDefaults, CoreData, etc.)
- ❌ No network calls
- ❌ No direct Model manipulation
- ❌ No `@State` for shared data (use ViewModel instead)

### Rules for @State vs ViewModel:
- Use `@State` ONLY for **local UI state** (sheet presentation, animation, selection)
- Use ViewModel for **shared data** and **business data**

### Example:
```swift
// ✅ GOOD - View only displays and forwards actions
struct AlarmListView: View {
    @EnvironmentObject var viewModel: AlarmViewModel
    @State private var isShowingAddSheet = false  // ✅ Local UI state

    var body: some View {
        List(viewModel.alarms) { alarm in
            AlarmRow(alarm: alarm)
        }
        .onAppear {
            viewModel.loadAlarms()  // ✅ Forward to ViewModel
        }
        Button("Add") {
            isShowingAddSheet = true  // ✅ Local UI state
        }
    }
}

// ❌ BAD - Business logic in View
struct AlarmListView: View {
    @State private var alarms: [Alarm] = []

    var body: some View {
        Button("Save") {
            UserDefaults.save(alarms)  // ❌ NO! This is ViewModel's job
        }
    }
}
```

---

## 3. VIEWMODEL Layer Rules

### What ViewModels Should Do:
- **Conform to `ObservableObject`**
- **Use `@Published` for state** that Views observe
- **Contain all business logic**
- **Handle data persistence** (UserDefaults, CoreData, etc.)
- **Handle network calls**
- **Transform Model data** for View consumption
- **Be UI-independent** - Should work without SwiftUI/UIKit

### Naming Convention:
- Name ViewModels clearly: `AlarmViewModel`, `SettingsViewModel`
- NOT: `Manager`, `Service`, `Helper` (unless they're not ViewModels)

### What ViewModels Should NOT Do:
- ❌ No SwiftUI View code
- ❌ No direct UI manipulation
- ❌ No navigation logic (use Coordinator pattern if needed)

### Example:
```swift
// ✅ GOOD - Proper ViewModel
@MainActor
class AlarmViewModel: ObservableObject {
    @Published var alarms: [AlarmModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: AlarmRepository

    init(repository: AlarmRepository = AlarmRepository()) {
        self.repository = repository
    }

    func loadAlarms() {
        isLoading = true
        alarms = repository.fetchAlarms()
        isLoading = false
    }

    func addAlarm(_ alarm: AlarmModel) {
        alarms.append(alarm)
        repository.save(alarms)
    }

    func deleteAlarm(at index: Int) {
        alarms.remove(at: index)
        repository.save(alarms)
    }
}

// ❌ BAD - Too much responsibility or wrong naming
class LocalNotificationManager: ObservableObject {
    @Published var alarms: [Alarm] = []
    @Published var settings: Settings = Settings()  // ❌ Multiple responsibilities
    @Published var userProfile: User?  // ❌ Mixing concerns

    func scheduleNotification() { }
    func saveToDatabase() { }
    func fetchFromAPI() { }
    func updateUI() { }  // ❌ ViewModel should not update UI directly
}
```

---

## 4. Dependency Injection

### Always use Dependency Injection for testability:

```swift
// ✅ GOOD - Testable with DI
class AlarmViewModel: ObservableObject {
    private let repository: AlarmRepositoryProtocol
    private let notificationService: NotificationServiceProtocol

    init(
        repository: AlarmRepositoryProtocol = AlarmRepository(),
        notificationService: NotificationServiceProtocol = NotificationService()
    ) {
        self.repository = repository
        self.notificationService = notificationService
    }
}

// ❌ BAD - Hard to test
class AlarmViewModel: ObservableObject {
    let userDefaults = UserDefaults.standard  // ❌ Hard-coded dependency
    let notificationCenter = UNUserNotificationCenter.current()  // ❌ Hard-coded
}
```

---

## 5. File Organization

```
ProjectName/
├── Models/
│   ├── AlarmModel.swift
│   └── TimeModel.swift
├── ViewModels/
│   ├── AlarmViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Screens/
│   │   ├── AlarmListView.swift
│   │   └── AddAlarmView.swift
│   └── Components/
│       ├── AlarmRow.swift
│       └── TimePickerView.swift
├── Services/
│   ├── NotificationService.swift
│   └── PersistenceService.swift
└── Repositories/
    └── AlarmRepository.swift
```

---

## 6. Common Mistakes to Avoid

### ❌ Mistake 1: Manager Classes Instead of ViewModels
```swift
// ❌ BAD
class LocalNotificationManager: ObservableObject { }

// ✅ GOOD
class AlarmViewModel: ObservableObject { }
```

### ❌ Mistake 2: Business Logic in Views
```swift
// ❌ BAD
Button("Save") {
    UserDefaults.standard.set(alarm, forKey: "alarm")
    scheduleNotification(for: alarm)
}

// ✅ GOOD
Button("Save") {
    viewModel.saveAlarm(alarm)
}
```

### ❌ Mistake 3: Multiple Responsibilities
```swift
// ❌ BAD - One ViewModel doing everything
class AppViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    @Published var settings: Settings = Settings()
    @Published var userProfile: User?
}

// ✅ GOOD - Separate ViewModels
class AlarmViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
}

class SettingsViewModel: ObservableObject {
    @Published var settings: Settings = Settings()
}
```

### ❌ Mistake 4: Mixing @State and @Published for Same Data
```swift
// ❌ BAD
struct AlarmView: View {
    @EnvironmentObject var viewModel: AlarmViewModel
    @State var alarms: [Alarm] = []  // ❌ Duplicate state!
}

// ✅ GOOD
struct AlarmView: View {
    @EnvironmentObject var viewModel: AlarmViewModel
    // Use viewModel.alarms directly
}
```

---

## 7. Code Review Checklist

Before finishing any task, verify:

- [ ] Models contain ONLY data structures (no business logic)
- [ ] Views contain ONLY UI code (no business logic)
- [ ] ViewModels contain ALL business logic
- [ ] ViewModels are named `*ViewModel`, not `*Manager` or `*Service`
- [ ] @Published properties are in ViewModels, not Views
- [ ] @State is used ONLY for local UI state
- [ ] Dependencies are injected, not hard-coded
- [ ] Each ViewModel has single responsibility
- [ ] No SwiftUI imports in Models or ViewModels
- [ ] No business logic in Views

---

## 8. When Working with Claude Code

When I (Claude Code) suggest code changes:

1. **Always ask**: "Which layer does this belong to?" (Model/View/ViewModel)
2. **Reject suggestions** that violate MVVM principles
3. **Request refactoring** if I put business logic in Views
4. **Remind me** to use ViewModels instead of Manager classes

---

## 9. Testing Strategy

```swift
// ✅ ViewModels should be easily testable
class AlarmViewModelTests: XCTestCase {
    func testAddAlarm() {
        let mockRepository = MockAlarmRepository()
        let viewModel = AlarmViewModel(repository: mockRepository)

        let alarm = AlarmModel(title: "Test")
        viewModel.addAlarm(alarm)

        XCTAssertEqual(viewModel.alarms.count, 1)
    }
}
```

---

## Summary

**Golden Rule**:
- **Models** = Data
- **Views** = Display + Forward Actions
- **ViewModels** = Business Logic + State Management

If you're unsure, ask: "Can I test this without a UI?"
- If YES → ViewModel
- If NO → View

Keep it simple, keep it separated, keep it testable.
