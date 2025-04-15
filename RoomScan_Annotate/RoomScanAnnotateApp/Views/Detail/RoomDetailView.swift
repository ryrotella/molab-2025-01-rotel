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
    
    var body: some View {
        VStack {
            // 3D Room View
            ZStack {
                RoomModelView(room: $room,
                              selectedAnnotation: $selectedAnnotation,
                              isInAnnotationMode: $isInAnnotationMode,
                              onTapToAddAnnotation: { position in
                                  addAnnotation(at: position)
                              })
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
                            HStack {
                                Circle()
                                    .fill(annotation.color.color)
                                    .frame(width: 16, height: 16)
                                
                                Text(annotation.text)
                                
                                Spacer()
                                
                                Button(action: {
                                    selectedAnnotation = annotation
                                    newAnnotationText = annotation.text
                                    annotationColor = annotation.color
                                    showingAnnotationEditor = true
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                                
                                Button(action: {
                                    deleteAnnotation(annotation)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedAnnotation = annotation
                            }
                        }
                    }
                    .frame(height: 150)
                }
            }
        }
        .navigationTitle(room.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingExportOptions = true
                }) {
                    Image(systemName: "square.and.arrow.up")
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
    
    private var annotationEditorView: some View {
        NavigationView {
            Form {
                Section(header: Text("Annotation Text")) {
                    TextEditor(text: $newAnnotationText)
                        .frame(height: 100)
                }
                
                Section(header: Text("Color")) {
                    HStack {
                        ForEach(AnnotationColor.allCases, id: \.self) { color in
                            Circle()
                                .fill(color.color)
                                .frame(width: 30, height: 30)
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
    
    // Update an existing annotation
    func updateAnnotation(_ annotation: Annotation) {
        if let index = room.annotations.firstIndex(where: { $0.id == annotation.id }) {
            var updated = annotation
            updated.text = newAnnotationText
            updated.color = annotationColor
            
            room.annotations[index] = updated
            dataStore.updateRoom(room)
        }
    }
    
    // Delete an annotation
    func deleteAnnotation(_ annotation: Annotation) {
        room.annotations.removeAll(where: { $0.id == annotation.id })
        dataStore.updateRoom(room)
        
        if selectedAnnotation?.id == annotation.id {
            selectedAnnotation = nil
        }
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
