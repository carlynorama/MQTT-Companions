//
//  ConnectionHandler.swift
//  MQTT_Test
//
//  Created by Carlyn Maw on 9/30/20.
//

import Foundation
import MQTTNIO
import NIO  //Necessary for MultiThreadedEvenLoopGroup

class shiftrTestMQTTClient: ObservableObject {
    @Published private var client:MQTTClient
    
    @Published var rootTopic = "try/test/swift"
    @Published var subscriptionTopic = "try/#"
    
    @Published var statusMessage:String = "status messages"
    @Published var status:Bool = false
    
    @Published var recievedMessageDisplay:String = "No Message Yet"
    
    init() {
        client = shiftrTestMQTTClient.createMQTTClient()
        
        client.addConnectListener { _, response, _ in
            print("Connected: \(response.returnCode)")
            DispatchQueue.main.async {
                self.statusMessage = "Connected: \(response.returnCode)"
                self.status = true
            }
        }
        client.addDisconnectListener { _, reason, _ in
            print("Disconnected: \(reason)")
            DispatchQueue.main.async {
                self.statusMessage = "Disconnected: \(reason)"
                self.status = false
            }
        }
        client.addErrorListener { _, error, _ in
            print("Error: \(error)")
            DispatchQueue.main.async {
                self.statusMessage = "Error: \(error)"
                self.status = self.client.isConnected
            }
        }
        client.addMessageListener { _, message, _ in
            print("Received: \(message)")
            DispatchQueue.main.async {
                self.messageRecieved(message)
            }
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
            clientId: "swiftShiftr.\(UUID())",
            credentials: credentials
        )
        let client = MQTTClient(
            configuration: configuration,
            eventLoopGroup: group
        )
        
        return client
    }
    
    
    var host:String {
        let hostparts = getHostStrings()
        return "\(hostparts.host) : \(hostparts.port)"
    }
    
    private func getHostStrings() -> (host: String, port: String){
        let results = "\(client.configuration.target)".components(separatedBy: ", port:")
        var hostString:String = results[0]
        var portString:String = results[1]
        
        let prefix = "host(\""
        if hostString.hasPrefix(prefix) {
            hostString =  String(hostString.dropFirst(prefix.count))
        }
        
        hostString = hostString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        let set = CharacterSet(charactersIn: "0123456789")
        portString = portString.components(separatedBy: set.inverted).joined()
        
        return (hostString, portString)
    }
    
    
    public func connect(_ function:@escaping ()->Void) {
        client.connect().whenSuccess(function)
        self.subscribe(subscriptionTopic)
    }
    
    public func disconnect(_ function:@escaping ()->Void) {
        client.disconnect().whenSuccess(function)
    }
    
    public func publish(topic:String, message:String) {
        client.publish(
            topic: topic,
            payload: message,
            qos: .exactlyOnce
        )
        .whenSuccess({print("Sent \(message)")})
    }
    
    public func subscribe(_ topic:String) {
        client.subscribe(to: topic).whenComplete { result in
            switch result {
            case .success(.success):
                print("Subscribed!")
            case .success(.failure):
                print("Server rejected")
            case .failure:
                print("Server did not respond")
            }
        }
    }
    
    public func unsubscribe(_ topic:String) {
        client.unsubscribe(from: topic).whenComplete { result in
            switch result {
            case .success:
                print("Unsubscribed!")
            case .failure:
                print("Server did not respond")
            }
        }
    }
    
    public func messageRecieved(_ message:MQTTMessage) {
        self.recievedMessageDisplay = "got a messageFrom \(message.topic), it says \(message.payloadString ?? "something I can't read")"
        //print(recievedMessageDisplay)
    }
}
