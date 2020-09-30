//
//  ConnectionHandler.swift
//  MQTT_Test
//
//  Created by Carlyn Maw on 9/30/20.
//

import Foundation
import MQTTNIO
import NIO  //Necessary for MultiThreadedEvenLoopGroup

class TestMQTTHandler: ObservableObject {
    @Published private var mqttClient:MQTTClient = createMQTTClient()
    
    static func createMQTTClient() -> MQTTClient {
        ///TODO: change to no require NIO import?
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        
        let credentials = MQTTConfiguration.Credentials(
            username: "try",
            password: "try")
        
        let configuration = MQTTConfiguration(
            target: .host("broker.shiftr.io", port: 1883),
            tls: nil,
            clientId: "swiftShiftr",
            credentials: credentials
        )
        let client = MQTTClient(
            configuration: configuration,
            eventLoopGroup: group
        )
        return client
    }
    
    public func connect() {
        mqttClient.connect()
    }
}
