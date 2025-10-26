# MVVM Architecture Guidelines for SwiftData + CloudKit Projects

## Core MVVM Principles for SwiftData & CloudKit

When working on SwiftData and CloudKit projects, ALWAYS follow these MVVM architecture rules with special considerations for persistence and cloud sync:

---

## 1. MODEL Layer Rules (SwiftData Models)

### What SwiftData Models Should Do:
- **Use `@Model` macro** for SwiftData persistence
- **Pure data structures** - Properties and relationships only
- **Conform to protocols**: `Codable` (optional for CloudKit sync)
- **Define relationships** - Use `@Relationship` for one-to-many, many-to-many
- **Use CloudKit-compatible types** - String, Int, Double, Date, Data, Bool, UUID
- **Add computed properties** for derived data (not persisted)

### What SwiftData Models Should NOT Do:
- ❌ No business logic methods
- ❌ No network calls or CloudKit operations
- ❌ No ModelContext operations (fetching, saving, deleting)
- ❌ No `@Published` properties (SwiftData models are already observable)
- ❌ No UI-related code

### CloudKit Sync Considerations:
- Use `UUID()` for unique identifiers (CloudKit-friendly)
- Avoid complex nested types (CloudKit has type limitations)
- Use `@Attribute(.unique)` for unique constraints
- Use `@Relationship(deleteRule: .cascade)` for parent-child relationships

### Example:
```swift
// ✅ GOOD - SwiftData Model with CloudKit sync
import SwiftData
import Foundation

@Model
final class AlarmModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var body: String
    var time: Date
    var isEnabled: Bool
    var repeatDays: [Int]  // CloudKit-compatible array
    var soundName: String

    @Relationship(deleteRule: .cascade, inverse: \AlarmCategory.alarms)
    var category: AlarmCategory?

    // Computed property (not persisted)
    var formattedTime: String {
        time.formatted(date: .omitted, time: .shortened)
    }

    init(title: String, body: String, time: Date, isEnabled: Bool = false) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.time = time
        self.isEnabled = isEnabled
        self.repeatDays = []
        self.soundName = "default"
    }
}

@Model
final class AlarmCategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var colorHex: String

    @Relationship(deleteRule: .nullify)
    var alarms: [AlarmModel]?

    init(name: String, colorHex: String) {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
    }
}

// ❌ BAD - Business logic in model
@Model
final class AlarmModel {
    var title: String
    var time: Date

    func save() {  // ❌ NO! This belongs in Repository
        modelContext?.save()
    }

    func scheduleNotification() {  // ❌ NO! This belongs in Service
        // notification code
    }
}
```

---

## 2. VIEW Layer Rules

### What Views Should Do:
- **Display data only** - Render UI based on ViewModel state
- **Forward user actions** - Call ViewModel methods
- **Use @Query for read-only lists** - SwiftData's reactive query
- **Use @EnvironmentObject for ViewModels** - Access shared state
- **Keep it simple** - Extract complex UI to components

### SwiftData Query Usage:
- Use `@Query` ONLY for **read-only list displays**
- Use ViewModel for **create, update, delete operations**
- Sort and filter via `@Query` parameters when possible

### What Views Should NOT Do:
- ❌ No business logic
- ❌ No ModelContext operations (insert, delete, save)
- ❌ No CloudKit operations
- ❌ No direct model mutations (use ViewModel)
- ❌ No `@State` for SwiftData models (models are already observable)

