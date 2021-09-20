//
//  ContentView.swift
//  BetterRest
//
//  Created by Yash Poojary on 16/09/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    

    var body: some View {
        NavigationView {
            Form {
                    Section(header: Text("What time do you want to wake up?")) {
                    
                        DatePicker("Please enter a wake time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                    Section(header: Text("Desired Amount of sleep")) {
                        
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g")")
                        }
                }
                
                Section {

                    Picker("Daily Coffee Intake", selection: $coffeeAmount) {
                        ForEach (1..<21) {
                                Text("\($0) \(cupCount(of: $0))")
                        }
                    
//
                        
                    }
                }
                
                Section(header: Text("Your recommended bedtime is ")) {
                    Text(calculateBedTime())
                        .font(.largeTitle)
                }
            }
            .navigationBarTitle("Better Rest")
        }
        
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func cupCount(of coffeeAmount: Int) -> String {
        if coffeeAmount == 1 {
            return "Cup"
        } else {
            return "Cups"
        }

    }
    
    
    
    func calculateBedTime() -> String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
            
            
        } catch {
            return "Sorry, there was a problem calculating your estimate"
        }
    }
    
   
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
