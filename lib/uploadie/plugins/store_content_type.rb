class Uploadie
  module Plugins
    module StoreContentType
      module InstanceMethods
        def upload(io, *)
          uploaded_file = super
          uploaded_file.metadata["content_type"] = extract_content_type(io)
          uploaded_file
        end

        private

        def extract_content_type(io)
          if io.respond_to?(:content_type)
            io.content_type
          elsif filename = extract_filename(io)
            if defined?(MIME::Types)
              content_type = MIME::Types.of(filename).first
              content_type.to_s if content_type
            end
          end
        end
      end

      module FileMethods
        def content_type
          metadata.fetch("content_type")
        end
      end
    end

    register_plugin(:store_content_type, StoreContentType)
  end
end
