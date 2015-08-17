# CCCamp 2015 tweet archive

This repository contains a JSON file of all tweets with the hashtags #cccamp2015 #cccamp15 and #cccamp since 2015-08-08 22:38:29 +0200 and a Ruby script to update it.

## Archive

The JSON file 'cccamp2015_archive.json' contains the archive. Archived information are:

- id
- user
- user_id
- text
- uri
- created_at
- in_reply_to_screen_name
- in_reply_to_status_id
- lang
- source

Example:

```
[
  ...
    "631796042321776640": {
        "text": "I made a duct tape head for @MrThorstenEckel #cccamp15 http://t.co/lCh3euAUXy",
        "user": "frank_zabel",
        "user_id": 114574459,
        "uri": "https://twitter.com/frank_zabel/status/631796042321776640",
        "created_at": "2015-08-13 13:54:49 +0200",
        "in_reply_to_screen_name": "",
        "in_reply_to_status_id": 0,
        "lang": "en",
        "source": "<a href=\"http://tapbots.com/tweetbot\" rel=\"nofollow\">Tweetbot for iΟS</a>"
    },
  ...
]
```

## Update archive

There is a Ruby script that updates the archive file 'cccamp2015_archive.json' starting with the last tweet ID in 'cccamp2015_state.json' for each hashtag.

Befor using it make sure you have installed the dependencies via:

```
bundle install
```

After that export your twitter credentials via:
(You need an own App for that: https://apps.twitter.com/ )

```
export CCCAMP2015_TA_CK='...' # consumer_key
export CCCAMP2015_TA_CS='...' # consumer_secret
export CCCAMP2015_TA_AT='...' # access_token
export CCCAMP2015_TA_ATS='...' # access_token_secret
```

After that you can run the script via:

```
./tweet_archiver.rb
```

