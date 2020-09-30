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
    
    let defaultTopic = "try/test/swift"
    let defaultMessage = "Hello World"
    
    private func onConnection() {
        self.connectIsDisabled = true
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
                mqttClient.publish(topic: defaultTopic, message: defaultMessage)
            }.disabled(!connectIsDisabled).padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mqttClient: TestMQTTHandler())
    }
}
