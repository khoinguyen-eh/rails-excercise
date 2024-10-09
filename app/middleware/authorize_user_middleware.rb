class AuthorizeUserMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if exempt_route?(request.path, request.request_method)
      return @app.call(env)
    end

    token = env['HTTP_AUTHORIZATION']&.split(' ')&.last
    user_id = get_user_id(token)

    if token && user_id
      env['current_user_id'] = user_id
      @app.call(env)
    else
      [401, { 'Content-Type' => 'application/json' }, [{ error: 'Unauthorized' }.to_json]]
    end
  end

  private

  def exempt_route?(path, method)
    AUTH_EXEMPT_ROUTES.any? do |route|
      matches_path?(path, route['path']) && matches_method?(method, route['methods'])
    end
  end

  def matches_path?(path, route_path)
    regex_pattern = route_path.start_with?('^') ? Regexp.new(route_path) : Regexp.new("^#{Regexp.escape(route_path)}$")
    path.match?(regex_pattern)
  end

  def matches_method?(method, methods)
    methods.nil? || methods.include?(method)
  end

  def get_user_id(token)
    unless token
      return nil
    end

    user_id = $redis.get("user_token:#{token}")
    user_id.to_i
  end
end