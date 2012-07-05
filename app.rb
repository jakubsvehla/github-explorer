module Github

  class Explorer < Sinatra::Base

    get '/' do
      @path, resp = explore(params[:path])
      @json = JSON.pretty_generate(resp.body) # only if resp.body
      erb :index
    end

    get '/routes' do
      @categories = Category.all
      erb :routes
    end

    get '/user' do
      @user = current_user
      erb :user
    end

    get '/bouncer' do
      erb :bouncer
    end

    private

    def explore(path)

      if path.to_s.empty?
        path = current_user ? '/user' : '/users/jakubsvehla'
      end

      # Normalize the path
      path = path.prepend '/' unless path.start_with? '/'

      # Does the path match any GET route?
      route = Route.match(path)

      if route && current_user
        current_user.explored!(route)
      end

      resp = connection.get(path)

      # Unauthorized!
      if resp.status == 401
        redirect '/bouncer'
      end

      [path, resp]

    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id])
    end

    def connection
      return @connection if defined? @connection

      @connection = Faraday.new 'https://api.github.com/' do |builder|
        builder.use Github::Response::ParseJson
        builder.adapter Faraday.default_adapter
      end

      @connection.params[:access_token] = current_user.access_token if current_user
      @connection.headers[:user_agent] = "GitHub Explorer"
      @connection
    end

  end

  class Auth < Sinatra::Base

    get '/login' do
      redirect client.auth_code.authorize_url(redirect_uri: redirect_uri)
    end

    get '/callback' do
      access_token = client.auth_code.get_token(params[:code], redirect_uri: redirect_uri)

      auth = access_token.get('/user').parsed

      user = User.find_or_create_by_auth_hash(auth)
      user.access_token = access_token.token
      user.save

      session[:user_id] = user.id
      
      redirect '/'
    end

    get '/logout' do
      session[:user_id] = nil
      redirect '/'
    end

    private
  
    def client
      @client ||= OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
        site: 'https://api.github.com',
        authorize_url: 'https://github.com/login/oauth/authorize',
        token_url: 'https://github.com/login/oauth/access_token'
      })
    end

    def redirect_uri
      uri = URI.parse(request.url)
      uri.path = '/auth/callback'
      uri.query = nil
      uri.to_s
    end

  end

  module Response
    class ParseJson < Faraday::Response::Middleware
      def on_complete(env)
        if env[:body].empty?
          env[:body] = nil
        else
          env[:body] = MultiJson.load(env[:body])
        end
      end
    end
  end

end
