package ai.edge;

import spark.Spark;

public class EdgeService {
    public static void main(String[] args) {
        Spark.port(8080);

        Spark.get("/status", (req, res) -> {
            res.type("application/json");
            return "{\"status\":\"ok\",\"service\":\"Edge-AI-APP Java\"}";
        });

        Spark.get("/predict", (req, res) -> {
            // Aqui entraria lógica de ML
            return "{\"prediction\":\"demo\"}";
        });
    }
}
