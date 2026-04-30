namespace Quantum.LunarBase {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;

    operation LunarConstants() : Unit {
        let humans = 500;
        let O2_per_person = 550.0;
        let H2O_per_person = 3.0;
        let radius = 50.0;
        let volume = (2.0/3.0) * PI() * PowD(radius,3);

        let total_O2 = O2_per_person * IntAsDouble(humans);
        let total_H2O = H2O_per_person * IntAsDouble(humans);

        Message("🌌 Lunar Base Report");
        Message($"Population: {humans} humans");
        Message($"Dome volume: {volume} m³");
        Message($"O2 required/day: {total_O2} liters");
        Message($"H2O required/day: {total_H2O} liters");
    }
}
