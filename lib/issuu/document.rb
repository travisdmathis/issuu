module Issuu
  class Document
    class << self
      def default_upload_params
        {
          :access           => "private",
          :action           => "issuu.document.upload",
          #:description      =>  "",
          #:downloadable     => true,
          :commentsAllowed  => false,
          :ratingsAllowed   => false,
          :apiKey           => Issuu.api_key,
          :format           => "json",
          #:name             => "test"
        }
      end
      
      def url_upload(url, params={})
        url = URI.parse('http://api.issuu.com/1_0?')
        url_upload_params = {
          :action => "issuu.document.url_upload",
          :apiKey => Issuu.api_key,
          :format => "json",
          :slurpUrl => url
        }
        Cli.http_post(url, url_upload_params.merge(params))
      end
      
      def upload(file_path, file_type, params={})
        file_to_upload = UploadIO.new(file_path, file_type)
        url = URI.parse('http://upload.issuu.com/1_0?')
        upload_params = default_upload_params.update(params)
        
        Cli.http_multipart_post(url, upload_params.merge({:file => file_to_upload}))
      end
      
      def update(filename, params={})
        url = URI.parse('http://api.issuu.com/1_0?')
        update_params = {
          :action => "issuu.document.update",
          :apiKey => Issuu.api_key,
          :format => "json",
          :name => filename
        }
        
        Cli.http_post(url, update_params.merge(params))
      end
      
      def list(params={})
        url = URI.parse('http://api.issuu.com/1_0')
        list_params = {
          :action => "issuu.documents.list",
          :apiKey => Issuu.api_key,
          :responseParams => "title,description",
          :format => "json"
        }
        
        Cli.http_get(url, list_params.merge(params))
      end
      
      def delete(filenames)
        url = URI.parse('http://api.issuu.com/1_0?')
        delete_params = {
          :action => "issuu.document.delete",
          :apiKey => Issuu.api_key,
          :format => "json",
          :names => filenames.join(',')
        }
        
        Cli.http_post(url, delete_params)
      end
    end
  end
end