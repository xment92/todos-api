require 'swagger_helper'

def create_test_token
  user = User.create!(name: "Test", email: "test@example.com", password: "password")
  JsonWebToken.encode(user_id: user.id)
end 

RSpec.describe 'items', type: :request do
  let!(:todo) { Todo.create!(title: 'Test Todo', created_by: 'user') }
  let!(:todo_id) { todo.id }
  let!(:item) {Item.create!(name: "Test Item", done: false, todo_id: todo.id)}
  let!(:id) { item.id }
  let(:Authorization) { "Bearer #{create_test_token}" }

  path '/todos/{todo_id}/items' do
    # You'll want to customize the parameter types...
    parameter name: 'todo_id', in: :path, type: :string, description: 'todo_id'
    parameter name: :Authorization, in: :header, type: :string, required: true, description: 'Auth token'
    
    get('list items') do
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

    post('create item') do
      response(201, 'created') do
        
        consumes 'application/json'
        parameter name: :item, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            done: { type: :boolean },
            todo_id: {type: :integer }
          },
          required: %w[name done todo_id]
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

  path '/todos/{todo_id}/items/{id}' do
    # You'll want to customize the parameter types...
    parameter name: :Authorization, in: :header, type: :string, required: true, description: 'Auth token'
    parameter name: 'todo_id', in: :path, type: :string, description: 'todo_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show item') do
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

    patch('update item') do
      response(204, 'successful') do        

        after do |example|
          expect(response.body).to be_empty
        end
        run_test!
      end
    end

    put('update item') do
      response(204, 'successful') do        

        after do |example|
          expect(response.body).to be_empty
        end
        run_test!
      end
    end

    delete('delete item') do
      response(204, 'successful') do        

        after do |example|
          expect(response.body).to be_empty
        end
        run_test!
      end
    end
  end
end
