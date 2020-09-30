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
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button("Connect") {
                mqttClient.connect(onConnection)
            }.disabled(connectIsDisabled)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mqttClient: TestMQTTHandler())
    }
}
