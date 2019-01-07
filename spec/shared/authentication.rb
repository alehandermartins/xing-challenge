shared_examples_for "needs authentication" do |rest_method, action|

  it "denies access to unauthorized requests" do
    allow(request.env['warden']).to receive(:authenticate!).and_call_original
    self.send(rest_method, action, params: params) if self.respond_to?(:params)
    self.send(rest_method, action) unless self.respond_to?(:params)
    expect(response).to have_http_status(:unauthorized)   
  end
end