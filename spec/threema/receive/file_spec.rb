require 'spec_helper'

RSpec.describe Threema::Receive::File do
  include FakeFS::SpecHelpers
  FakeFS::FileSystem.clone('.')

  let(:content) { 'filecontent'.b }
  let(:mime_type) { 'text/plain' }
  let(:filename) { 'example.txt' }

  let(:instance) do
    secret_key = Threema::E2e::SecretKey.generate
    encrypted  = Threema::E2e::SecretKey.encrypt(
      key:   secret_key,
      data:  content,
      nonce: Threema::E2e::File::NONCE[:file],
    )

    blob_id = test_blob_id
    payload = JSON.generate(
      'b' => blob_id,
      'k' => Threema::Util.hexify(secret_key),
      'm' => mime_type,
      'n' => filename,
      's' => encrypted.bytesize,
      'i' => 0,
    )

    stub_request(:get, Threema::Blob.download_url(blob_id))
      .with(
        query: test_auth_params
      )
      .to_return(
        status: 200,
        body:   encrypted
      )

    described_class.new(
      content: payload,
      threema: build(:threema)
    )
  end

  it 'returns file content' do
    expect(instance.content).to eq(content)
  end

  it 'returns file mime_type' do
    expect(instance.mime_type).to eq(mime_type)
  end

  it 'returns file name' do
    expect(instance.name).to eq(filename)
  end
end
