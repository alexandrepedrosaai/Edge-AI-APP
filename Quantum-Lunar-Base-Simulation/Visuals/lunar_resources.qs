namespace Quantum.LunarBase {
    open Microsoft.Quantum.Diagnostics;

    operation LunarResourcesVisualization() : Unit {
        let humans = 500;
        let O2_per_person = 550.0;
        let H2O_per_person = 3.0;

        let total_O2 = O2_per_person * IntAsDouble(humans);
        let total_H2O = H2O_per_person * IntAsDouble(humans);

        Message("🌌 Lunar Resources Visualization");
        Message($"Daily O2 consumption for {humans} humans: {total_O2} liters");
        Message($"Daily H2O consumption for {humans} humans: {total_H2O} liters");
        Message("✅ Resource consumption calculated.");
    }
}
