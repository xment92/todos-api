require 'swagger_helper'

RSpec.describe 'users', type: :request do

  path '/signup' do
    let!(:user) { {name: "Test", email: "test@example.com", password: "password", password_confirmation:"password"} }
   
    post('create user') do
      
      response(201, 'successful') do
        consumes 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            email: { type: :string },
            password: {type: :string},
            password_confirmation: {type: :string}
          },
          required: %w[name email password password_confirmation]
        }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  

  path '/auth/login' do
    let!(:user) {create(:user)}
    post 'Authenticates a user and returns an authentication token' do
      tags ['Authentication']
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, format: :password, example: 'password123' }
        },
        required: %w[email password]
      }
      response '200', 'Authentication successful' do
        let(:credentials) {{email: user.email, password:'foobar'}}
        schema type: :object,
               properties: {
                 auth_token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' }
               }
        run_test!
      end
      response '401', 'Invalid credentials' do
        let(:credentials) {{email: user.email, password:'wrong'}}
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Invalid credentials' }
               }
        run_test!
      end
    end
  end
end