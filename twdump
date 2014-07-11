#!/usr/bin/env python3

'''Usage: twdump [options] <name>

Arguments:
  <name>  Twitter screen name.

Options:
  -h, --help                  Show this screen.
  --version                   Show version.
  -s, --since=<since>         Get tweets greater than <since> ID (get
                              everything by default).
  -m, --max=<max>             Get tweets older than <max> ID.
  -c, --config=<config>       Config file. Auth keys will be read from this
                              file if not given by commandline options.
  --consumer-key=<key>        Application API key.
  --consumer-secret=<secret>  Application API secret.
  --oauth-token=<token>       Client OAuth token.
  --oauth-secret=<secret>     Client OAuth secret.
'''

import json
import sys

from configobj import ConfigObj
from docopt import docopt
from twitter import Twitter, OAuth


class FriendlyError(Exception):
    '''Display a friendly error.

    The error should be displayed in `stderr` instead of dumping a Python
    stack trace, and the program should return a non-zero exit code.
    '''

    pass


def itimeline(timeline, **kwargs):
    '''Iterate over a Twitter timeline.

    All named arguments are passed to `timeline`. The `count` parameter
    will be the buffer size for all requests.

    Tweets are iterated in reverse chronological order. You can provide a
    `since_id` to get all tweets greater than the given ID.

        itimeline(timeline, exclude_replies=True, count=200, since_id=12345)
    '''

    tweets = timeline(**kwargs)

    # Will be overriden below
    if 'max_id' in kwargs:
        del kwargs['max_id']

    while len(tweets):
        for tweet in tweets:
            yield tweet

        tweets = timeline(max_id=tweet['id'] - 1, **kwargs)


def ignore_none(f):
    '''Decorator to ignore keyword arguments set to `None`.'''

    def inner(*args, **kwargs):
        # Remove arguments with `None` value
        kwargs = {k: v for k, v in kwargs.items() if v is not None}

        # Proxy call
        return f(*args, **kwargs)

    return inner


def get_auth(args):
    keys = ['consumer_key', 'consumer_secret', 'oauth_token', 'oauth_secret']
    config_file = args['--config']

    if config_file is not None:
        config = ConfigObj(config_file)
        err = lambda x: 'Missing key `{0}` in `{1}`.'.format(x, config_file)
    else:
        # Key args dict
        kas = {k: '--' + k.replace('_', '-') for k in keys}

        config = {k: args[a] for k, a in kas.items() if args[a] is not None}
        err = lambda x: 'Missing argument `{0}`.'.format(kas[x])

    try:
        auth = {key: config[key] for key in keys}
    except KeyError as e:
        raise FriendlyError(err(e.args[0]))

    return OAuth(auth['oauth_token'], auth['oauth_secret'],
                 auth['consumer_key'], auth['consumer_secret'])


def main():
    args = docopt(__doc__, version='0.3.0')

    name = args['<name>']
    since = args['--since']
    max = args['--max']

    twitter = Twitter(auth=get_auth(args))

    tweets = itimeline(ignore_none(twitter.statuses.user_timeline),
                       screen_name=name, count=2, since_id=since, max_id=max)

    for tweet in tweets:
        json.dump(tweet, sys.stdout)

        # Append newline
        print()


if __name__ == '__main__':
    try:
        main()
    except FriendlyError as e:
        print(str(e), file=sys.stderr)
        sys.exit(1)
