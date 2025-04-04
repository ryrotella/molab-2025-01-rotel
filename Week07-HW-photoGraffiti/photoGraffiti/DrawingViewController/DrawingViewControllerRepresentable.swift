//
//  DrawingViewControllerRepresentable.swift
//  photoGraffiti
//
//  Created by Ryan Rotella on 3/14/25.
//generated by claude.ai: https://claude.ai/chat/4d621eea-b6c9-453a-8867-69760dd346c4
import SwiftUI


struct DrawingViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DrawingViewController {
        return DrawingViewController()
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        // Updates not needed for this preview
    }
}

#Preview("Drawing App") {
    DrawingViewControllerRepresentable()
}
