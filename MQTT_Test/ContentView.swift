//
//  ContentView.swift
//  MQTT_TestApp
//
//  Created by Carlyn Maw on 9/30/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mqttClient:TestMQTTHandler
    
    @State var connectIsDisabled = false
    @State var slider1 = 0.5

    
    @State var slider2 = 0.5
    @State var textField = ""
    
    let slider1Topic = "slider1"
    let slider2Topic = "slider2"
    let minVal = 0.0
    let maxVal = 255.0
    let textFieldTopic = "text"
    
    private func onConnection() {
        self.connectIsDisabled = true
    }
    
    private func onDisconnection() {
        self.connectIsDisabled = false
    }
    
    var body: some View {
        VStack {
            
            Text("MQTT Test")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            
            Divider()
            
            HStack {
                Text("\(mqttClient.host)").layoutPriority(1)
                Spacer()
                Button(action: {mqttClient.connect(onConnection)}) {
                    Image(systemName: "arrow.up.arrow.down.square.fill")//.resizable().aspectRatio(contentMode: .fit)
                }.disabled(connectIsDisabled)
                .padding()
                
                Button(action: {mqttClient.disconnect(onDisconnection)}) {
                    Image(systemName: "xmark.square")//.resizable().aspectRatio(contentMode: .fit)
                }.disabled(!connectIsDisabled)
                //.padding()
                
            }.frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
        
            Divider()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("topic: \(mqttClient.rootTopic)/\(self.slider1Topic)")
                    Spacer()
                    Text("\(Int(slider1))")
                }
                Slider(value: Binding(
                    get: {
                        self.slider1
                    },
                    set: {(newValue) in
                          self.slider1 = newValue
                        mqttClient.publish(topic: "\(mqttClient.rootTopic)/\(self.slider1Topic)", message: "\(slider1)")
                    }
                ), in: 0...255)
                HStack {
                    Text("topic: \(mqttClient.rootTopic)/\(self.slider2Topic)")
                    Spacer()
                    Text("\(Int(slider2))")
                }
                Slider(value: $slider2, in: 0...255)
                Spacer()
                HStack {
                    Spacer()
                    Text("(sends on update example)").font(.caption)
                }
            } .frame(maxWidth: .infinity, alignment: .topLeading)
            .foregroundColor(!connectIsDisabled ? .secondary:.primary)
            .padding()
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("topic: \(mqttClient.rootTopic)/\(self.textFieldTopic)")
                TextField("Type message to send", text: $textField).disabled(!connectIsDisabled)
                Button("Send Message") {
                    mqttClient.publish(topic: "\(mqttClient.rootTopic)/\(self.textFieldTopic)", message: textField)
                }.disabled(!connectIsDisabled)
                Spacer()
                HStack {
                    Spacer()
                    Text("(sends on button press example)").font(.caption)
                }
            } .frame(maxWidth: .infinity, alignment: .topLeading)
            .foregroundColor(!connectIsDisabled ? .secondary:.primary)
            .padding()
            
            
            
            Divider()
            VStack(alignment: .leading) {
                Text("Messages Recieved")
                Text("\(mqttClient.recievedMessageDisplay)")
                    .font(.caption)
                
                
            }
            .foregroundColor(!connectIsDisabled ? .secondary:.primary)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mqttClient: TestMQTTHandler())
    }
}
