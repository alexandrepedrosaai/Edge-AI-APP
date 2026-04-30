namespace Quantum.LunarBase {
    open Microsoft.Quantum.Diagnostics;

    operation LunarResourceOptimization() : Unit {
        let humans = 500;
        let O2_per_person = 550.0;
        let H2O_per_person = 3.0;

        let O2_recycling_efficiency = 0.75;
        let H2O_recycling_efficiency = 0.85;
        let energy_efficiency = 0.90;

        Message("🌌 Lunar Base - Resource Optimization Simulation (30 Days)");

        for day in 1..30 {
            let raw_O2 = O2_per_person * IntAsDouble(humans);
            let raw_H2O = H2O_per_person * IntAsDouble(humans);

            let net_O2 = raw_O2 * (1.0 - O2_recycling_efficiency);
            let net_H2O = raw_H2O * (1.0 - H2O_recycling_efficiency);

            let energy_required = (raw_O2 + raw_H2O) * energy_efficiency;

            Message($"Day {day}: Net O2 = {net_O2:0.00} L, Net H2O = {net_H2O:0.00} L, Energy = {energy_required:0.00} units");
        }
    }
}
