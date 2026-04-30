namespace Quantum.LunarBase {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;

    operation LunarDomeVisualization() : Unit {
        let radius = 50.0;
        let volume = (2.0/3.0) * PI() * PowD(radius,3);

        Message("🌌 Lunar Dome Visualization");
        Message($"Semi-spherical dome radius: {radius} m");
        Message($"Dome volume: {volume} m³");
        Message("✅ Dome geometry calculated.");
    }
}
