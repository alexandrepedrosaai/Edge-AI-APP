plugins {
    kotlin("jvm") version "2.0.0"
    application
    id("org.jetbrains.kotlin.plugin.serialization") version "2.0.0"
}

group = "ai.edge"
version = "1.1.0"

repositories {
    mavenCentral()
    maven { url = uri("https://oss.sonatype.org/content/repositories/snapshots/") }
    // Apache MXNet repository (MXNet is only available up to 1.5.1 in Maven)
    maven { url = uri("https://repository.apache.org/content/repositories/releases/") }
}

val ktorVersion = "2.3.12"

dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.8.0")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.0")
    implementation("ch.qos.logback:logback-classic:1.5.0")

    // KotlinDL deep learning
    implementation("org.jetbrains.kotlinx:kotlin-deeplearning-api:0.5.0")
    implementation("org.jetbrains.kotlinx:kotlin-deeplearning-onnx:0.5.0")
    implementation("org.jetbrains.kotlinx:kotlin-deeplearning-tensorflow:0.5.0")

    // DL4J / ND4J
    implementation("org.deeplearning4j:deeplearning4j-core:1.0.0-M2.1")
    implementation("org.nd4j:nd4j-native-platform:1.0.0-M2.1")

    // MXNet: version 1.9.1 does not exist in any public Maven repository.
    // The latest available version is 1.5.1, hosted only on the Apache repository.
    // Using CPU variant to avoid GPU driver requirements in CI environments.
    implementation("org.apache.mxnet:mxnet-full_2.11-linux-x86_64-cpu:1.5.1")

    // Ktor 2.x server (App.kt)
    implementation("io.ktor:ktor-server-core:$ktorVersion")
    implementation("io.ktor:ktor-server-netty:$ktorVersion")
    implementation("io.ktor:ktor-server-content-negotiation:$ktorVersion")
    implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")

    testImplementation(kotlin("test"))
}

application {
    mainClass.set("ai.edge.EdgeAiServiceKt")
}

tasks.test {
    useJUnitPlatform()
}

tasks.register<Jar>("fatJar") {
    archiveBaseName.set("edge-ai-kotlin")
    archiveClassifier.set("all")

    manifest {
        attributes["Main-Class"] = "ai.edge.EdgeAiServiceKt"
    }

    from(sourceSets.main.get().output)

    val runtimeCp = configurations.runtimeClasspath.get()
    dependsOn(runtimeCp)

    from({
        runtimeCp.filter { it.name.endsWith("jar") }.map { zipTree(it) }
    }) {
        exclude(
            "META-INF/*.SF",
            "META-INF/*.DSA",
            "META-INF/*.RSA",
            "META-INF/LICENSE",
            "META-INF/LICENSE.txt",
            "META-INF/NOTICE",
            "META-INF/NOTICE.txt",
            "META-INF/DEPENDENCIES",
            "META-INF/MANIFEST.MF",
            "META-INF/maven/**",
            "META-INF/versions/**",
            "META-INF/native-image/**",
            "META-INF/proguard/**",
            "META-INF/services/javax.*",
            "**/*.proto",
            "**/*.kotlin_module",
            "module-info.class"
        )
    }

    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}
