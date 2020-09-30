//
//  ContentView.swift
//  MQTT_Test
//
//  Created by Carlyn Maw on 9/30/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mqttClient:TestMQTTHandler
    
    var body: some View {
        
        Text("Hello, world!")
            .padding()
        Button(action:
                mqttClient.connect
        ) {
            Text("Connect")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mqttClient: TestMQTTHandler())
    }
}
