require 'rest_client'
require 'json'
require 'digest/sha1'
require 'hashie'

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

  attr_accessor :username, :userId

  BoardTypes = [
      "Normal",
      "Random"
  ]

  def rules(i)
      return RuleNames[i]
  end

  def board_type(i)
      return i==0 ? "Normal" : "Random ##{i}"
  end

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
    parsed = Hashie::Mash.new(JSON.parse(response))
    if parsed.status == 'success' then
        return parsed.content
    end

    raise Error, location
  end

  def get(location)
    uri = "#{@urlbase}/#{location}"
    response = RestClient.get(uri, :content_type => 'application/json', :cookies => @cookies)
    if response.cookies['sessionid'] then
        @cookies['sessionid'] = response.cookies['sessionid']
    end
    parsed = Mash.new(JSON.parse(response))
    if parsed.status == 'success' then
        return parsed.content
    end

    raise Error, location
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
    post(
        'user/login/',
        'username'  => username,
        'password'  => hash_password(password)
    )
  end

  def login_with_email(email, password)
    result = post(
        'user/login/email/',
        'email'     => email,
        'password'  => hash_password(password)
    )
    @username = result.username
    @userId = result.id
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

  def game(id)
    result = get("game/#{id}")
    return result.game
  end

  def board(id, move=0)
    result = get("board/#{id}")
    return result.board
  end

  def relationships
    result = post('user/relationships/')
    return result.relationships
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
    result = post('user/games/')
    return result.games
  end

  def rulename(i)
      return RuleNames[i]
  end

  def boardtype(i)
      return BoardTypes[i]
  end
end

end

