package ai.edge

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

// Modelo de dados
@Serializable
data class Message(val id: Int, val text: String)

fun startServer() {
    embeddedServer(Netty, port = 8080) {
        install(ContentNegotiation) {
            json(Json { prettyPrint = true })
        }

        routing {
            // Endpoint raiz
            get("/") {
                call.respondText("Edge-AI-APP running on Kotlin + Azure!", ContentType.Text.Plain)
            }

            // Endpoint de status
            get("/status") {
                call.respond(mapOf("status" to "ok", "service" to "Edge-AI-APP"))
            }

            // Endpoint que retorna lista de mensagens
            get("/messages") {
                val messages = listOf(
                    Message(1, "Hello from Kotlin!"),
                    Message(2, "Integrated with Azure App Service"),
                    Message(3, "Part of Edge-AI-APP ecosystem")
                )
                call.respond(messages)
            }

            // Endpoint que recebe POST com JSON
            post("/messages") {
                val newMessage = call.receive<Message>()
                call.respond(HttpStatusCode.Created, newMessage)
            }
        }
    }.start(wait = true)
}
