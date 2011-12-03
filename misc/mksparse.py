#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""\
==============================================
mksparse.py - sparse file / disk image creator
==============================================

Usage: mksparse.py <imagefile.img> <size>[k|m|g]
    This will create <imagefile.img> with size <size>. If the suffix is
not given then the size is in bytes, 'k' stands for kilobytes (1024),
'm' for megabytes and 'g' for gigabyes (K/M/G are not implemented, one
can type 000 easy enough).

Simple python script that creates sparse files on unix / Win2k NTFS5.
This script opens a file for writing, seeks at the desired position
(or file size) and truncates the file there. Can be handy while
playing with qemu / bochs / loopback images.

Tested on linux-2.6 only.

Author: Doncho N. Gunchev <gunchev at gmail dot com>
Based on Brad Watson's work mkimage.py from
  http://lists.gnu.org/archive/html/qemu-devel/2004-07/msg00733.html
  http://qemu.dad-answers.com/download/qemu/utilities/QEMU-HD-Create/
"""

import os.path
import re
import sys

__version__   = "0.2"
__author__    = "Doncho Gunchev <gunchev@gmail.com>, Brad Watson"
__depends__   = ['Python-2.4']
#__copyright__ = """Have to ask Brad Watson, GPL?"""


class MkSparseError(Exception):
    """MkSpace errors"""

    pass


def mk_sparse(file_name, file_size):
    """ Create a sparse file by truncating it at given position"""
    try:
        sparse_file = open(sys.argv[1],"wb+")
    except (IOError, OSError), exc:
        raise MkSparseError("Error: Can't create file '" + file_name + "':\n"
                + str(exc))
    else:
        try:
            # Note that I don't wan (you too) to write() anything in the file
            # because this will consume at least one sector/block.
            sparse_file.truncate(int(file_size))
        except (IOError, OSError), exc:
            try:
                sparse_file.close() # clean the mess...
                os.unlink(sys.argv[1])
            except (IOError, OSError):
                pass
            raise MkSparseError("Error: Can't truncate '%s'\n%s"
                    % (file_name, str(exc)))
    try:
        sparse_file.close()
    except (IOError, OSError), exc:
        raise MkSparseError("Error: Can't close '%s'\n%s" % (file_name,
                str(exc)))


def main():
    """The main function for a command line execution"""

    if len(sys.argv) != 3:
        # .pyo (docstrings stripped) workaround
        print >> sys.stderr, (__doc__ and __doc__
                or "Usage: mksparse.py <image-name> <size>[kmg]")
        print >> sys.stderr, "Version:", __version__
        sys.exit(1)

    # 'Process' command line parameters
    file_name = sys.argv[1]
    file_size = sys.argv[2]
    # validate file size
    try:
        (size, dim) = re.match('^(\d+)([KkMmGg])?$', file_size).groups()
    except TypeError:
        print >> sys.stderr, (sys.argv[0] + ': '
            + "Bad image size given: " + repr(file_size))
        sys.exit(2)

    # Check if the file exists, -f (force) would be a good parameter
    if os.path.exists(file_name):
        print >> sys.stderr, (sys.argv[0] + ': '
            + ("Error: file (directory) '%s' already exists!" % (file_name)))
        sys.exit(3)

    dim = dim.lower()
    # Calculate size in bytes
    size = long(size)
    if   dim == 'k':
        size *= 1024
    elif dim == 'm':
        size *= 1024 * 1024
    elif dim == 'g':
        size *= 1024 * 1024 * 1024
    elif dim != None:
        print >> sys.stderr, (sys.argv[0] + ': '
            + "Internal error: size modifier " + repr(dim) + " not handled.")
        sys.exit(4)

    file_size = size
    try:
        mk_sparse(file_name, file_size)
    except MkSparseError, exc:
        print >> sys.stderr, sys.argv[0] + ': ' + str(exc)
        sys.exit(1)


if __name__ == "__main__":
    main()
