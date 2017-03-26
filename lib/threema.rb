require 'dotenv/load'

require 'threema/version'
require 'threema/exceptions'
require 'threema/util'
require 'threema/client'
require 'threema/account'
require 'threema/lookup'
require 'threema/capabilities'
require 'threema/blob'
require 'threema/send'
require 'threema/receive'
require 'threema/e2e'
require 'threema/typed_message'

# creates instances for communicating with the Threema Gateway
class Threema
  attr_reader :client, :private_key, :api_identity, :api_secret

  def initialize(api_identity: nil, api_secret: nil, private_key: nil)
    @api_identity = api_identity || ENV['THREEMARB_API_IDENTITY']
    @api_secret   = api_secret   || ENV['THREEMARB_API_SECRET']
    @private_key  = private_key  || ENV['THREEMARB_PRIVATE']

    @client = Threema::Client.new(
      api_identity: @api_identity,
      api_secret:   @api_secret,
    )
  end

  def send(args)
    raise ArgumentError, "Parameter ':type' is required" if args[:type].blank?
    sender.public_send(args.delete(:type), args)
  end

  def receive(args)
    args[:threema] = self
    Threema::Receive.e2e(args)
  end

  private

  def sender
    @sender ||= Threema::Send.new(threema: self)
  end
end
