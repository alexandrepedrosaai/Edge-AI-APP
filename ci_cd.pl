#!/usr/bin/perl
use strict;
use warnings;

my $app_name = $ENV{'APP_NAME'} // "edge-ai-kotlin";
my $version  = $ENV{'VERSION'}  // "1.0." . time();
my $registry = $ENV{'REGISTRY'} // "dockerhub.io/edge-ai";

print "==> Building project...\n";
system("./gradlew clean build fatJar --no-daemon") == 0 or die "Build failed!\n";

print "==> Running unit tests...\n";
system("./gradlew test") == 0 or die "Tests failed!\n";

print "==> Packaging binary...\n";
system("mkdir -p artifacts") == 0 or die "Failed to create artifacts dir!\n";
system("cp src/main/kotlin/build/libs/*.jar artifacts/$app_name-$version.jar") == 0 or die "Failed to copy JAR!\n";

print "==> Building Docker image...\n";
system("docker build -t $registry/$app_name:$version .") == 0 or die "Docker build failed!\n";

print "==> Pushing Docker image...\n";
system("docker push $registry/$app_name:$version") == 0 or die "Docker push failed!\n";

print "==> Creating release tag...\n";
system("git tag v$version") == 0 or die "Failed to tag release!\n";
system("git push origin v$version") == 0 or die "Failed to push tag!\n";

print "==> Deploying version $version...\n";
system("./scripts/deploy.sh $version") == 0 or die "Deployment failed!\n";

print "✅ CI/CD pipeline completed successfully for $app_name version $version\n";
