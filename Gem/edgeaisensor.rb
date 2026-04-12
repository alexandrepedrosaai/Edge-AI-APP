# edge_ai_sensor.rb
# Simulates sensor readings on an edge device
class Sensor
  def initialize(name)
    @name = name
  end

  def read_value
    rand(0.0..1.0) # normalized value
  end
end

sensor = Sensor.new("Temperature")
value = sensor.read_value
puts "Sensor #{@name} => value: #{value}"

# Simple AI logic at the edge
if value > 0.7
  puts "⚠️ Alert: value above threshold!"
else
  puts "✅ Value within safe range."
end
