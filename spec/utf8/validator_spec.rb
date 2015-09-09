require 'spec_helper'

describe Utf8::Validator do
  include Rack::Test::Methods
  
  it 'has a version number' do
    expect(Utf8::Validator::VERSION).not_to be nil
  end

  let(:app) { Utf8::Validator.new(proc {[200, {}, []]}) }
  
  # it 'does something useful' do
  #   response = request.get('/')
  #   expect(response.status).to eq(200)
  # end

  let(:valid_headers) { {} }
  let(:valid_body)    { [] }
  let(:valid_uri)     { "/" }
  
  it "returns a 400 with an invalid header" 
  it "returns a 400 with an invalid request URI" do
    path = "/\xBF"

    # TODO: rack-test and rack-mock both rely on URI.parse which
    # rejects non UTF-8 characters. It would be nice to find a less
    # hacky way to get rack to accept our request so the middleware
    # can deal with it.
    uri = URI::HTTP.new(nil, nil, "", nil, nil, path, nil, nil, nil)
    URI::RFC2396_Parser.any_instance.stub(:parse).with("//" + path + "?") { uri }
    URI.stub(:parse).with(path) { uri }
    
    get(path)
    expect(last_response.status).to eq(400)
  end

  it "returns a 400 with an invalid body"
 
  it "returns a 200 when the header, URI, and body are valid" do
    post(valid_uri, valid_body, valid_headers)
    expect(last_response.status).to eq(200)
  end
end
