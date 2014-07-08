#!/usr/bin/env python3

'''Usage: twdump-sort [options] [<file>]

Arguments:
  <file>  File to process, `stdin` if not given.

Options:
  -h, --help     Show this screen.
  --version      Show version.
  -r, --reverse  Reverse the result.
  -u, --unique   Make sure every output tweet is unique (based on the ID).
'''

import io
import json
import sys
import tempfile

from docopt import docopt
from operator import itemgetter


class File():
    '''Class representing an internal file wrapper.'''

    def __init__(self, file):
        self.file = file

    def __iter__(self):
        return self.file.__iter__()

    def seek(self, offset):
        return self.file.seek(offset)

    def readline(self):
        return self.file.readline()


class SeekableFile(File):
    '''Wrap a file supposed not to be seekable.

    Make a copy in a temporary file during the first iteration, then
    iterate over the copied (seekable) file.
    '''

    def __init__(self, file):
        super().__init__(file)
        self.first = True

    def __iter__(self):
        if not self.first:
            return super().__iter__()

        self.first = False

        if isinstance(self.file, io.TextIOWrapper):
            mode = 'w+'
        else:
            mode = 'w+b'

        copy = tempfile.TemporaryFile(mode)

        for line in self.file:
            copy.write(line)
            yield line

        self.file = copy


def unique(iterable, key=None):
    '''Deduplicate a sorted iterable based on given key.'''

    iterator = iter(iterable)

    if key is None:
        key = lambda x: x

    previous = next(iterator)

    # Yield first item as-is
    yield previous

    for i in iterator:
        current = key(i)

        if current != previous:
            previous = current
            yield i


def main():
    args = docopt(__doc__, version='0.1.0')

    file = args['<file>']
    reverse = args['--reverse']
    unique_ = args['--unique']

    if file is None:
        file = SeekableFile(sys.stdin)
    else:
        file = File(open(file, 'r'))

    index = []
    i = 0

    for line in file:
        index.append((i, json.loads(line)['id']))
        i += len(line)

    # Sort index by value (here, tweet ID)
    index = sorted(index, key=itemgetter(1), reverse=reverse)

    if unique_:
        index = unique(index)

    for i in map(itemgetter(0), index):
        file.seek(i)
        sys.stdout.write(file.readline())


if __name__ == '__main__':
    main()
