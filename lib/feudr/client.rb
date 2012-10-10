require 'rest_client'
require 'json'

class FeudrClient
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
    @serverid = '%02d' % random(7)
    @urlbase = "http://game#{@serverid}.wordfeud.com/wf"
  end

  def post(location, body = [ ])
    uri = "#{@urlbase}/location"
    json = body.to_json
    RestClient.post(uri, json, :content_type => 'application/json')
  end

  def check_notifications
    post('user/notifications')
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
    }
  end

  def resign(game)
    post("#{game}/resign")
  end
end

