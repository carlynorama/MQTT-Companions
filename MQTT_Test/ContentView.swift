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
    @State var messageField:String = ""
    
    let currentTopic = "try/test/swift"
    let currentMessageToGoOut = "Hello World"
    
    
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
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $messageField)
                Button("Send Message") {
                    mqttClient.publish(topic: currentTopic, message: currentMessageToGoOut)
                }.disabled(!connectIsDisabled)
                
            }.padding()
            
            Divider()
            VStack {
                Text("Messages Recieved")
                Text("\(mqttClient.displayMessage)")
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
