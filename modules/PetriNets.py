"""
PetriNets Module
Petri Net concurrency and distributed verification for Edge-AI-APP.
Models concurrent state transitions for CPU execution.
"""

import sys
import json
from collections import defaultdict


class Place:
    def __init__(self, name, tokens=0):
        self.name = name
        self.tokens = tokens

    def __repr__(self):
        return f"Place({self.name}, tokens={self.tokens})"


class Transition:
    def __init__(self, name):
        self.name = name
        self.input_arcs = {}   # place_name -> weight
        self.output_arcs = {}  # place_name -> weight

    def add_input(self, place_name, weight=1):
        self.input_arcs[place_name] = weight

    def add_output(self, place_name, weight=1):
        self.output_arcs[place_name] = weight

    def is_enabled(self, places):
        for p_name, weight in self.input_arcs.items():
            if places[p_name].tokens < weight:
                return False
        return True

    def fire(self, places):
        if not self.is_enabled(places):
            return False
        for p_name, weight in self.input_arcs.items():
            places[p_name].tokens -= weight
        for p_name, weight in self.output_arcs.items():
            places[p_name].tokens += weight
        return True


class PetriNet:
    def __init__(self, name):
        self.name = name
        self.places = {}
        self.transitions = {}

    def add_place(self, name, tokens=0):
        self.places[name] = Place(name, tokens)

    def add_transition(self, name):
        t = Transition(name)
        self.transitions[name] = t
        return t

    def get_marking(self):
        return {name: p.tokens for name, p in self.places.items()}

    def print_marking(self):
        marking = self.get_marking()
        print("  Marking: " + ", ".join(f"{k}={v}" for k, v in marking.items()))


def build_producer_consumer_net():
    """Classic producer-consumer Petri Net."""
    net = PetriNet("ProducerConsumer")

    # Places
    net.add_place("ready_to_produce", tokens=1)
    net.add_place("buffer", tokens=0)
    net.add_place("ready_to_consume", tokens=0)
    net.add_place("consumed", tokens=0)

    # Transitions
    t_produce = net.add_transition("produce")
    t_produce.add_input("ready_to_produce", 1)
    t_produce.add_output("buffer", 1)
    t_produce.add_output("ready_to_produce", 1)

    t_consume = net.add_transition("consume")
    t_consume.add_input("buffer", 1)
    t_consume.add_output("consumed", 1)
    t_consume.add_output("ready_to_consume", 1)

    return net


def simulate(net, steps=4):
    """Simulate the Petri Net for a given number of steps."""
    print(f"Simulating Petri Net: {net.name}")
    net.print_marking()

    transition_order = list(net.transitions.keys())
    fired_log = []

    for step in range(steps):
        fired = False
        for t_name in transition_order:
            t = net.transitions[t_name]
            if t.is_enabled(net.places):
                t.fire(net.places)
                fired_log.append(t_name)
                print(f"  Step {step + 1}: Fired '{t_name}'")
                net.print_marking()
                fired = True
                break
        if not fired:
            print(f"  Step {step + 1}: No enabled transitions (deadlock or stable state)")
            break

    return fired_log


def main():
    print("Initializing PetriNets module...")

    net = build_producer_consumer_net()
    fired_log = simulate(net, steps=6)

    final_marking = net.get_marking()
    output = {
        "module": "PetriNets",
        "version": "1.0.0",
        "net_name": net.name,
        "transitions_fired": fired_log,
        "final_marking": final_marking,
        "status": "success",
    }
    print("\nPetriNets JSON output:")
    print(json.dumps(output, indent=2))

    print("\nPetriNets module completed successfully.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
