# Shelf Snapshot App

A SwiftUI-based iOS application that allows users to take shelf photos in stores, tag them, and automatically recognize products using Vision. Data is stored locally using SwiftData.

---

## 🛠️ Build & Run Instructions

1. **Requirements**
   - Xcode 15 or later
   - iOS 17.6+ deployment target
   - Swift 5.9+
   - Compatible iPhone device (or use the simulator without camera features)

2. **Clone the Repository**
   ```bash
   git clone https://github.com/leomesou/shelf-snapshot.git
   cd shelf-snapshot
   ```

3. **Open the Project**
   - Open `ShelfSnapshot.xcodeproj` in Xcode.

4. **Run**
   - Select a target device (preferably a physical device for camera testing).
   - Hit **Run** (`⌘ + R`).

> ℹ️ If running on the simulator, camera functionality is mocked.

---

## 🧱 Architecture Overview & Design Decisions

### **MVVM Architecture**

- **Model:**  
  - `ShelfSnapshot`: Represents a captured photo and metadata (store, tags, products, etc.)
  - `RecognizedProduct`: Represents individual recognized items.

- **View:**  
  - Built entirely using **SwiftUI**.
  - Views are lightweight and reactive to model updates.

- **ViewModel:**  
  - Handles logic like image recognition, filtering, sorting, and form interactions.
  - Examples: `ShelfListViewModel`, `CameraViewModel`, `ShelfDetailViewModel`.

### **Key Features & Design Decisions**

- **SwiftData** is used for persistence, replacing Core Data with a modern, Swift-native API.
- **Vision** is used for product recognition from captured photos.
- **Custom camera UI** using `AVFoundation`, with support for:
  - Flash toggle
  - Focus and exposure control
  - Wide/ultra-wide lens switching
  - Live preview with overlays
- **Search, Sort, and Filter** capabilities for browsing captured shelf data.
- **Reusable Components** and **Modifiers** are used for consistent UI and behavior.
- **SwiftUI Animations** and Haptics enhance UX during photo capture and interactions.

---

## 📦 Frameworks & Native APIs Used

| Technology     | Purpose                                      |
|----------------|----------------------------------------------|
| **SwiftUI**    | Declarative UI framework                     |
| **SwiftData**  | Local data storage                           |
| **Vision**    | Product image recognition                    |
| **AVFoundation** | Custom camera and photo capture            |
| **Combine**    | Reactive bindings (via `@Published`, etc.)  |
| **Foundation** | Date, UUID, and base model types            |
| **UIKit** (via `UIViewRepresentable`) | Camera preview layer integration |

> ✅ No third-party libraries are used.

---


## ✨ Future Enhancements

- Generate reports
- Combine Vision with Core ML for better results
- More detailed product metadata and storage
- Add tests
