object DataTransform {
  def normalize(values: Seq[Double]): Seq[Double] = {
    val max = values.max
    val min = values.min
    values.map(v => (v - min) / (max - min))
  }
}
