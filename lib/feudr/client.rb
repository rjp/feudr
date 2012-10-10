require 'rest_client'
require 'json'

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
  end

  def post(location, body = [ ])
    uri = "#{@urlbase}/#{location}"
    p uri
    json = body.to_json
    p json
    return RestClient.post(uri, json, :content_type => 'application/json')
  end

  def login(userid, password)
    result = post(
        'user/login/',
        'id'        => userid,
        'password'  => password)

    if result['status'] != 'success' then
      raise Error, "Could not login: #{result['content']['message']}"
    end
  end

  def login_with_email(email, password)
    result = post(
        'user/login/',
        'email'     => email,
        'password'  => password)

    if result['status'] != 'success' then
      p result
      raise Error, "Could not login: #{result['content']['message']}"
    end
  end

  def check_notifications
    post('user/notifications')
  end

  def user_status
    post('user/status')
  end

  def user_search(username_or_email)
    post(
        'user/search',
        'username_or_email' => username_or_email)
  end

  def resume
    post('user/notifications/resume')
  end

  def relationships
    post('usr/relationships')
  end

  def invite(invitee, ruleset=0, boardtype='normal')
    post(
      'invite/new',
      'ruleset'    => ruleset,
      'boardtype'  => boardtype,
      'invitee'    => invitee)
  end

  def invite_random(ruleset=0, boardtype='normal')
    post(
        'random_request/create',
        'ruleset'   => ruleset,
        'boardtype' => boardtype)
  end

  def resign(game)
    post("#{game}/resign")
  end
end

end

