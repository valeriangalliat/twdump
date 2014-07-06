Twdump
======

Dump all tweets for a Twitter account.

Description
-----------

Twitter allows each user to download its own archive, but this operation
isn't easily scriptable and is limited to your own data.

**Twdump**'s purpose is to provide a simple tool to dump the last
3200 tweets of an account (the API don't allow to dump more than this),
and can dump the tweets fresher than a tweet ID.

The output is the raw JSON from Twitter API. Each line of output contains
the JSON object representing a tweet, so you should not parse the whole
output as JSON; get it line by line and parse each line at once.

Dependencies
------------

* `python3`
* `configobj` <https://pypi.python.org/pypi/configobj/5.0.5>
* `docopt` <https://pypi.python.org/pypi/docopt/0.6.2>
* `twitter` <https://pypi.python.org/pypi/twitter>

Installation
------------

After installing the dependencies above, you'll need to retrieve your
Twitter consumer key, secret, OAuth token and secret.

To get these, you need to [create a Twitter application](https://apps.twitter.com/app/new).
Once created, you'll find the keys in the "API Keys" tab.

Then, clone this repository and you can call `./twdump`.

Examples
--------

Dump all tweets for your account:

```sh
./twdump \
    --consumer-key "$consumer_key" \
    --consumer-secret "$consumer_key" \
    --oauth-token "$consumer_token" \
    --oauth-key "$consumer_key" \
    youraccount
```

Or with a config file to avoid passing all the commandline arguments:

```ini
#
# ./twdump.conf
#

consumer_key = ...
consumer_secret = ...
oauth_token = ...
oauth_secret = ...
```

```sh
./twdump --config twdump.conf youraccount
```

Dump all your tweets greater than the tweet with ID 12345:

```sh
./twdump --config twdump.conf --since 12345 youraccount
```
