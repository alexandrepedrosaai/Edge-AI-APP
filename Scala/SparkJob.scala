import org.apache.spark.sql.SparkSession

class SparkJob(appName: String) {
  private val spark = SparkSession.builder()
    .appName(appName)
    .getOrCreate()

  def run(): Unit = {
    val df = spark.read.option("header", "true").csv("data/input.csv")
    df.show()
  }
}
