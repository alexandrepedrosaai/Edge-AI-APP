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
}

dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.8.0")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.7.0")
    implementation("ch.qos.logback:logback-classic:1.5.0")
    implementation("org.jetbrains.kotlinx:kotlin-deeplearning-api:0.5.0")
    implementation("org.jetbrains.kotlinx:kotlin-deeplearning-onnx:0.5.0")
    implementation("org.jetbrains.kotlinx:kotlin-deeplearning-tensorflow:0.5.0")
    implementation("org.deeplearning4j:deeplearning4j-core:1.0.0-M2.1")
    implementation("org.nd4j:nd4j-native-platform:1.0.0-M2.1")
    implementation("org.apache.mxnet:mxnet-full_2.11-linux-x86_64-gpu:1.9.1")
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
    
    val runtimeClasspath = configurations.runtimeClasspath.get()
    dependsOn(runtimeClasspath)
    
    from({
        runtimeClasspath.filter { it.name.endsWith("jar") }.map { zipTree(it) }
    })
    
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}
