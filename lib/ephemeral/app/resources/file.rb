module Ephemeral
  module Resources
    class File < Grape::API
      @@files = {}
      
      desc 'Creates a new file'
      params do
        group :file, type: Hash do
          requires :filename, type: String, desc: 'File name', values: ["README.md"]
          requires :type, type: String, desc: 'File type', values: ["text/plain"]
        end
      end

      post do
        file_model = Ephemeral::Models::File.new(params)
        @@files[file_model.id] = file_model
        present file_model, with:Ephemeral::Entities::File
      end

      route_param :id do
        get do
          file_model = @@files[params[:id]]

          content_type file_model.type
          env['api.format'] = :binary
          header "Content-Disposition", "attachment; filename*=UTF-8''#{URI.escape(file_model.name)}"
          file_model.file
        end
      end
    end
  end
end