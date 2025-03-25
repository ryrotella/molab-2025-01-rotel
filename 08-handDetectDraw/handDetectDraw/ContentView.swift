//
//  ContentView.swift
//  handDetectDraw
//
//  Created by Ryan Rotella on 3/24/25.
//helpful tutorial: https://www.createwithswift.com/detecting-hand-pose-with-the-vision-framework/
//

import SwiftUI
import AVFoundation
import Vision

// 1. Application main interface
struct ContentView: View {
    
    //hand pose
    @State private var handPoseInfo: String = "Detecting hand poses..."
    @State private var handPoints: [CGPoint] = []
    
    //lines
    @State private var lines: [(path: UIBezierPath, color: UIColor, lineWidth: CGFloat)] = []
    
    //color picker
    @State private var selectedColor: Color = .white
    @State private var showColorPicker: Bool = false
    
    //line width slider
    @State private var lineWidth: CGFloat = 5.0
    @State private var isEditing = false

    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            
            ScannerView(handPoseInfo: $handPoseInfo, handPoints: $handPoints)
            
            // Draw lines between finger joints and the wrist
            Path { path in
                let fingerJoints = [
                    [1, 2, 3, 4],    // Thumb joints (thumbCMC -> thumbMP -> thumbIP -> thumbTip)
                    [5, 6, 7, 8],    // Index finger joints
                    [9, 10, 11, 12],  // Middle finger joints
                    [13, 14, 15, 16],// Ring finger joints
                    [17, 18, 19, 20] // Little finger joints
                ]
                
                if let wristIndex = handPoints.firstIndex(where: { $0 == handPoints.first }) {
                    for joints in fingerJoints {
                        guard joints.count > 1 else { continue }

                        // Connect wrist to the first joint of each finger
                        if joints[0] < handPoints.count {
                            let firstJoint = handPoints[joints[0]]
                            let wristPoint = handPoints[wristIndex]
                            path.move(to: wristPoint)
                            path.addLine(to: firstJoint)
                        }

                        // Connect the joints within each finger
                        for i in 0..<(joints.count - 1) {
                            if joints[i] < handPoints.count && joints[i + 1] < handPoints.count {
                                let startPoint = handPoints[joints[i]]
                                let endPoint = handPoints[joints[i + 1]]
                                path.move(to: startPoint)
                                path.addLine(to: endPoint)
                            }
                        }
                    }
                }
            }
            .stroke(selectedColor, lineWidth: lineWidth)
            
            // Draw circles for the hand points, including the wrist
            ForEach(handPoints, id: \.self) { point in
                Circle()
                    .fill(.red)
                    .frame(width: 15)
                    .position(x: point.x, y: point.y)
            }
            

            Text(handPoseInfo)
                
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 10)
                .position(x: 200, y: 100)
            
        }
        .edgesIgnoringSafeArea(.all)
        
        //MARK: Line Width Slider
        
        VStack {
                Slider(
                    value: $lineWidth,
                    in: 1...60,
                    onEditingChanged: { editing in
                        isEditing = editing
                    }
                )
                Text("Line Width: \(lineWidth)")
                    .foregroundColor(isEditing ? .red : .blue)
            }
        .background(.white)
        //.frame(maxWidth: 350, maxHeight: .infinity, alignment: .bottom)
        .position(x: 150, y: 450)
        .frame(width: 350)
        
        //MARK: Color Picker
        VStack(spacing: 80) {
            
            //button for color picker
            Button {
                showColorPicker = true
            } label: {
                Text("Pick A Color!")
            }
            .foregroundStyle(.white)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(.black).stroke(.gray.opacity(0.4), style: .init(lineWidth: 2.0)))

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .background(.clear)
        .sheet(isPresented: $showColorPicker, content: {
            ColorPickerView(
                title: "My Picker",
                selectedColor: selectedColor,
                didSelectColor: { color in
                    self.selectedColor = color
                }
            )
            .padding(.top, 8)
            .background(.white)
            .interactiveDismissDisabled(false)
            .presentationDetents([.height(640)])
            //whites out dropper icon
            .overlay(alignment: .topLeading, content: {
                Rectangle()
                    .fill(.white)
                    .frame(height: 56)
                    .frame(maxWidth: 50)
            })
            //close button
            .overlay(alignment: .topTrailing, content: {
                Button(action: {
                    showColorPicker = false
                }, label: {
                    Image(systemName: "xmark")

                })
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.gray.opacity(0.8))
                .padding(.all, 8)
                .background(Circle().fill(.gray.opacity(0.2)))
                .padding()
            })
            
        })
        
        
    }
  
}

#Preview {
    ContentView()
}
