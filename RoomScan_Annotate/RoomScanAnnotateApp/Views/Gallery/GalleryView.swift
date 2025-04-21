//
//  GalleryView.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//

// GalleryView.swift
import SwiftUI
import RoomPlan

struct GalleryView: View {
    @EnvironmentObject var dataStore: RoomDataStore
    @State private var showingScanner = false
    @State private var showingRenameAlert = false
    @State private var selectedRoomId: UUID? = nil
    @State private var newRoomName = ""
    
    var body: some View {
        NavigationView {
            List {
                if dataStore.rooms.isEmpty {
                    Text("No rooms yet. Tap + to scan a new room.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    ForEach(dataStore.rooms) { room in
                        NavigationLink(destination: RoomDetailView(room: room)) {
                            RoomRow(room: room)
                                .contentShape(Rectangle())
                                .contextMenu {
                                    Button(action: {
                                        selectedRoomId = room.id
                                        newRoomName = room.name
                                        showingRenameAlert = true
                                    }) {
                                        Label("Rename", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive, action: {
                                        if let index = dataStore.rooms.firstIndex(where: { $0.id == room.id }) {
                                            dataStore.deleteRoom(at: IndexSet([index]))
                                        }
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                // Add swipe actions for quick access to rename
                                .swipeActions(edge: .leading) {
                                    Button {
                                        selectedRoomId = room.id
                                        newRoomName = room.name
                                        showingRenameAlert = true
                                    } label: {
                                        Label("Rename", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                        }
                    }
                    .onDelete(perform: dataStore.deleteRoom)
                }
            }
            .navigationTitle("Room Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingScanner = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingScanner) {
                NavigationView {
                    RoomCaptureViewControllerRepresentable(isPresented: $showingScanner)
                        .ignoresSafeArea()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .alert("Rename Room", isPresented: $showingRenameAlert) {
                TextField("Room Name", text: $newRoomName)
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    if let roomId = selectedRoomId,
                       let index = dataStore.rooms.firstIndex(where: { $0.id == roomId }) {
                        var updatedRoom = dataStore.rooms[index]
                        updatedRoom.name = newRoomName
                        dataStore.updateRoom(updatedRoom)
                    }
                }
            } message: {
                Text("Enter a new name for this room scan")
            }
        }
    }
}