### Example:
```swift
// ✅ GOOD - View with @Query for display, ViewModel for mutations
struct AlarmListView: View {
    @Query(sort: \AlarmModel.time) private var alarms: [AlarmModel]
    @EnvironmentObject var viewModel: AlarmViewModel
    @State private var isShowingAddSheet = false  // ✅ Local UI state

    var body: some View {
        List {
            ForEach(alarms) { alarm in
                AlarmRow(alarm: alarm)
            }
            .onDelete { indexSet in
                viewModel.deleteAlarms(at: indexSet, from: alarms)  // ✅ Delegate to ViewModel
            }
        }
        .toolbar {
            Button("Add") {
                isShowingAddSheet = true
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddAlarmView()
        }
        .onAppear {
            viewModel.syncWithCloudKit()  // ✅ Trigger sync
        }
    }
}

// ❌ BAD - Direct ModelContext usage in View
struct AlarmListView: View {
    @Query private var alarms: [AlarmModel]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            ForEach(alarms) { alarm in
                AlarmRow(alarm: alarm)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    modelContext.delete(alarms[index])  // ❌ NO! Use ViewModel
                }
                try? modelContext.save()  // ❌ NO!
            }
        }
    }
}
```

---

## 3. VIEWMODEL Layer Rules

### What ViewModels Should Do:
- **Conform to `ObservableObject`**
- **Use `@Published` for UI state** (loading, error messages, etc.)
- **Inject ModelContext via Dependency Injection**
- **Handle CRUD operations** via Repository pattern
- **Orchestrate CloudKit sync** via Service layer
- **Transform data** for View consumption
- **Be UI-independent** - Testable without SwiftUI

