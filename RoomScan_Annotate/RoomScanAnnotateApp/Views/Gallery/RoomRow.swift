//
//  RoomRow.swift
//  RoomScanAnnotate
//
//  Created by Ryan Rotella on 4/14/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import SwiftUI
import RoomPlan

struct RoomRow: View {
    let room: RoomModel
    
    var body: some View {
        HStack {
            if let thumbnailData = room.thumbnailImageData, let uiImage = UIImage(data: thumbnailData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .cornerRadius(6)
            } else {
                Image(systemName: "house.fill")
                    .font(.system(size: 30))
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(6)
            }
            
            VStack(alignment: .leading) {
                Text(room.name)
                    .font(.headline)
                
                Text("\(room.annotations.count) annotations")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(room.creationDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
