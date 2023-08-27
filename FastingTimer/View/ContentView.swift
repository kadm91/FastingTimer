//
//  ContentView.swift
//  FastingTimer
//
//  Created by Kevin Martinez on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    
    
    @StateObject var fastingManager = FastingManager()
    
    var title: String {
        
        switch fastingManager.fastignState {
            
        case .notStarted: return "Let's get Started!"
            
        case .fasting: return "You are now fasting"
            
        case .feeding: return "You are now feeding"
            
        }
    }
    
    var body: some View {
        ZStack {
     //MARK: - Background
            
           Color(#colorLiteral(red: 0.05882352941, green: 0, blue: 0.1137254902, alpha: 1))
                .ignoresSafeArea()
            
            content
        
      }
    }
    
    
    var content: some View {
        
        ZStack {
            VStack (spacing: 40) {
                //MARK: - Title
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(
                        Color(
                            #colorLiteral(
                                red: 0.3764705882,
                                green: 0.5058823529,
                                blue: 0.9725490196,
                                alpha: 1
                            )))
                
                //MARK: - Fasting Plan
                
                Text(fastingManager.fastingPlan.rawValue)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                
                Spacer()
            }
            .padding()
                
            VStack(spacing: 40) {
                //MARK: - Progress Ring
                ProgressRingView()
                    .environmentObject(fastingManager)
                
                HStack (spacing: 60) {
                    //MARK: - Start Time
                    
                    VStack(spacing: 5) {
                        Text(fastingManager.fastignState == .notStarted ? "Start" : "Started")
                            .opacity(7)
                        
                        Text(fastingManager.startTime, format:.dateTime.weekday().hour().minute().second())
                        .fontWeight(.bold)
                    }
                    
                    //MARK: - End Time
                    
                    VStack(spacing: 5) {
                        Text(fastingManager.fastignState == .notStarted ? "End" : "Ends")
                            .opacity(7)
                        
                        Text(fastingManager.endTime, format:.dateTime.weekday().hour().minute().second())
                        .fontWeight(.bold)
                    }
                }
                
                //MARK: - Button
                Button {
                    fastingManager.toggleFastignState()
                } label: {
                    Text(fastingManager.fastignState == .fasting ? "End fast" : "Start fastign")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }

            }
            .padding()
     
        }
        .foregroundColor(.white)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
