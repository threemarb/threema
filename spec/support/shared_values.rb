def test_threema_id
  'EXMP1337'.freeze
end

def hello_world
  'Hello World'.freeze
end

def test_public_key
  ENV['THREEMARB_PUBLIC']
end

def test_private_key
  ENV['THREEMARB_PRIVATE']
end

def test_auth_params
  {
    from:   test_from,
    secret: test_api_secret,
  }
end

def test_from
  ENV['THREEMARB_API_IDENTITY']
end

def test_api_secret
  ENV['THREEMARB_API_SECRET']
end

def test_blob_id
  '12103bc93ae43a4a1b9ad24626969975'.freeze
end

def test_message_id
  'messageid1234567'.freeze
end
