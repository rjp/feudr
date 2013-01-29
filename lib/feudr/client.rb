require 'rest_client'
require 'json'
require 'digest/sha1'

module Feudr

class Client
  class Error < RuntimeError; end

  RuleNames = [
    'American',
    'Norwegian',
    'Dutch',
    'Danish',
    'Swedish',
    'English',
    'Spanish',
    'French',
  ]

  def initialize
    @serverid = '%02d' % rand(7)
    @urlbase = "http://game#{@serverid}.wordfeud.com/wf"
    @cookies = {}
  end

  def post(location, body = [ ])
    uri = "#{@urlbase}/#{location}"
    json = body.to_json
    response = RestClient.post(uri, json, :content_type => 'application/json', :cookies => @cookies)
    if response.cookies['sessionid'] then
        @cookies['sessionid'] = response.cookies['sessionid']
    end
    return JSON.parse(response)
  end

  def get(location)
    uri = "#{@urlbase}/#{location}"
    response = RestClient.get(uri, :content_type => 'application/json', :cookies => @cookies)
    if response.cookies['sessionid'] then
        @cookies['sessionid'] = response.cookies['sessionid']
    end
    if response.code == 301 then
        p response.headers
    end
    puts response
    return JSON.parse(response)
  end

  def check_success(result)
    if result['status'] != 'success' then
      raise Error, "Could not login: #{result['content']['message']}"
    end
  end

  def hash_password(password)
    return Digest::SHA1.hexdigest(password + 'JarJarBinks9')
  end

  def login(username, password)
    result = post(
        'user/login/',
        'username'  => username,
        'password'  => hash_password(password))
    check_success(result)
    return result
  end

  def login_with_email(email, password)
    result = post(
        'user/login/email/',
        'email'     => email,
        'password'  => hash_password(password))
    check_success(result)
    return result
  end

  def check_notifications
    post('user/notifications/')
  end

  def user_status
    post('user/status/')
  end

  def user_search(username_or_email)
    post(
        'user/search',
        'username_or_email' => username_or_email)
  end

  def resume
    post('user/notifications/resume/')
  end

  def relationships
    post('user/relationships/')
  end

  def invite(invitee, ruleset=0, boardtype='normal')
    post(
      'invite/new/',
      'ruleset'    => ruleset,
      'boardtype'  => boardtype,
      'invitee'    => invitee)
  end

  def invite_random(ruleset=0, boardtype='normal')
    post(
        'random_request/create/',
        'ruleset'   => ruleset,
        'boardtype' => boardtype)
  end

  def resign(game)
    post("#{game}/resign/")
  end

  def games()
    post('user/games/')
  end
end

end

