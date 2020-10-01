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
    
    let currentTopic = "try/test/swift"
    let currentOutGoingMessage = "Hello World"
    
//    let reallyLongMessage = "Who put the bop in the bop she-bop? Oh who put the bop in the bop-she-bop-yah"
    
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
            Button("Connect") {
                mqttClient.connect(onConnection)
            }.disabled(connectIsDisabled)
            .padding()
            Button("Send Default Message") {
                mqttClient.publish(topic: currentTopic, message: currentOutGoingMessage)
            }.disabled(!connectIsDisabled).padding()
            Button("Disconnect") {
                mqttClient.disconnect(onDisconnection)
            }.disabled(!connectIsDisabled)
            .padding()
            Text("\(mqttClient.displayMessage)")
                .font(.caption)
                .foregroundColor(!connectIsDisabled ? .secondary:.primary)
                .padding()
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mqttClient: TestMQTTHandler())
    }
}
