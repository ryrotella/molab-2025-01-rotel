import SwiftUI
import SceneKit
import RealityKit
import RoomPlan
import QuickLook

// Helper for QuickLook preview
class PreviewController {
    static let shared = PreviewController()
    
    var previewItems: [PreviewItem] = []
    private var previewController = QLPreviewController()
    
    func present() {
        previewController.dataSource = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(previewController, animated: true)
        }
    }
}

extension PreviewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItems.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItems[index]
    }
}

// QuickLook preview item
class PreviewItem: NSObject, QLPreviewItem {
    // The QLPreviewItem protocol requires these exact property names
    var previewItemURL: URL!  // This must be non-optional
    var previewItemTitle: String?
    
    init(url: URL, title: String? = nil) {
        self.previewItemURL = url
        self.previewItemTitle = title
        super.init()
    }
}


struct RoomDetailView: View {
    @EnvironmentObject var dataStore: RoomDataStore
    @State var room: RoomModel
    @State private var selectedAnnotation: Annotation?
    @State private var showingAnnotationEditor = false
    @State private var newAnnotationText = ""
    @State private var annotationColor: AnnotationColor = .yellow
    @State private var showingExportOptions = false
    @State private var isInAnnotationMode = false
    
    // Add this state property to track annotations to delete
    @State private var annotationToDelete: UUID? = nil
    
    @State private var isEditingTitle = false
    @State private var newRoomTitle = ""
    
    @State private var showCameraDebug = false
    @State private var cameraOffsetX: Double = 1.2
    @State private var cameraOffsetY: Double = 0.8
    @State private var cameraOffsetZ: Double = 1.2
    
