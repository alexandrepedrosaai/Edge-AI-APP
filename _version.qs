namespace QuantumLunarSimulation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    // Representação de versão semântica
    newtype SemVer = (Major : Int, Minor : Int, Patch : Int, PreRelease : String, Build : String);

    // Versão padrão
    function DefaultSemVer() : SemVer {
        return SemVer(0, 2, 0, "", "");
    }

    // Converte SemVer para string
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

    // Converte SemVer para formato PEP440-like
    function SemVerToPep440(ver : SemVer) : String {
        let (major, minor, patch, prerelease, build) = ver!;
        mutable pep440 = $"{major}.{minor}.{patch}";

        if (prerelease != "") {
            if (prerelease == "alpha") {
                set pep440 <- $"{pep440}a0";
            } elif (prerelease == "beta") {
                set pep440 <- $"{pep440}b0";
            } elif (prerelease == "rc") {
                set pep440 <- $"{pep440}rc0";
            } else {
                set pep440 <- $"{pep440}.dev0";
            }
        }

        if (build != "") {
            set pep440 <- $"{pep440}+{build}";
        }

        return pep440;
    }

    @EntryPoint()
    operation Main() : Unit {
        let semver = DefaultSemVer();
        let semverStr = SemVerToString(semver);
        let pep440Str = SemVerToPep440(semver);

        Message($"#Q Semantic Version: {semverStr}");
        Message($"#Q Package Version (PEP440-like): {pep440Str}");
    }
}
