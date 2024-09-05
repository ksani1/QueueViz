import 'dart:math';
import 'processes.dart';
class Simulator {
  final Map yamlConfig;
  final bool verbose;
  final List<Process> processes = [];
  final List<Event> eventQueue = [];
  final List<Event> processedEvents = [];  // List to store processed events

  Simulator(this.yamlConfig, {this.verbose = false}) {
    _loadProcesses();
  }

  // Loads processes from the YAML configuration
  void _loadProcesses() {
    yamlConfig.forEach((key, value) {
      var type = value['type'];
      if (type == 'singleton') {
        processes.add(SingletonProcess.fromConfig(key, value));
      } else if (type == 'periodic') {
        processes.add(PeriodicProcess.fromConfig(key, value));
      } else if (type == 'stochastic') {
        processes.add(StochasticProcess.fromConfig(key, value));
      }
    });
  }

  // Runs the simulation
  void run() {
    _generateEvents();
    _processEvents();
  }

  // Generates events for all processes
  void _generateEvents() {
    for (var process in processes) {
      var events = process.generateEvents();
      eventQueue.addAll(events);
      if (events.isEmpty) {
        print('No events generated for process: ${process.name}');
      } else if (verbose) {
        print('Events generated for process ${process.name}: ${events.length}');
      }
    }
    eventQueue.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
  }

  // Processes events in the queue
void _processEvents() {
  int currentTime = 0;  // Keeps track of the current time in the simulation
  int nextAvailableTime = 0;  // Keeps track of when the resource becomes available

  while (eventQueue.isNotEmpty) {
    var currentEvent = eventQueue.removeAt(0);

    // Update nextAvailableTime to current time or when the current event finishes
    if (currentTime < currentEvent.arrivalTime) {
      currentTime = currentEvent.arrivalTime;
    }

    int waitTime = max(0, nextAvailableTime - currentEvent.arrivalTime);
    currentEvent.waitTime = waitTime;

    if (verbose) {
      print('t=$currentTime: ${currentEvent.processName}, duration ${currentEvent.serviceTime} started (arrived @ ${currentEvent.arrivalTime}, waited ${waitTime})');
    }

    // Update nextAvailableTime to reflect when the resource will be free next
    nextAvailableTime = currentTime + currentEvent.serviceTime;
    currentTime += currentEvent.serviceTime;
    processedEvents.add(currentEvent);
  }
}



  // Prints the report for all processes
  void printReport() {
    Map<String, List<Event>> eventsByProcess = {};
    for (var process in processes) {
      eventsByProcess[process.name] = [];
    }

    for (var event in processedEvents) {  // Use processedEvents instead of eventQueue
      eventsByProcess[event.processName]?.add(event);
    }

    // Print per-process statistics
    print('--------------------------------------------------------------');
    print('# Per-process statistics');
    for (var processName in eventsByProcess.keys) {
      var events = eventsByProcess[processName]!;
      int totalWaitTime = events.map((e) => e.waitTime).fold(0, (a, b) => a + b);
      double avgWaitTime = totalWaitTime / (events.isNotEmpty ? events.length : 1);
      print('$processName:');
      print('  Events generated:  ${events.length}');
      print('  Total wait time:   $totalWaitTime');
      print('  Average wait time: ${avgWaitTime.toStringAsFixed(2)}');
    }

    // Print summary statistics
    int totalEvents = processedEvents.length;  // Corrected
    int totalWaitTime = processedEvents.map((e) => e.waitTime).fold(0, (a, b) => a + b);  // Corrected
    double avgWaitTime = totalEvents > 0 ? totalWaitTime / totalEvents : 0;
    print('--------------------------------------------------------------');
    print('# Summary statistics');
    print('Total num events:  $totalEvents');
    print('Total wait time:   $totalWaitTime');
    print('Average wait time: ${avgWaitTime.toStringAsFixed(2)}');
  }
}
