require "aws-sdk"
require "base64"
require "sinatra"
require "yaml"

YAML.load_file("credentials.yml").each { |key, value| ENV[key] = value }

helpers do
  def rekognition_tags(blob)
    client = Aws::Rekognition::Client.new
    response = client.detect_labels image: { bytes: blob }
    response.labels.map(&:name)
  end
end

get "/" do
  erb :index
end

post "/picture" do
  file = params[:file]
  erb :show, locals: { file_name: file[:filename], blob: file[:tempfile] }
end
