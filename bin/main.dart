import 'dart:io';
import 'package:args/args.dart';
import 'package:yaml/yaml.dart';
import 'package:queueing_simulator/simulator.dart';

void main(List<String> args) {
  // Configure command line argument parser and parse the arguments
  final parser = ArgParser()
    ..addOption('conf', abbr: 'c', help: 'Config file path')
    ..addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false, help: 'Print verbose output');

  final results = parser.parse(args);

  // Print help message if the user omitted the config file path
  if (!results.wasParsed('conf')) {
    print('Usage: dart main.dart -c <config.yaml> [--verbose]');
    print(parser.usage);
    exit(0);
  }

  // This flag is true if the user provided the verbose flag
  final verbose = results['verbose'];

  // Get and check the config file path
  final filePath = results['conf'];
  final file = File(filePath);
  if (!file.existsSync()) {
    print('Error: Config file not found at path: $filePath');
    exit(1);
  }

  // Load and parse the config file
  late YamlMap yamlData;
  try {
    final yamlString = file.readAsStringSync();
    yamlData = loadYaml(yamlString);
  } catch (e) {
    print('Error: Failed to parse YAML file. Please check the file format.');
    print('Details: $e');
    exit(1);
  }

  // Create a simulator, run it, and print the report
  final simulator = Simulator(yamlData, verbose: verbose);
  simulator.run();
  simulator.printReport();
}
