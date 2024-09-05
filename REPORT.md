# MP Report

## Team

- Name(s): Khalil Muhammad
- AID(s): A20526151

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The simulator builds without error
- [X] The simulator runs on at least one configuration file without crashing
- [X] Verbose output (via the `-v` flag) is implemented
- [X] I used the provided starter code
- The simulator runs correctly (to the best of my knowledge) on the provided configuration file(s):
  - [X] conf/sim1.yaml
  - [X] conf/sim2.yaml
  - [X] conf/sim3.yaml
  - [X] conf/sim4.yaml
  - [X] conf/sim5.yaml

## Summary and Reflection

### Implementation Decisions

In this project, I made several key decisions to ensure the simulator was both efficient and easy to maintain:

1. **Modular Class Design**: I structured the code using a base `Process` class and three subclasses (`SingletonProcess`, `PeriodicProcess`, and `StochasticProcess`). This allowed me to handle each type of process uniquely while still maintaining shared functionality.

2. **Event Handling Logic**: I focused on ensuring that the event handling logic was robust. I used a priority queue-like system to process events in the order of their arrival and calculated wait times based on when resources became available.

3. **Verbose Output**: Implemented a verbose flag (`-v`) to provide detailed traces of event processing. This helped me debug the simulator and ensure all calculations, especially wait times, were correct.

### Challenges Faced

One of the biggest challenges I faced was ensuring that the stochastic process generated events that accurately followed an exponential distribution. Understanding the random sample generation using exponential probability distribution and integrating it correctly into the event generation logic was non-trivial.

### Learning and Reflection

I enjoyed working on this machine problem because it required a deep understanding of queueing theory and simulation design. One challenge was understanding how to manage event queues efficiently while calculating wait times dynamically. I wish I had focused more on designing the `Event` and `Simulation` classes first, as these turned out to be the core components.

Overall, this project taught me the importance of writing modular code and provided a deeper understanding of event-driven simulation systems.

