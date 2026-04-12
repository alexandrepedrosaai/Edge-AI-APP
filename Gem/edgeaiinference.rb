# edge_ai_inference.rb
# Simulates inference of a lightweight model at the edge
class EdgeModel
  def predict(input)
    # Simple rule-based model: if input > 0.5, classify as 'active'
    input > 0.5 ? "active" : "inactive"
  end
end

model = EdgeModel.new
data = [0.2, 0.6, 0.8, 0.3]

data.each do |d|
  puts "Input: #{d} => Result: #{model.predict(d)}"
end
