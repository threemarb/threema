require 'case_transform'
require 'threema/exceptions'

class Threema
  class Blob
    ID_SIZE  = 16
    URL_PATH = {
      download: '/blobs/%{blob_id}',
      upload:   '/upload_blob',
    }.freeze

    class << self
      def download_url(blob_id)
        format(url(:download), blob_id: blob_id)
      end

      def url(action)
        path = URL_PATH[action]
        raise ArgumentError, "Unknown action '#{action}'" if !path
        Threema::Client.url(path)
      end
    end

    def initialize(threema:)
      @threema = threema
    end

    def download(blob_id)
      @threema.client.not_found_ok do
        @threema.client.get(self.class.download_url(blob_id))
      end
    end

    def upload(file, content_type: 'text/plain')
      # TODO: Size check: http://stackoverflow.com/questions/6215889/getting-accurate-file-size-in-megabytes
      payload = {
        'blob' => UploadIO.new(file_handle(file), content_type, 'blob')
      }

      @threema.client.chargeable do
        @threema.client.post_multipart(self.class.url(:upload), payload: payload)
      end
    rescue RequestError => e
      message = ''
      case e.message
      when 'Net::HTTPBadRequest'
        message = 'required parameters are missing or the file is empty'
      when 'Net::HTTPPayloadTooLarge'
        message = 'file is too big'
      else
        raise
      end

      raise ArgumentError, message
    end

    private

    def file_handle(file)
      raise ArgumentError, "Missing parameter 'file'" if file.blank?
      return file if file.respond_to?(:read)
      raise ArgumentError, "Can't handle parameter class '#{file.class.name}'" if !file.is_a?(String)
      raise ArgumentError, "Can't read file '#{file}'" if !File.readable?(file)
      File.open(file)
    end
  end
end
