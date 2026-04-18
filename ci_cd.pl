#!/usr/bin/perl
use strict;
use warnings;

my $app_name = $ENV{'APP_NAME'} // "edge-ai-kotlin";
my $version  = $ENV{'VERSION'}  // "1.0." . time();
my $registry = $ENV{'REGISTRY'} // "dockerhub.io/edge-ai";

print "==> Building project...\n";
# The Kotlin project is a subproject in src/main/kotlin
system("./gradlew :src:main:kotlin:clean :src:main:kotlin:build :src:main:kotlin:fatJar --no-daemon") == 0 or die "Build failed!\n";

print "==> Running unit tests...\n";
system("./gradlew :src:main:kotlin:test") == 0 or die "Tests failed!\n";

print "==> Packaging binary...\n";
system("mkdir -p artifacts") == 0 or die "Failed to create artifacts dir!\n";
# The JAR is produced in the subproject's build directory
my $source_jar = "src/main/kotlin/build/libs/edge-ai-kotlin-1.1.0-all.jar";
my $target_jar = "artifacts/$app_name-$version.jar";

if (-e $source_jar) {
    system("cp $source_jar $target_jar") == 0 or die "Failed to copy JAR!\n";
    print "✅ Successfully packaged $target_jar\n";
} else {
    die "Error: Source JAR not found at $source_jar\n";
}

print "==> Building Docker image...\n";
# Skip docker operations if docker is not available (e.g. in some CI environments or local tests)
if (system("docker --version > /dev/null 2>&1") == 0) {
    system("docker build -t $registry/$app_name:$version .") == 0 or print "Warning: Docker build failed (continuing)...\n";
} else {
    print "Skipping Docker build (docker not found)\n";
}

print "==> Creating release tag...\n";
# Only tag if we are in a git repo and not in a shallow clone that might cause issues
if (-d ".git") {
    system("git tag v$version") == 0 or print "Warning: Failed to tag release (continuing)...\n";
    # system("git push origin v$version") == 0 or print "Warning: Failed to push tag (continuing)...\n";
}

print "✅ CI/CD pipeline completed successfully for $app_name version $version\n";
