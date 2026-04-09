package ai.edge

import kotlinx.coroutines.runBlocking
import org.jetbrains.kotlinx.dl.api.core.Sequential
import org.jetbrains.kotlinx.dl.api.core.layer.core.Dense
import org.jetbrains.kotlinx.dl.api.core.layer.core.Input
import org.jetbrains.kotlinx.dl.api.core.layer.activation.Relu
import org.jetbrains.kotlinx.dl.api.core.layer.activation.Softmax
import org.jetbrains.kotlinx.dl.dataset.mnist
import org.jetbrains.kotlinx.dl.api.core.optimizer.Adam
import org.jetbrains.kotlinx.dl.api.core.loss.Losses
import org.deeplearning4j.nn.conf.NeuralNetConfiguration
import org.deeplearning4j.nn.conf.layers.OutputLayer
import org.deeplearning4j.nn.conf.layers.DenseLayer
import org.deeplearning4j.nn.multilayer.MultiLayerNetwork
import org.nd4j.linalg.activations.Activation
import org.nd4j.linalg.lossfunctions.LossFunctions
import org.nd4j.linalg.factory.Nd4j
import java.io.File

object HybridDeepLearning {
    @JvmStatic
    fun main(args: Array<String>) = runBlocking {
        println("🚀 Edge-AI-APP Kotlin Hybrid Deep Learning iniciado!")

        // --- Parte 1: KotlinDL ---
        val (train, test) = mnist()
        val model = Sequential.of(
            Input(28, 28, 1),
            Dense(256),
            Relu(),
            Dense(128),
            Relu(),
            Dense(64),
            Relu(),
            Dense(10),
            Softmax()
        )
        model.use {
            it.compile(optimizer = Adam(), loss = Losses.SOFT_MAX_CROSS_ENTROPY)
            it.fit(dataset = train, epochs = 3, batchSize = 128)
            val accuracy = it.evaluate(dataset = test).accuracy
            println("📊 [KotlinDL] Acurácia MNIST = $accuracy")

            // Exportar modelo treinado
            val exportDir = File("models/kotlindl-mnist")
            exportDir.mkdirs()
            it.save(exportDir)
            println("💾 [KotlinDL] Modelo salvo em ${exportDir.absolutePath}")
        }

        // --- Parte 2: DL4J ---
        val conf = NeuralNetConfiguration.Builder()
            .updater(org.nd4j.linalg.learning.config.Adam(0.001))
            .list()
            .layer(DenseLayer.Builder().nIn(784).nOut(256).activation(Activation.RELU).build())
            .layer(DenseLayer.Builder().nIn(256).nOut(128).activation(Activation.RELU).build())
            .layer(DenseLayer.Builder().nIn(128).nOut(64).activation(Activation.RELU).build())
            .layer(OutputLayer.Builder(LossFunctions.LossFunction.NEGATIVELOGLIKELIHOOD)
                .activation(Activation.SOFTMAX)
                .nIn(64).nOut(10).build())
            .build()

        val dl4jModel = MultiLayerNetwork(conf)
        dl4jModel.init()
        println("⚙️ [DL4J] Modelo inicializado com configuração customizada.")

        // Simulação de batch de entrada
        val input = Nd4j.rand(intArrayOf(1, 784))
        val output = dl4jModel.output(input)
        println("🔮 [DL4J] Previsão simulada: $output")
    }
}
