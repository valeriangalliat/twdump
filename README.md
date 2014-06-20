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
* `docopt` <https://github.com/docopt/docopt>
* `twurl` <https://github.com/twitter/twurl>

Installation
------------

After installing the dependencies above, you need to configure `twurl` with
your API key and secret.

```sh
twurl --consumer-secret [secret] --access-token [token]
```

To get a secret and token, you need to [create a Twitter application](https://apps.twitter.com/app/new).
Once created, you'll find the keys in the "API Keys" tab.

Then, clone this repository and you can call `./twdump`.

Examples
--------

Dump all tweets for your account:

```sh
./twdump youraccount
```

Dump all your tweets greater than the tweet with ID 12345:

```sh
./twdump -s 12345 youraccount
```
