require 'twitter'
require 'json'

consumer_key        = ENV['CCCAMP2015_TA_CK']
consumer_secret     = ENV['CCCAMP2015_TA_CS']
access_token        = ENV['CCCAMP2015_TA_AT']
access_token_secret = ENV['CCCAMP2015_TA_ATS']

twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = consumer_key
  config.consumer_secret     = consumer_secret
  config.access_token        = access_token
  config.access_token_secret = access_token_secret
end

archive      = {}
archive_file = 'cccamp2015_archive.json'
if File.exist?( archive_file )

  File.open( archive_file, 'r' ) { |archive_file_handle|

    archive = JSON.load(archive_file_handle)
  }
end

state      = {}
state_file = 'cccamp2015_state.json'
if File.exist?( state_file )

  File.open( state_file, 'r' ) { |state_file_handle|

    state = JSON.load(state_file_handle)
  }
end


%w( cccamp2015 cccamp cccamp15 rad1o rad1obadge ).each { |hashtag|

begin

  search_options = {
    result_type: 'recent'
  }

  if archive && !archive.empty? && state[ hashtag ]
    search_options[:since_id] = state[ hashtag ].to_i
  end

  twitter_client.search("##{hashtag} -rt", search_options).each { |tweet|

    next if archive[ tweet.id ]

    archive[ tweet.id ] = {
      text:                    tweet.full_text.to_s,
      user:                    tweet.user.screen_name,
      user_id:                 tweet.user.id,
      uri:                     tweet.uri.to_s,
      created_at:              tweet.created_at.to_s,
      in_reply_to_screen_name: tweet.in_reply_to_screen_name.to_s,
      in_reply_to_status_id:   tweet.in_reply_to_status_id.to_i,
      lang:                    tweet.lang.to_s,
      source:                  tweet.source.to_s,
    }
  }

# NOTE: The process could go to sleep for up to 15 minutes but if you
# retry any sooner, it will almost certainly fail with the same exception.
rescue Twitter::Error::TooManyRequests => error

  p "Rate limit reached in hashtag '#{hashtag}' dump. Dumping current archive state and sleeping for #{error.rate_limit.reset_in} seconds"

  File.open( archive_file, 'w' ) { |archive_file_handle|

    JSON.dump(archive, archive_file_handle)
  }

  state[ hashtag ] = archive.keys.sort { |x,y| x.to_i <=> y.to_i }.last
  File.open( state_file, 'w' ) { |state_file_handle|

    JSON.dump(state, state_file_handle)
  }

  sleep error.rate_limit.reset_in + 1
  retry
end

  state[ hashtag ] = archive.keys.sort { |x,y| x.to_i <=> y.to_i }.last
  File.open( state_file, 'w' ) { |state_file_handle|

    JSON.dump(state, state_file_handle)
  }
}


File.open( archive_file, 'w' ) { |archive_file_handle|

  archive = JSON.dump(archive, archive_file_handle)
}
