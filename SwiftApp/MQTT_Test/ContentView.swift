//
//  ContentView.swift
//  MQTT_TestApp
//
//  Created by Carlyn Maw on 9/30/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mqttClient:shiftrTestMQTTClient
    
    @State var slider1 = 127.5
    @State var slider2 = 127.5
    @State var textField = ""
    
    let slider1Topic = "slider1"
    let slider2Topic = "slider2"
    let minVal:Double = 0
    let maxVal:Double = 255
    let textFieldTopic = "text"
    
    func sendSlider2Message(_ sendFlag:Bool) {
        let topic = "\(mqttClient.rootTopic)/\(self.slider2Topic)"
        self.mqttClient.publish(topic: topic , message: "\(Int(slider2))")
    }
    
    private func onConnection() {
        //can put UI behaviors that should being on connection here, happens on main
    }
    
    private func onDisconnection() {
        //can put UI behaviors that should being on disconnection here, happens on main
    }
    
    var body: some View {
        VStack {
            
            Text("MQTT Test")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
            
            Divider()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(mqttClient.host)").layoutPriority(1)
                    Image(systemName: "arrow.up.arrow.down.square.fill").foregroundColor(mqttClient.status ? .accentColor:.secondary)
                    Spacer()
                    
                    Button(action: {
                        if mqttClient.status {
                            mqttClient.disconnect(onDisconnection)
                        } else {
                            mqttClient.connect(onConnection)
                        }
                        
                    }) {
                        if mqttClient.status {
                            Text("Disconnect")
                        } else {
                            Text("Connect")
                        }
                        
                    }
                    .padding()
                    
                    
                    
                    
                }
                Text(mqttClient.statusMessage).font(.caption)
            }.frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
            
            Divider()
            
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        Text("topic: \(mqttClient.rootTopic)/\(self.slider1Topic)")
                        Spacer()
                        Text("\(Int(slider1))")
                    }
                    Slider(value: Binding(
                        get: {
                            self.slider1
                        },
                        set: {(newValue) in
                            self.slider1 = newValue
                            mqttClient.publish(topic: "\(mqttClient.rootTopic)/\(self.slider1Topic)", message: "\(Int(slider1))")
                        }
                    ), in: minVal...maxVal).disabled(!mqttClient.status)
                    HStack {
                        Spacer()
                        Text("(sends continuously)").font(.caption)
                    }
                }
                Spacer()
                VStack {
                    HStack {
                        Text("topic: \(mqttClient.rootTopic)/\(self.slider2Topic)")
                        Spacer()
                        Text("\(Int(slider2))")
                    }
                    Slider(
                        value: $slider2,
                        in: minVal...maxVal,
                        onEditingChanged: sendSlider2Message ).disabled(!mqttClient.status)
                    
                    HStack {
                        Spacer()
                        Text("(sends on release)").font(.caption)
                    }
                }
                
            } .frame(maxWidth: .infinity, alignment: .topLeading)
            .foregroundColor(!mqttClient.status ? .secondary:.primary)
            .padding()
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("topic: \(mqttClient.rootTopic)/\(self.textFieldTopic)")
                TextField("Type message to send", text: $textField).disabled(!mqttClient.status)
                HStack {
                    Spacer()
                    Button("Send Message") {
                        mqttClient.publish(topic: "\(mqttClient.rootTopic)/\(self.textFieldTopic)", message: textField)
                    }.disabled(!mqttClient.status)
                    .foregroundColor(mqttClient.status ? .accentColor:.secondary)
                    .padding()
                }
                HStack {
                    Spacer()
                    Text("(sends on button press)").font(.caption).foregroundColor(!mqttClient.status ? .secondary:.primary)
                }
            } .frame(maxWidth: .infinity, alignment: .topLeading)
            .foregroundColor(!mqttClient.status ? .secondary:.primary)
            .padding()
            
            
            
            Divider()
            VStack(alignment: .leading) {
                Text("Messages Recieved")
                Text("\(mqttClient.recievedMessageDisplay)")
                    .font(.caption)
                
                Spacer()
            }
            .foregroundColor(!mqttClient.status ? .secondary:.primary)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding()
            
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mqttClient: shiftrTestMQTTClient())
    }
}
