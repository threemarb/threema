require 'case_transform'

class Threema
  class Lookup
    URL_PATH = {
      threema_id: '/pubkeys/%{threema_id}',
      phone:      '/lookup/phone/%{phone}',
      phone_hash: '/lookup/phone_hash/%{phone_hash}',
      email:      '/lookup/email/%{email}',
      email_hash: '/lookup/email_hash/%{email_hash}',
      bulk:       '/lookup/bulk',
    }.freeze

    class << self
      def filled_url(resource, param)
        format(url(resource), resource => param)
      end

      def url(resource)
        path = URL_PATH[resource]
        raise ArgumentError, "Unknown resource '#{resource}'" if !path
        Threema::Client.url(path)
      end
    end

    def initialize(threema:)
      @threema = threema
    end

    def key(threema_id)
      by(:threema_id, threema_id)
    end

    def phone(phone)
      by(:phone, phone)
    end

    def phone_hash(phone_hash)
      by(:phone_hash, phone_hash)
    end

    def email(email)
      by(:email, email)
    end

    def email_hash(email_hash)
      by(:email_hash, email_hash)
    end

    def by(type, identifier)
      @threema.client.not_found_ok do
        @threema.client.get(self.class.filled_url(type, identifier))
      end
    end

    def bulk(params)
      payload  = keys_camel_lower(params)
      response = @threema.client.post_json(self.class.url(:bulk), payload: payload)
      underscore_entry_keys(response)
    end

    private

    def keys_camel_lower(params)
      cameled = {}
      params.each do |key, value|
        cameled[CaseTransform.camel_lower(key.to_s)] = value
      end
      cameled
    end

    def underscore_entry_keys(list)
      list.collect do |response_entry|
        result_entry = {}
        response_entry.each do |key, value|
          result_entry[CaseTransform.underscore(key).to_sym] = value
        end

        result_entry
      end
    end
  end
end
