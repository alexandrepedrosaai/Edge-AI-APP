namespace Quantum.LunarBase {
    open Microsoft.Quantum.Diagnostics;

    operation LunarConsumption30Days() : Unit {
        let humans = 500;
        let O2_per_person = 550.0;
        let H2O_per_person = 3.0;

        Message("🌌 Lunar Base - 30 Days Consumption Report");

        for day in 1..30 {
            let total_O2 = O2_per_person * IntAsDouble(humans);
            let total_H2O = H2O_per_person * IntAsDouble(humans);

            Message($"Day {day}: O2 = {total_O2} liters, H2O = {total_H2O} liters");
        }
    }
}
