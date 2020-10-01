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
                Text("\(mqttClient.host)")
                Button("C") {
                    mqttClient.connect(onConnection)
                }.disabled(connectIsDisabled)
                .padding()
                Button("D") {
                    mqttClient.disconnect(onDisconnection)
                }.disabled(!connectIsDisabled)
                .padding()
            }
            
            Divider()
            
            VStack {
                Text("topic: \(mqttClient.currentTopic)")
                TextField("Placeholder", text: $mqttClient.outGoingMessage)
                Button("Send Message") {
                    mqttClient.publish(topic: mqttClient.currentTopic, message: mqttClient.outGoingMessage)
                }.disabled(!connectIsDisabled)
                
            }.padding()
            
            Divider()
            VStack {
                Text("Messages Recieved")
                Text("\(mqttClient.recievedMessageDisplay)")
                    .font(.caption)
                    .foregroundColor(!connectIsDisabled ? .secondary:.primary)
                    .padding()
            }

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mqttClient: TestMQTTHandler())
    }
}
