//
//  RoomDataStore.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import Foundation
import RoomPlan
import SwiftUI



// DataStore for managing the saved rooms
class RoomDataStore: ObservableObject {
    @Published var rooms: [RoomModel] = []
    
    private let fileManager = FileManager.default
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    init() {
        loadRooms()
    }
    
    func addRoom(_ room: RoomModel) {
        rooms.append(room)
        saveRooms()
    }
    
    func updateRoom(_ room: RoomModel) {
        if let index = rooms.firstIndex(where: { $0.id == room.id }) {
            rooms[index] = room
            saveRooms()
        }
    }
    
    func deleteRoom(at indexSet: IndexSet) {
        // Remove USDZ files
        for index in indexSet {
            if let usdzPath = rooms[index].usdzFilePath {
                try? fileManager.removeItem(at: usdzPath)
            }
        }
        
        rooms.remove(atOffsets: indexSet)
        saveRooms()
    }
    
    // Save rooms metadata to a JSON file
    private func saveRooms() {
        let encoder = JSONEncoder()
        do {
            let roomsData = try encoder.encode(rooms)
            let roomsFile = documentsDirectory.appendingPathComponent("rooms.json")
            try roomsData.write(to: roomsFile)
        } catch {
            print("Error saving rooms: \(error)")
        }
    }
    
    // Load rooms metadata from JSON file
    private func loadRooms() {
        let roomsFile = documentsDirectory.appendingPathComponent("rooms.json")
        
        guard fileManager.fileExists(atPath: roomsFile.path) else {
            return
        }
        
        do {
            let roomsData = try Data(contentsOf: roomsFile)
            let decoder = JSONDecoder()
            rooms = try decoder.decode([RoomModel].self, from: roomsData)
        } catch {
            print("Error loading rooms: \(error)")
        }
    }
    
    // Save a USDZ file and update the room model
    func saveUsdzFile(for room: inout RoomModel, usdzData: Data) {
        let fileName = "\(room.id).usdz"
        let usdzDirectory = documentsDirectory.appendingPathComponent("RoomModels", isDirectory: true)
        
        do {
            // Create directory if it doesn't exist
            if !fileManager.fileExists(atPath: usdzDirectory.path) {
                try fileManager.createDirectory(at: usdzDirectory, withIntermediateDirectories: true)
            }
            
            let usdzFilePath = usdzDirectory.appendingPathComponent(fileName)
            try usdzData.write(to: usdzFilePath)
            
            room.usdzFilePath = usdzFilePath
            updateRoom(room)
        } catch {
            print("Error saving USDZ file: \(error)")
        }
    }
}
