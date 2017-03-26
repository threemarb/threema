require 'spec_helper'

RSpec.describe Threema::Receive::Image do
  it 'returns file content' do
    byte_string = 'imagecontent'.b
    nonce       = Threema::E2e.nonce

    crypted_byte_string = Threema::E2e::PublicKey.encrypt(
      data:        byte_string,
      private_key: test_private_key,
      public_key:  test_public_key,
      nonce:       nonce,
    )

    blob_id       = test_blob_id
    blob_id_bytes = Threema::Util.unhexify(blob_id)

    content = [blob_id_bytes, crypted_byte_string.size, nonce].pack(Threema::E2e::Image::FORMAT)

    stub_request(:get, Threema::Blob.download_url(blob_id))
      .with(
        query: test_auth_params
      )
      .to_return(
        status: 200,
        body:   crypted_byte_string,
      )

    instance = described_class.new(
      content:    content,
      public_key: test_public_key,
      threema:    build(:threema),
    )

    expect(instance.content).to eq(byte_string)
  end
end
