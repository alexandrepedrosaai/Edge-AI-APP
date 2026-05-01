namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    // Definições padrão
    newtype SemVer = (Major : Int, Minor : Int, Patch : Int, PreRelease : String, Build : String);

    function DefaultSemVer() : SemVer {
        return SemVer(0, 2, 0, "", "");
    }

    function SemVerToString(ver : SemVer) : String {
        let (major, minor, patch, prerelease, build) = ver!;
        mutable version = $"{major}.{minor}.{patch}";
        if (prerelease != "") {
            set version <- $"{version}-{prerelease}";
        }
        if (build != "") {
            set version <- $"{version}+{build}";
        }
        return version;
    }

    operation ShowVersion() : Unit {
        let semver = DefaultSemVer();
        Message($"#Q Semantic Version: {SemVerToString(semver)}");
    }

    @EntryPoint()
    operation Main() : Unit {
        Message("🌌 Quantum Lunar Base Simulation started...");
        ShowVersion();
    }
}
