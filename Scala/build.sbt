name := "EdgeAIAPP"
version := "0.1"
scalaVersion := "2.13.12"


libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % "3.2.0" % "provided",
  "org.apache.spark" %% "spark-sql" % "3.2.0" % "provided"
)
