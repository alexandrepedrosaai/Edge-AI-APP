<?php
// Simple CI/CD automation in PHP

$appName  = "Edge-AI-APP";
$version  = "1.0." . time();   // timestamp-based version
$artifact = "artifacts/{$appName}-{$version}.zip";

// Step 1: Clean and build (simulate Gradle build)
echo "==> Building project...\n";
exec("./gradlew clean build", $output, $status);
if ($status !== 0) {
    die("Build failed!\n");
}

// Step 2: Package binary artifact
echo "==> Packaging binary...\n";
if (!is_dir("artifacts")) {
    mkdir("artifacts", 0777, true);
}
copy("build/libs/{$appName}.jar", "{$appName}.jar");
$zip = new ZipArchive();
if ($zip->open($artifact, ZipArchive::CREATE) === TRUE) {
    $zip->addFile("{$appName}.jar");
    $zip->close();
    echo "Artifact created: {$artifact}\n";
} else {
    die("Failed to create artifact!\n");
}

// Step 3: Automated release (Git tag)
echo "==> Creating release tag...\n";
exec("git tag v{$version}");
exec("git push origin v{$version}");

// Step 4: Deploy (custom script)
echo "==> Deploying version {$version}...\n";
exec("./scripts/deploy.sh {$version}", $deployOutput, $deployStatus);
if ($deployStatus !== 0) {
    die("Deployment failed!\n");
}

echo "✅ CI/CD pipeline completed successfully for {$appName} version {$version}\n";
?>
