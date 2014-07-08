`twdump`
========

Dump all tweets for a Twitter account.

Description
-----------

Twitter allows each user to download its own archive, but this operation
isn't easily scriptable and is limited to your own data.

`twdump`'s purpose is to provide a simple tool to dump the last
3200 tweets of an account (the API don't allow to dump more than this),
and can dump the tweets fresher than a tweet ID.

The output is the raw JSON from Twitter API. Each line of output contains
the JSON object representing a tweet, so you should not parse the whole
output as JSON; get it line by line and parse each line at once.

---

I also include a `twdump-sort` script, that can sort a dump file by ID,
in ascendant or descendant order. Useful if you append multiple dumps into
the same file, since the API returns new tweets first.

It can also remove duplicate tweets (based on the ID).

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

Bugs
----

* A `twitter.api.TwitterHTTPError` exception is raised when the API rate
  limit is exceeded. In this case, you should retrieve the last ID from the
  output and pass it to the `--max` option, so it will continue fetching
  tweets older than the max ID.

  Since the `--max` option *includes* the given ID, it will result in a
  duplicate tweet if you dump it in the same file. To avoid this, you
  can just substract 1 to the ID.

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