### What ViewModels Should NOT Do:
- ❌ No direct ModelContext.save() calls (use Repository)
- ❌ No direct CloudKit operations (use Service)
- ❌ No SwiftUI View code
- ❌ No @Query usage (that's for Views)

### Example:
```swift
// ✅ GOOD - Proper ViewModel with SwiftData + CloudKit
@MainActor
class AlarmViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?

    private let repository: AlarmRepositoryProtocol
    private let cloudKitService: CloudKitServiceProtocol
    private let notificationService: NotificationServiceProtocol

    init(
        repository: AlarmRepositoryProtocol,
        cloudKitService: CloudKitServiceProtocol = CloudKitService(),
        notificationService: NotificationServiceProtocol = NotificationService()
    ) {
        self.repository = repository
        self.cloudKitService = cloudKitService
        self.notificationService = notificationService
    }

    func addAlarm(title: String, body: String, time: Date) {
        isLoading = true
        errorMessage = nil

        let alarm = AlarmModel(title: title, body: body, time: time, isEnabled: true)

        do {
            try repository.insert(alarm)
            notificationService.schedule(for: alarm)
            isLoading = false
        } catch {
            errorMessage = "Failed to add alarm: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func deleteAlarms(at indexSet: IndexSet, from alarms: [AlarmModel]) {
        for index in indexSet {
            let alarm = alarms[index]
            notificationService.cancel(for: alarm)
            repository.delete(alarm)
        }
    }

    func toggleAlarm(_ alarm: AlarmModel) {
        alarm.isEnabled.toggle()
        repository.update(alarm)

        if alarm.isEnabled {
            notificationService.schedule(for: alarm)
        } else {
            notificationService.cancel(for: alarm)
        }
    }

    func syncWithCloudKit() {
        Task {
            isSyncing = true
            do {
                try await cloudKitService.syncAlarms()
                lastSyncDate = Date()
                isSyncing = false
            } catch {
                errorMessage = "Sync failed: \(error.localizedDescription)"
                isSyncing = false
            }
        }
    }
}

// ❌ BAD - Direct ModelContext usage, no separation of concerns
class AlarmViewModel: ObservableObject {
    @Published var alarms: [AlarmModel] = []
    private var modelContext: ModelContext  // ❌ Should use Repository

    func addAlarm(_ alarm: AlarmModel) {
        modelContext.insert(alarm)  // ❌ NO! Use Repository
        try? modelContext.save()  // ❌ NO!

        // CloudKit code here  // ❌ NO! Use Service
        CKContainer.default().publicCloudDatabase.save(...)
    }
}
```

---

## 4. REPOSITORY Pattern (SwiftData Layer)

### Purpose:
- **Encapsulate all ModelContext operations**
- **Provide clean API** for CRUD operations
- **Handle SwiftData errors** gracefully
- **Make code testable** via protocol abstraction

### Example:
```swift
// ✅ GOOD - Repository Pattern
protocol AlarmRepositoryProtocol {
    func insert(_ alarm: AlarmModel) throws
    func delete(_ alarm: AlarmModel)
    func update(_ alarm: AlarmModel)
    func fetch(predicate: Predicate<AlarmModel>?, sort: [SortDescriptor<AlarmModel>]) -> [AlarmModel]
}

class AlarmRepository: AlarmRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func insert(_ alarm: AlarmModel) throws {
        modelContext.insert(alarm)
        try modelContext.save()
    }

    func delete(_ alarm: AlarmModel) {
        modelContext.delete(alarm)
        try? modelContext.save()
    }

    func update(_ alarm: AlarmModel) {
        // SwiftData auto-saves changes to @Model objects
        // But you can explicitly save if needed
        try? modelContext.save()
    }

    func fetch(
        predicate: Predicate<AlarmModel>? = nil,
        sort: [SortDescriptor<AlarmModel>] = []
    ) -> [AlarmModel] {
        let descriptor = FetchDescriptor<AlarmModel>(
            predicate: predicate,
            sortBy: sort
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
}

// For testing - Mock Repository
class MockAlarmRepository: AlarmRepositoryProtocol {
    var alarms: [AlarmModel] = []

    func insert(_ alarm: AlarmModel) throws {
        alarms.append(alarm)
    }

    func delete(_ alarm: AlarmModel) {
        alarms.removeAll { $0.id == alarm.id }
    }

    func update(_ alarm: AlarmModel) {
        // Mock update
    }

    func fetch(predicate: Predicate<AlarmModel>?, sort: [SortDescriptor<AlarmModel>]) -> [AlarmModel] {
        return alarms
    }
}
```

---

## 5. SERVICE Pattern (CloudKit + Other Services)

### Purpose:
- **Encapsulate CloudKit operations**
- **Handle iCloud sync logic**
- **Manage network state**
- **Provide protocol for testing**

### Example:
```swift
// ✅ GOOD - CloudKit Service
protocol CloudKitServiceProtocol {
    func syncAlarms() async throws
    func uploadAlarm(_ alarm: AlarmModel) async throws
    func deleteAlarmFromCloud(_ alarmID: UUID) async throws
    func checkAccountStatus() async -> Bool
}

class CloudKitService: CloudKitServiceProtocol {
    private let container = CKContainer.default()
    private let database: CKDatabase

    init() {
        self.database = container.publicCloudDatabase  // or privateCloudDatabase
    }

    func checkAccountStatus() async -> Bool {
        do {
            let status = try await container.accountStatus()
            return status == .available
        } catch {
            print("CloudKit account status error: \(error)")
            return false
        }
    }

    func syncAlarms() async throws {
        // Implement sync logic
        // Fetch from CloudKit, compare with local, merge
    }

    func uploadAlarm(_ alarm: AlarmModel) async throws {
        let record = CKRecord(recordType: "Alarm")
        record["id"] = alarm.id.uuidString
        record["title"] = alarm.title
        record["body"] = alarm.body
        record["time"] = alarm.time
        record["isEnabled"] = alarm.isEnabled

        try await database.save(record)
    }

    func deleteAlarmFromCloud(_ alarmID: UUID) async throws {
        let recordID = CKRecord.ID(recordName: alarmID.uuidString)
        try await database.deleteRecord(withID: recordID)
    }
}

// ✅ GOOD - Notification Service
protocol NotificationServiceProtocol {
    func schedule(for alarm: AlarmModel)
    func cancel(for alarm: AlarmModel)
    func requestAuthorization() async throws -> Bool
}

class NotificationService: NotificationServiceProtocol {
    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func schedule(for alarm: AlarmModel) {
        let content = UNMutableNotificationContent()
        content.title = alarm.title
        content.body = alarm.body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(alarm.soundName))

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: alarm.id.uuidString,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func cancel(for alarm: AlarmModel) {
        center.removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
    }
}
```

---

## 6. Dependency Injection & App Setup

### SwiftData Container Setup:
```swift
// ✅ GOOD - Proper App setup with DI
import SwiftUI
import SwiftData

@main
struct AlarmApp: App {
    let modelContainer: ModelContainer
    let alarmViewModel: AlarmViewModel

    init() {
        do {
            // Configure SwiftData with CloudKit sync
            let schema = Schema([AlarmModel.self, AlarmCategory.self])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic  // Enable CloudKit sync
            )
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            // Setup Repository and ViewModel with DI
            let modelContext = modelContainer.mainContext
            let repository = AlarmRepository(modelContext: modelContext)
            let cloudKitService = CloudKitService()
            let notificationService = NotificationService()

            alarmViewModel = AlarmViewModel(
                repository: repository,
                cloudKitService: cloudKitService,
                notificationService: notificationService
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(alarmViewModel)
        }
        .modelContainer(modelContainer)
    }
}

// ❌ BAD - No DI, hard-coded dependencies
@main
struct AlarmApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: AlarmModel.self)  // ❌ ViewModel can't access repository
    }
}
```

---

## 7. File Organization

```
AlarmApp/
├── Models/
│   ├── AlarmModel.swift
│   └── AlarmCategory.swift
├── ViewModels/
│   ├── AlarmViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Screens/
│   │   ├── AlarmListView.swift
│   │   ├── AddAlarmView.swift
│   │   └── SettingsView.swift
│   └── Components/
│       ├── AlarmRow.swift
│       └── TimePickerView.swift
├── Repositories/
│   ├── AlarmRepository.swift
│   └── Protocols/
│       └── AlarmRepositoryProtocol.swift
├── Services/
│   ├── CloudKitService.swift
│   ├── NotificationService.swift
│   └── Protocols/
│       ├── CloudKitServiceProtocol.swift
│       └── NotificationServiceProtocol.swift
└── App/
    └── AlarmApp.swift
```

---

## 8. Common Mistakes to Avoid

### ❌ Mistake 1: Using ModelContext Directly in Views
```swift
// ❌ BAD
struct AlarmListView: View {
    @Environment(\.modelContext) private var modelContext

    func addAlarm() {
        modelContext.insert(alarm)  // ❌ NO!
        try? modelContext.save()
    }
}

// ✅ GOOD
struct AlarmListView: View {
    @EnvironmentObject var viewModel: AlarmViewModel

    func addAlarm() {
        viewModel.addAlarm(title: "Wake Up", body: "Time to start!", time: Date())
    }
}
```

### ❌ Mistake 2: CloudKit Code in ViewModel
```swift
// ❌ BAD
class AlarmViewModel: ObservableObject {
    func syncWithCloud() {
        CKContainer.default().publicCloudDatabase.fetch(...)  // ❌ NO!
    }
}

// ✅ GOOD
class AlarmViewModel: ObservableObject {
    private let cloudKitService: CloudKitServiceProtocol

    func syncWithCloud() async {
        try? await cloudKitService.syncAlarms()  // ✅ YES!
    }
}
```

### ❌ Mistake 3: Not Using @Query in Views
```swift
// ❌ BAD - Fetching in ViewModel, passing to View
class AlarmViewModel: ObservableObject {
    @Published var alarms: [AlarmModel] = []

    func loadAlarms() {
        alarms = repository.fetchAll()  // ❌ Unnecessary!
    }
}

// ✅ GOOD - Use @Query for reactive lists
struct AlarmListView: View {
    @Query(sort: \AlarmModel.time) var alarms: [AlarmModel]  // ✅ Automatic updates
    @EnvironmentObject var viewModel: AlarmViewModel
}
```

### ❌ Mistake 4: Not Using CloudKit-Compatible Types
```swift
// ❌ BAD - Custom types won't sync
@Model
class AlarmModel {
    var customColor: MyCustomColor  // ❌ CloudKit doesn't support this
    var soundSettings: SoundSettings  // ❌ Complex nested type
}

// ✅ GOOD - CloudKit-compatible types
@Model
class AlarmModel {
    var colorHex: String  // ✅ Store as String
    var soundName: String  // ✅ Simple type
    var volume: Double  // ✅ Supported type
}
```

---

## 9. Testing Strategy

### ViewModel Testing:
```swift
class AlarmViewModelTests: XCTestCase {
    func testAddAlarm() async {
        let mockRepository = MockAlarmRepository()
        let mockCloudKit = MockCloudKitService()
        let mockNotification = MockNotificationService()

        let viewModel = AlarmViewModel(
            repository: mockRepository,
            cloudKitService: mockCloudKit,
            notificationService: mockNotification
        )

        viewModel.addAlarm(title: "Test", body: "Test Body", time: Date())

        XCTAssertEqual(mockRepository.alarms.count, 1)
        XCTAssertEqual(mockNotification.scheduledCount, 1)
        XCTAssertFalse(viewModel.isLoading)
    }
}
```

### Repository Testing:
```swift
class AlarmRepositoryTests: XCTestCase {
    var modelContainer: ModelContainer!
    var repository: AlarmRepository!

    override func setUp() async throws {
        let schema = Schema([AlarmModel.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [config])
        repository = AlarmRepository(modelContext: modelContainer.mainContext)
    }

    func testInsertAlarm() throws {
        let alarm = AlarmModel(title: "Test", body: "Test", time: Date())
        try repository.insert(alarm)

        let fetched = repository.fetch()
        XCTAssertEqual(fetched.count, 1)
    }
}
```

---

## 10. CloudKit Sync Best Practices

### Sync Strategy:
1. **Use CloudKit's automatic sync** when possible (via `.modelContainer`)
2. **Manual sync for conflict resolution** when needed
3. **Handle network errors gracefully** with retry logic
4. **Show sync status to users** (syncing, last sync time, errors)
5. **Test with multiple devices** to ensure sync works

### Conflict Resolution:
```swift
// Example: Last-write-wins strategy
func resolveConflict(local: AlarmModel, remote: CKRecord) -> AlarmModel {
    let localModified = local.modifiedDate ?? Date.distantPast
    let remoteModified = remote.modificationDate ?? Date.distantPast

    if remoteModified > localModified {
        // Use remote version
        return AlarmModel(from: remote)
    } else {
        // Keep local version
        return local
    }
}
```

---

## 11. Code Review Checklist

Before finishing any task, verify:

- [ ] Models use `@Model` macro and CloudKit-compatible types
- [ ] Views use `@Query` for display, ViewModel for mutations
- [ ] ViewModels use Repository for data operations
- [ ] ViewModels use Services for CloudKit and notifications
- [ ] No ModelContext usage in Views or ViewModels
- [ ] No CloudKit code in Views or ViewModels
- [ ] Dependencies are injected via protocols
- [ ] CloudKit sync is configured in ModelConfiguration
- [ ] Relationships use proper deleteRule
- [ ] Error handling for network and persistence errors
- [ ] @State used ONLY for local UI state
- [ ] No business logic in Views or Models

---

## Summary

**Golden Rules for SwiftData + CloudKit:**
- **Models** = @Model data with CloudKit-compatible types
- **Views** = @Query for display + ViewModel for mutations
- **ViewModels** = Orchestrate Repository + Services
- **Repository** = All ModelContext operations
- **Services** = CloudKit sync + Notifications + Other APIs

**Data Flow:**
```
View → ViewModel → Repository → SwiftData → CloudKit
     ↘ ViewModel → Service → CloudKit/Notifications
```

**Testing Question:**
"Can I test this without SwiftData/CloudKit running?"
- If YES → ViewModel (with mocks)
- If NO → View or Integration test

Keep it simple, keep it separated, keep it synced.
