# RescueMule _<img src="./assets/images/appicon.png" width="40" align="right"/>_

an app that allows for the creation of ad-hoc networks based on different technologies (such as BLE, HTTP). The aim is to make it possible to keep communication channels up - even during desaster events.

### Features

- works on mobile and desktop devices
- supports multiple protocols (HTTP, BLE, etc.)
- allows for the creation of ad-hoc networks

### Contributing

you are welcome to contribute to this project. Here are a few instructions to get you started:

##### Install & Run

1. the project is built with [Flutter](https://flutter.dev/), so you need to have Flutter installed on your machine.
2. clone the repository
3. open it in you favorite IDE (we recommend [VSCode](https://code.visualstudio.com/))
4. run the project with `flutter run` (or the run button in your IDE)

##### Project Structure

- `lib/`: contains the main application code
  - `view`: contains the UI components
  - `model`: contains the data models
  - `service`: contains classes for handling communication protocols
- `assets/`: contains application assets (images, fonts, etc.)

##### Services

the app provides a global `TopologyService`. This can be used to send and listen for messages across the network. The service is a singleton and can be accessed from anywhere in the app via the `topologyService` constant.

- **custom routing**: To define your own routing logic, extend the `RoutingService` class and pass your class as a router to the `TopologyService` constructor.

- **add network**: The `TopologyService` also takes the instance of a `ConnectionsService` as a parameter. This service is responsible for managing the connections to the different protocols. You can define your own network by extending the `NetworkService` class and passing your class as a network to the `ConnectionsService` constructor.

### contacts

if you have any questions or suggestions, feel free to contact us:

- [lechla](https://github.com/lechla)
- [pinkstegosaurus99](https://github.com/pinkstegosaurus99)
- [HeikoBornholdt](https://github.com/HeikoBornholdt)
- [Robin Naumann](https://github.com/RobinNaumann)
