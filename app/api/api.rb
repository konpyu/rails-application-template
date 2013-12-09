class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::Jbuilder

  desc 'hello world'
  get 'hello', jbuilder: 'hello' do
    @msg = "hello world"
  end
end
