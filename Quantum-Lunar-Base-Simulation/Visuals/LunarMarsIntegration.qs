namespace Quantum.LunarBase {
    open Microsoft.Quantum.Diagnostics;

    operation LunarMarsIntegration() : Unit {
        let lunarBases = 2;
        let marsBases = 1;
        let bandwidth = 50.0;
        let latency = 720.0;

        Message("🌌 Lunar-Mars Integration Simulation");

        for lunar in 1..lunarBases {
            for mars in 1..marsBases {
                let effective_bandwidth = bandwidth * (1.0 - (latency / 1000.0));
                Message($"Lunar Base {lunar} ↔ Mars Base {mars}: Bandwidth = {effective_bandwidth:0.00} Mbps, Latency = {latency:0.00} s");
            }
        }

        Message("✅ Interplanetary communication channels established.");
    }
}
