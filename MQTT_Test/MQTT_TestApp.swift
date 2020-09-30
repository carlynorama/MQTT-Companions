//
//  MQTT_TestApp.swift
//  MQTT_Test
//
//  Created by Carlyn Maw on 9/30/20.
//

import SwiftUI

@main
struct MQTT_TestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(mqttClient: TestMQTTHandler())
        }
    }
}
