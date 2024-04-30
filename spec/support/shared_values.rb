# frozen_string_literal: true

def test_threema_id
  'EXMP1337'
end

def hello_world
  'Hello World'
end

def test_public_key
  '2edf856e8a0f8f8e761be57f895f8827f42c6be0c6c891b95494faa7d264f7d9'
end

def test_private_key
  '2edf856e8a0f8f8e761be57f895f8827f42c6be0c6c891b95494faa7d264f7d9'
end

def test_auth_params
  {
    from: test_from,
    secret: test_api_secret
  }
end

def test_from
  '*VALID1'
end

def test_api_secret
  'CWWuNaFDkEZLiRSt'
end

def test_blob_id
  '12103bc93ae43a4a1b9ad24626969975'
end

def test_message_id
  'messageid1234567'
end
