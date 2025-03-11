//
//  scoreBg.swift
//  basketball-v1
//
//  Created by Ryan Rotella on 2/28/25.
//

import SwiftUI

struct sBoard: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        
        
        //starting point
        path.move(to: CGPoint(x: 0, y: height/4))
        
        path.addRect(CGRect(origin: CGPoint(x: 0, y: height/4), size: CGSize(width: width * 0.75, height: height/2)))
       
        
        return path
    }
}


struct scoreBg: View {
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var body: some View{
        ZStack {
            Rectangle()
                .fill(.black)
                .frame(width: width, height: height * 0.45)
        }
    }
    
}

#Preview {
    scoreBg()
}
