//
//  WaveForm.swift
//  Recorded
//
//  Created by Sunny Hwang on 11/13/23.
//

import SwiftUI

struct WaveForm: View{
    var color:Color
    var amplify: CGFloat
    var isReversed :Bool
    var body: some View{
        TimelineView(.animation){timeline in
            Canvas{context,size in
                let timeNow = timeline.date.timeIntervalSinceReferenceDate
                let angle = timeNow.remainder(dividingBy: 2)
                let offset = angle * size.width
                
                context.translateBy(x: isReversed ? -offset: offset, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                context.translateBy(x: -size.width, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                context.translateBy(x: size.width*2, y: 0)
                context.fill(getPath(size: size), with: .color(color))
            }
        }
        
    }
    func getPath(size: CGSize)->Path{
        Path{path in
            let midHeigth = size.height / 16 * 7
            let width = size.width
            path.move(to: CGPoint(x: 0, y: midHeigth))
            path.addCurve(to: CGPoint(x: width, y: midHeigth), control1: CGPoint(x: width * 0.4, y: midHeigth+amplify), control2: CGPoint(x: width*0.65, y: midHeigth-amplify))
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }
        
    }
}
