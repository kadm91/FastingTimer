//
//   ProgressRingView.swift
//  FastingTimer
//
//  Created by Kevin Martinez on 8/26/23.
//

import SwiftUI

struct ProgressRingView: View {
    
    @EnvironmentObject var fastingManager: FastingManager
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        
      let circleGradiandColors = [
        Color(#colorLiteral(red: 0.3764705882, green: 0.5058823529, blue: 0.9725490196, alpha: 1)),
        Color(#colorLiteral(red: 0.9647058824, green: 0.4352941176, blue: 0.7019607843, alpha: 1)),
        Color(#colorLiteral(red: 0.8196078431, green: 0.6588235294, blue: 0.8117647059, alpha: 1)),
        Color(#colorLiteral(red: 0.5568627451, green: 0.8196078431, blue: 0.8509803922, alpha: 1)),
        Color(#colorLiteral(red: 0.3764705882, green: 0.4980392157, blue: 0.9647058824, alpha: 1))]
        
        ZStack {
            //MARK: - Placeholder Ring
            
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            //MARK: - Colored Ring
            
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
                .stroke(
                    AngularGradient(
                        gradient:Gradient(
                            colors: circleGradiandColors),
                        center: .center),
                    style: StrokeStyle(
                        lineWidth: 15.0,
                        lineCap: .round,
                        lineJoin: .round
                    ))
                .rotationEffect(Angle(degrees: 270))
                .animation(
                    .easeOut(duration: 1.0),
                    value: fastingManager.progress)
            
            VStack (spacing: 30) {
                
                //MARK: - Upcoming Fast
                
                if fastingManager.fastignState == .notStarted {
                    VStack (spacing: 5) {
                        Text("Upcoming fast")
                            .opacity(0.7)
                        
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                } else {
                    //MARK: - Elapse time
                    
                    VStack (spacing: 5) {
                        Text("Elapsed time(\(fastingManager.progress.formatted(.percent)))")
                            .opacity(0.7)
                        
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    //MARK: - Remaining Time
                    
                    VStack (spacing: 5) {
                        
                        if !fastingManager.elapsed {
                            Text("Remaining time (\((1 - fastingManager.progress).formatted(.percent)))")
                                .opacity(0.7)
                        } else {
                            Text("Extra time")
                                .opacity(0.7)
                        }
                        
                        Text(fastingManager.endTime, style: .timer)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .frame(width: 250, height: 250)
        .padding()
//        .onAppear{
//            progress = 1
//        }
        .onReceive(timer) { _ in
            fastingManager.track()
        }
    }
}

struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView()
            .environmentObject(FastingManager())
    }
}
