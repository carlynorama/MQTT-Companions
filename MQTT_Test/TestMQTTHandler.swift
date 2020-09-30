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
    @Published private var client:MQTTClient
    
    //@Published var isConnected:Bool = false
    
    init() {
        client = TestMQTTHandler.createMQTTClient()
        client.addConnectListener { _, response, _ in
            print("Connected: \(response.returnCode)")
        }
        client.addDisconnectListener { _, reason, _ in
            print("Disconnected: \(reason)")
        }
        client.addErrorListener { _, error, _ in
            print("Error: \(error)")
        }
        client.addMessageListener { _, message, _ in
            print("Received: \(message)")
        }
    }
    
    private class func createMQTTClient() -> MQTTClient {
        ///TODO: change to no require NIO import? Is that even possible?
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
    
    
    public func connect(_ function:@escaping ()->Void) {
        client.connect().whenSuccess(function)
        
        client.subscribe(to: "try/#").whenComplete { result in
            switch result {
            case .success(.success):
                print("Subscribed!")
            case .success(.failure):
                print("Server rejected")
            case .failure:
                print("Server did not respond")
            }
        }
        
//        else {
//            mqttClient.publish(
//                topic: "try/todtest/some/topic",
//                payload: "Hello World!",
//                qos: .exactlyOnce
//            )
//
//        }
        
     }
    

}
