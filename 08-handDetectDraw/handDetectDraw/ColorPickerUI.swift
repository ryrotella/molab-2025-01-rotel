//
//  ColorPickerUI.swift
//  handDetectDraw
//
//  Created by Ryan Rotella on 3/24/25.
//

import SwiftUI

struct ColorPickerUI: View {
    @State private var selectedColor: Color = .white
    @State private var showColorPicker: Bool = false
    
    var body: some View {
        
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(selectedColor)
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

class ColorPickerDelegate: NSObject, UIColorPickerViewControllerDelegate {
    var didSelectColor: ((Color) -> Void)

    init(_ didSelectColor: @escaping ((Color) -> Void)) {
        self.didSelectColor = didSelectColor
    }
    
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        let selectedUIColor = viewController.selectedColor
        didSelectColor(Color(uiColor: selectedUIColor))
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print("dismiss colorPicker")
    }

}

struct ColorPickerView: UIViewControllerRepresentable {
    private let delegate: ColorPickerDelegate
    private let pickerTitle: String
    private let selectedColor: UIColor

    init(title: String, selectedColor: Color, didSelectColor: @escaping ((Color) -> Void)) {
        self.pickerTitle = title
        self.selectedColor = UIColor(selectedColor)
        self.delegate = ColorPickerDelegate(didSelectColor)
    }
 
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let colorPickerController = UIColorPickerViewController()
        colorPickerController.delegate = delegate
        colorPickerController.title = pickerTitle
        colorPickerController.selectedColor = selectedColor
        return colorPickerController
    }

 
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {}
}


#Preview {
    ColorPickerUI()
}
