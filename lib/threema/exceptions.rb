class CreditError < StandardError
end

class Unauthorized < StandardError
end

class RemoteError < StandardError
end

class RequestError < StandardError
  attr_accessor :object

  def initialize(message = nil, object = nil)
    super(message)
    self.object = object
  end
end
