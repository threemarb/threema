def mock_pubkey(threema_id, public_key)
  stub_request(:get, Threema::Lookup.filled_url(:threema_id, threema_id))
    .with(query: test_auth_params)
    .to_return(
      body:   public_key,
      status: 200
    )
end

def mock_capabilities(threema_id, capabilities = '')
  stub_request(:get, Threema::Capabilities.url(threema_id))
    .with(
      query: test_auth_params
    )
    .to_return(
      status: 200,
      body:   capabilities
    )
end

def mock_upload
  stub_request(:post, Threema::Blob.url(:upload))
    .with(
      query:   test_auth_params,
      headers: {
        'Content-Type' => %r{multipart/form-data;}
      },
    )
    .to_return(
      body:   test_blob_id,
      status: 200
    )
end

def mock_error(code)
  stub_request(:any, /#{Threema::Client::API_URL}/).to_return(status: code)
end
