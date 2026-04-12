# edge_ai_pipeline_test.rb
require 'minitest/autorun'

class EdgeModel
  def predict(input)
    input > 0.5 ? "active" : "inactive"
  end
end

class EdgePipelineTest < Minitest::Test
  def test_inference
    model = EdgeModel.new
    assert_equal "active", model.predict(0.9)
    assert_equal "inactive", model.predict(0.1)
  end
end
