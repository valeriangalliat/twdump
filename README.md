`twdump`
========

Dump all tweets for a Twitter account.

Description
-----------

Twitter allows each user to download its own archive, but this operation
isn't easily scriptable and is limited to your own data.

`twdump`'s purpose is to provide a simple tool to dump the last
3,200 tweets of an account (the API don't allow to dump more than this),
and can dump the tweets fresher than a tweet ID.

The output is the raw JSON from Twitter API. Each line of output contains
the JSON object representing a tweet, so you should not parse the whole
output as JSON; get it line by line and parse each line at once.

This software comes with a set of additional tools to work with the dump
file, **including a shell script to help backuping new tweets with a cron
job**. Watch the [Tools](#tools) section.

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

Tools
-----

### `twdump-sort`

`twdump-sort` can sort a dump file by ID, in ascendant or descendant order.

It's useful if you append multiple dumps into the same file, since the API
returns new tweets first.

It can also remove duplicate tweets (based on the ID).

```sh
./twdump-sort --reverse --unique twdump.txt > txdump-sorted.txt
```

### `twdump-list`

`twdump-list` is an helper to display a particular JSON key from a dump
file. By default it takes `text` which is the tweet text.

If I have a file containing the following tweets:

```json
{"id": 24, "text": "Hello world!"}
{"id": 42, "text": "They see me dumpin'.\nThey hatin'."}
{"id": 1337, "text": "Another tweet."}
```

... the output will be:

```
24: Hello world!
--
42: They see me dumpin'.
42: They hatin'.
--
1337: Another tweet.
```

### `twdump-cron`

Probably the most useful tool in this page (but I put it at the end of the
readme... UX, I'm doing it wrong). `twdump-cron` will use all the above
tools to append your latest tweets in a file.

It takes at first arguments the file you store your tweets in, and all
other arguments are passed to `twdump` (so you'll want to add all the
keys, or a config file, and your Twitter name).

If you want the backup to happen everyday (at midnight):

```sh
@daily /path/to/twdump-cron /path/to/tweets.txt -c /path/to/twdump.conf youraccount
```

The first time, you may run into API rate exceptions. It's better to
download everything "by hand" to begin. For this, you run the cron until
you get an API error. Then, you take the last tweet ID from the list
(the oldest retrieved), and you pass it to the `--max` option for the
next call.

To avoid duplicates, you have to substract 1 to it since the `--max` option
includes the given tweet ID, but in case you forget it, keep in mind the
`twdump-sort` script can take a `--unique` option to deduplicate tweets
by ID!

Repeat the last operation (updating the `--max` value everytime) until
you have everything (the script will end without error).

Note that the API will return only your last 3,200 tweets. If you have more,
you'd better download your Twitter archive (from the settings page) and
convert it to `twdump`'s format.

If you write a script for this, feel free to make a pull request, I'd be
glad to merge it!
