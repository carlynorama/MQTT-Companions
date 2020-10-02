# MQTT Companions

This repo contains two projects that speak to each other via the MQTT Protocol

1. A Swift iOS application
2. An Arduino app that presumes Arduino Nano33 IoT


## Swift App

### Dependencies

This App uses one package.

- [`sroebert/mqtt-nio`](https://github.com/sroebert/mqtt-nio) for MQTT Handling

The MQTTNIO package has three dependencies:

- [`apple/swift-nio`](https://github.com/apple/swift-nio) for IO
- [`apple/swift-nio-ssl`](https://github.com/apple/swift-nio-ssl) for TLS
- [`apple/swift-log`](https://github.com/apple/swift-log) for logging

The package has no additional system dependencies.



## Arduino App

The Arduino app is developed from examples by Tom Igoe.

- https://github.com/tigoe/mqtt-examples
- https://github.com/tigoe/mqtt-examples/tree/master/MqttClientButtonLed
