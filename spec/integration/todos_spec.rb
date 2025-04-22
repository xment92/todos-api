require 'swagger_helper'

def create_test_token
  user = User.create!(name: "Test", email: "test@example.com", password: "password")
  JsonWebToken.encode(user_id: user.id)
end 

RSpec.describe 'todos', type: :request do
  let(:Authorization) { "Bearer #{create_test_token}" }
  let!(:todo) { Todo.create!(title: 'Test Todo', created_by: 'user') }
  let!(:id) { todo.id }

  path '/todos' do
    parameter name: :Authorization, in: :header, type: :string, required: true, description: 'Auth token'

    get('list todos') do
      response(200, 'successful') do

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

    post('create todo') do
      response(201, 'successful') do
        consumes 'application/json'
        parameter name: :todo, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            created_by: { type: :string },
          },
          required: %w[title created_by]
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

  path '/todos/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'
    parameter name: :Authorization, in: :header, type: :string, required: true, description: 'Auth token'

    get('show todo') do
      response(200, 'successful') do
        
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

    patch('update todo') do
      response(204, 'successful') do
        

        after do |example|
          expect(response.body).to be_empty
        end
        run_test!
      end
    end

    put('update todo') do
      response(204, 'successful') do
        

        after do |example|
          expect(response.body).to be_empty
        end
        run_test!
      end
    end

    delete('delete todo') do
      response(204, 'successful') do


        after do |example|
          expect(response.body).to be_empty
        end
        run_test!
      end
    end
  end
end
