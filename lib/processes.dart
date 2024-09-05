import 'dart:math';
import 'util/stats.dart'; 

class Event {
  final String processName;
  final int arrivalTime;
  final int serviceTime;
  int waitTime = 0;

  Event({required this.processName, required this.arrivalTime, required this.serviceTime});
}

abstract class Process {
  final String name;

  Process(this.name);

  
  List<Event> generateEvents();
}

class SingletonProcess extends Process {
  final int arrivalTime;
  final int duration;

  SingletonProcess(String name, this.arrivalTime, this.duration) : super(name);

  factory SingletonProcess.fromConfig(String name, Map config) {
    return SingletonProcess(name, config['arrival'], config['duration']);
  }

  @override
  List<Event> generateEvents() {
    print('Generating singleton event for $name');
    return [Event(processName: name, arrivalTime: arrivalTime, serviceTime: duration)];
  }
}

class PeriodicProcess extends Process {
  final int duration;
  final int interarrivalTime;
  final int firstArrival;
  final int numRepetitions;

  PeriodicProcess(String name, this.duration, this.interarrivalTime, this.firstArrival, this.numRepetitions) : super(name);

  factory PeriodicProcess.fromConfig(String name, Map config) {
    return PeriodicProcess(name, config['duration'], config['interarrival-time'], config['first-arrival'], config['num-repetitions']);
  }

  @override
  List<Event> generateEvents() {
    List<Event> events = [];
    for (int i = 0; i < numRepetitions; i++) {
      int arrivalTime = firstArrival + i * interarrivalTime;
      events.add(Event(processName: name, arrivalTime: arrivalTime, serviceTime: duration));
    }
    print('Generated ${events.length} periodic events for $name');
    return events;
  }
}

class StochasticProcess extends Process {
  final double meanDuration;
  final double meanInterarrivalTime;
  final int firstArrival;
  final int endTime;
  final Random random = Random();
  late ExpDistribution durationDistribution;
  late ExpDistribution interarrivalDistribution;

  StochasticProcess(String name, this.meanDuration, this.meanInterarrivalTime, this.firstArrival, this.endTime) 
    : super(name) {
    durationDistribution = ExpDistribution(mean: meanDuration);
    interarrivalDistribution = ExpDistribution(mean: meanInterarrivalTime);
  }

  factory StochasticProcess.fromConfig(String name, Map config) {
    return StochasticProcess(
      name,
      config['mean-duration'].toDouble(),
      config['mean-interarrival-time'].toDouble(),
      config['first-arrival'],
      config['end'],
    );
  }

  @override
  List<Event> generateEvents() {
    List<Event> events = [];
    int currentTime = firstArrival;

    while (currentTime < endTime) {
      int duration = durationDistribution.next().round();
      events.add(Event(processName: name, arrivalTime: currentTime, serviceTime: duration));
      currentTime += interarrivalDistribution.next().round();
    }

    print('Generated ${events.length} stochastic events for $name');
    return events;
  }
}