#!/usr/bin/env python3

'''Usage: twdump-list [options] [<file>]

Arguments:
  <file>  File to process, `stdin` if not given.

Options:
  -h, --help       Show this screen.
  --version        Show version.
  -k, --key=<key>  Object key (dot notation) to display [default: text].
'''

import json
import sys

from docopt import docopt
from functools import partial, reduce


def dump(id, value):
    for line in value.splitlines():
        print('{0}: {1}'.format(id, line))


def main():
    args = docopt(__doc__, version='0.1.0')

    file = args['<file>']

    if file is None:
        file = sys.stdin
    else:
        file = open(file, 'r')

    key = args['--key']

    '''Extract a value from given object with specified key.

    If the key is `foo.bar`, then this call:

        extract({'foo': {'bar': 'baz'}})

    ... will return `baz`.

    '''
    extract = partial(reduce, dict.get, key.split('.'))

    it = iter(file)

    try:
        tweet = json.loads(next(it))
    except StopIteration:
        return

    value = extract(tweet)

    if not isinstance(value, str):
        filter = json.dumps
    else:
        filter = str

    dump(tweet['id'], filter(value))

    for tweet in map(json.loads, file):
        print('--')
        dump(tweet['id'], filter(extract(tweet)))


if __name__ == '__main__':
    main()
