require 'swagger_helper'

describe 'Application  API' do 
    before(:each) do 
        if User.exists?(username: "foo")
            User.find_by(username: "foo").delete
        end
        User.create(username: "foo", password: "foobar", is_admin: true)
    end
    path '/api/v1/application' do
        get 'Gets a list of applications' do 
            tags 'Application'
            security [ basic: [] ]
            consumes 'application/json'
            parameter name: :accept, in: :header

            response '200', 'Applications' do
                let(:Authorization) { "Basic #{::Base64.strict_encode64('foo:foobar')}" }
                run_test!
            end
            response '401', 'Auth required' do 
                let(:accept) { 'application/json' }
                let(:Authorization) { "Ba #{::Base64.strict_encode64('foo:fooba')}" }
                run_test!
            end
        end

        post 'Creates an application' do 
            tags 'Application'
            security [ basic: [] ]
            consumes 'application/json'
            parameter name: :application, in: :body, schema: {
                type: :object, 
                properties: {
                    name: { type: :string },
                    redirect_uri: { type: :string },
                    scopes: { type: :array, items: { type: :string }},
                    confidential: { type: :boolean, default: true }
                }
            }

            response '201', 'application created' do 
                let(:Authorization) { "Basic #{::Base64.strict_encode64('foo:foobar')}" }
                let(:application) { { name: 'foo', redirect_uri: 'http://localhost:3000' }}
                run_test!
            end

            response '500', 'Invalid parameters' do 
                let(:Authorization) { "Basic #{::Base64.strict_encode64('foo:foobar')}" }
                let(:application) { { name: 'foo', redirect_uri: 'localhost' }}
                run_test!
            end

            response '302', 'login required' do 
                let(:Authorization) { "Basic #{::Base64.strict_encode64('food@bar.com:foobar')}" }
                let(:application) { { name: 'foo', redirect_uri: 'http://localhost:3000' }}
                run_test!
            end
        end

    end
end
