module Ephemeral
  module Resources
    class File < Grape::API
      @@files = {}
      
      desc 'Creates a new file'
      params do
        requires :file, desc: 'File to upload'
      end

      post do
        file_model = Ephemeral::Models::File.new(params)
        @@files[file_model.id] = file_model
        present file_model, with:Ephemeral::Entities::File
      end
    end
  end
end