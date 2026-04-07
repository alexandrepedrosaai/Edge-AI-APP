library(DBI)

con <- dbConnect(RMySQL::MySQL(),
                 dbname = "edge_ai_app",
                 host = "127.0.0.1",
                 user = "root",
                 password = "root")

readings <- dbGetQuery(con, "SELECT * FROM sensor_readings")

# Normalizar valores
readings$value_norm <- readings$value / max(readings$value)

# Estatísticas avançadas
avg_val <- mean(readings$value_norm)
sd_val <- sd(readings$value_norm)

# Gravar resultados em tabela de análises
dbExecute(con, "INSERT INTO sensor_analysis (avg_value, sd_value, analysis_time)
                VALUES (?, ?, NOW())",
          params = list(avg_val, sd_val))

dbDisconnect(con)