    var body: some View {
        VStack {
            // 3D Room View
            ZStack {
                RoomModelView(room: $room,
                              selectedAnnotation: $selectedAnnotation,
                              isInAnnotationMode: $isInAnnotationMode,
                              annotationToDelete: $annotationToDelete,
                              onTapToAddAnnotation: { position in
                                  addAnnotation(at: position)
                              }
                    )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
                if isInAnnotationMode {
                    VStack {
                        Text("Tap to place annotation")
                            .font(.headline)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Spacer()
                        
                        // Color picker for annotation
                        HStack {
                            ForEach(AnnotationColor.allCases, id: \.self) { color in
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(color == annotationColor ? Color.white : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        annotationColor = color
                                    }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(15)
                    }
                    .padding()
                }
                // Add camera controls in the bottom right
                    VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CameraControlView(
                            onMoveUp: { NotificationCenter.default.post(name: .cameraMovedUp, object: nil) },
                            onMoveDown: { NotificationCenter.default.post(name: .cameraMovedDown, object: nil) },
                            onMoveLeft: { NotificationCenter.default.post(name: .cameraMovedLeft, object: nil) },
                            onMoveRight: { NotificationCenter.default.post(name: .cameraMovedRight, object: nil) },
                            onMoveForward: { NotificationCenter.default.post(name: .cameraMovedForward, object: nil) },
                            onMoveBackward: { NotificationCenter.default.post(name: .cameraMovedBackward, object: nil) },
                            onReset: { NotificationCenter.default.post(name: .cameraReset, object: nil) }
                        )
                    }
                }
            
                
            }
            
            // Annotation List
            VStack {
                HStack {
                    Text("Annotations (\(room.annotations.count))")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        isInAnnotationMode.toggle()
                    }) {
                        Label(isInAnnotationMode ? "Cancel" : "Add", systemImage: isInAnnotationMode ? "xmark" : "plus")
                    }
                }
                .padding(.horizontal)
                
                if room.annotations.isEmpty {
                    Text("No annotations yet")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(room.annotations) { annotation in
                            VStack(alignment: .leading) {
                                HStack {
                                    Circle()
                                        .fill(annotation.color.color)
                                        .frame(width: 16, height: 16)
                                    
                                    Text(annotation.text)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                    
                                    // Edit button - with explicitly separated action and view
                                   Button(action: {
                                       print("Edit button tapped for annotation: \(annotation.id)")
                                       selectedAnnotation = annotation
                                       newAnnotationText = annotation.text
                                       annotationColor = annotation.color
                                       showingAnnotationEditor = true
                                   }) {
                                       label: do {
                                           Text("Edit")
                                               .padding(.horizontal, 8)
                                               .padding(.vertical, 4)
                                               .background(Color.blue)
                                               .foregroundColor(.white)
                                               .cornerRadius(4)
                                       }
                                   }
                                   .buttonStyle(PlainButtonStyle()) // Ensure button style doesn't interfere
                                    
                                    // Delete button - with explicitly separated action and view
                                    Button( action: {
                                        // Set up an alert to confirm deletion
                                        selectedAnnotation = annotation
                                        // Show alert asking for confirmation
                                        let alert = UIAlertController(
                                            title: "Delete Annotation",
                                            message: "Are you sure you want to delete this annotation?",
                                            preferredStyle: .alert
                                        )
                                        
                                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                                            deleteAnnotation(annotation)
                                        })
                                        
                                        // Present the alert
                                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                           let rootVC = windowScene.windows.first?.rootViewController {
                                            rootVC.present(alert, animated: true)
                                        }
                                    }){
                                    label: do {
                                        Text("Delete")
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                    }
                                    }
                                    .buttonStyle(PlainButtonStyle()) // Ensure button style doesn't interfere

                                }
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    // Just navigate to the annotation when the row is tapped
                                    selectedAnnotation = annotation
                                    NotificationCenter.default.post(
                                        name: .annotationSelected,
                                        object: nil,
                                        userInfo: ["annotationId": annotation.id]
                                    )
                                }
                            }
                        }
                        if showCameraDebug {
                            VStack {
                                Text("Camera Offset Tuning")
                                    .font(.headline)
                                
                                HStack {
                                    Text("X: \(cameraOffsetX, specifier: "%.1f")")
                                    Slider(value: $cameraOffsetX, in: 0.1...3.0)
                                }
                                
                                HStack {
                                    Text("Y: \(cameraOffsetY, specifier: "%.1f")")
                                    Slider(value: $cameraOffsetY, in: 0.1...3.0)
                                }
                                
                                HStack {
                                    Text("Z: \(cameraOffsetZ, specifier: "%.1f")")
                                    Slider(value: $cameraOffsetZ, in: 0.1...3.0)
                                }
                                
                                Button("Test Position") {
                                    if let annotation = selectedAnnotation {
                                        // Pass the current offset values to the navigate function
                                        NotificationCenter.default.post(
                                            name: .annotationSelected,
                                            object: nil,
                                            userInfo: [
                                                "annotationId": annotation.id,
                                                "offsetX": cameraOffsetX,
                                                "offsetY": cameraOffsetY,
                                                "offsetZ": cameraOffsetZ
                                            ]
                                        )
                                    }
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .padding()
                        }
                    }
                    .frame(height: 150)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
            if isEditingTitle {
                TextField("Room Name", text: $newRoomTitle, onCommit: {
                    saveRoomTitle()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
            } else {
                Text(room.name)
                    .font(.headline)
                    .onTapGesture {
                        newRoomTitle = room.name
                        isEditingTitle = true
                    }
            }
        }
            ToolbarItem(placement: .navigationBarTrailing) {
            if isEditingTitle {
                Button("Save") {
                    saveRoomTitle()
                }
            } else {
                // Your existing export button
                Button(action: {
                    showingExportOptions = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
            // Add edit title button
         ToolbarItem(placement: .navigationBarTrailing) {
             if !isEditingTitle {
                 Button(action: {
                     newRoomTitle = room.name
                     isEditingTitle = true
                 }) {
                     Image(systemName: "pencil")
                 }
             }
         }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showCameraDebug.toggle()
                }) {
                    Image(systemName: "camera.metering.center.weighted")
                }
            }
     }
        .sheet(isPresented: $showingAnnotationEditor) {
            annotationEditorView
        }
        .actionSheet(isPresented: $showingExportOptions) {
            ActionSheet(title: Text("Export Options"), buttons: [
                .default(Text("Preview USDZ")) {
                    previewUSDZ()
                },
                .default(Text("Share USDZ")) {
                    shareUSDZ()
                },
                .default(Text("Export Annotations as Text")) {
                    exportAnnotationsAsText()
                },
                .cancel()
            ])
        }
    }
    
    private func saveRoomTitle() {
           // Only update if the title changed
           if !newRoomTitle.isEmpty && newRoomTitle != room.name {
               room.name = newRoomTitle
               dataStore.updateRoom(room)
           }
           isEditingTitle = false
       }
    
    private var annotationEditorView: some View {
        NavigationView {
            Form {
                Section(header: Text("Annotation Text")) {
                    TextEditor(text: $newAnnotationText)
                        .frame(height: 100)
                }
                
                Section(header: Text("Color")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                        ForEach(AnnotationColor.allCases, id: \.self) { color in
                            Circle()
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(color == annotationColor ? Color.blue : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    annotationColor = color
                                }
                        }
                    }
                }
            }
            .navigationTitle("Edit Annotation")
            .navigationBarItems(
                leading: Button("Cancel") {
                    // Just dismiss the editor without making changes
                    showingAnnotationEditor = false
                },
                trailing: Button("Save") {
                    if let selected = selectedAnnotation {
                        updateAnnotation(selected)
                    }
                    showingAnnotationEditor = false
                }
            )
        }
    }
    
    // Add a new annotation at the specified position
    func addAnnotation(at position: SIMD3<Float>) {
        let annotation = Annotation(
            text: "New Annotation",
            color: annotationColor,
            position: position
        )
        
        room.annotations.append(annotation)
        dataStore.updateRoom(room)
        
        // Start editing the new annotation
        selectedAnnotation = annotation
        newAnnotationText = annotation.text
        showingAnnotationEditor = true
        
        // Exit annotation mode
        isInAnnotationMode = false
    }
    
    //something wrong here
    // Update an existing annotation
    func updateAnnotation(_ annotation: Annotation) {
        guard let index = room.annotations.firstIndex(where: { $0.id == annotation.id }) else {
               print("Error: Could not find annotation to update")
               return
           }
           
       // Create an updated copy of the annotation
       var updatedAnnotation = room.annotations[index]
       updatedAnnotation.text = newAnnotationText
       updatedAnnotation.color = annotationColor
       
       // Update the annotation in the array
       room.annotations[index] = updatedAnnotation
       
       // Update the room in the data store
       dataStore.updateRoom(room)
       
       // Update the selected annotation reference
       selectedAnnotation = updatedAnnotation
        
    // Notify observers that an annotation was updated
        NotificationCenter.default.post(
            name: .annotationUpdated,
            object: nil,
            userInfo: ["annotationId": annotation.id, "newText": newAnnotationText]
        )
       
       print("Successfully updated annotation: \(updatedAnnotation.text)")
    }
    
    // Delete an annotation
    func deleteAnnotation(_ annotation: Annotation) {
        print("Deleting annotation with ID: \(annotation.id)")
        
        // Set the annotation to delete first
        annotationToDelete = annotation.id
        
        // Remove from the annotations array
        room.annotations.removeAll(where: { $0.id == annotation.id })
        
        // Update the room in the data store
        dataStore.updateRoom(room)
        
        // Clear selected annotation if it was the one deleted
        if selectedAnnotation?.id == annotation.id {
            selectedAnnotation = nil
        }
        
        // Notify that an annotation was deleted
           NotificationCenter.default.post(
               name: .annotationDeleted,
               object: nil,
               userInfo: ["annotationId": annotation.id]
           )
        
        print("Annotation deleted. Remaining count: \(room.annotations.count)")
    }
    // Preview the USDZ file
    func previewUSDZ() {
        guard let usdzPath = room.usdzFilePath else { return }
        
        let previewItem = PreviewItem(url: usdzPath)
        PreviewController.shared.previewItems = [previewItem]
        PreviewController.shared.present()
    }
    
    // Share the USDZ file
    func shareUSDZ() {
        guard let usdzPath = room.usdzFilePath else { return }
        
        let activityVC = UIActivityViewController(activityItems: [usdzPath], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    // Export annotations as text
    func exportAnnotationsAsText() {
        var text = "Annotations for \(room.name):\n\n"
        
        for (index, annotation) in room.annotations.enumerated() {
            text += "\(index + 1). \(annotation.text) (Color: \(annotation.color.rawValue))\n"
            text += "   Position: x=\(annotation.position.x), y=\(annotation.position.y), z=\(annotation.position.z)\n\n"
        }
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}


