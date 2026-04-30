namespace Quantum.LunarBase {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;

    operation LunarProbabilisticSimulation() : Unit {
        let humans = 500;
        let O2_per_person = 550.0;
        let H2O_per_person = 3.0;

        Message("🌌 Lunar Base - Probabilistic Simulation (30 Days)");

        for day in 1..30 {
            let variationO2 = DrawRandomDouble() * 0.2 - 0.1;
            let variationH2O = DrawRandomDouble() * 0.2 - 0.1;

            let total_O2 = (O2_per_person * IntAsDouble(humans)) * (1.0 + variationO2);
            let total_H2O = (H2O_per_person * IntAsDouble(humans)) * (1.0 + variationH2O);

            let failure = DrawRandomDouble() < 0.05;

            if (failure) {
                Message($"Day {day}: ⚠️ System failure detected! Resources not delivered.");
            } else {
                Message($"Day {day}: O2 = {total_O2:0.00} liters, H2O = {total_H2O:0.00} liters");
            }
        }
    }
}
