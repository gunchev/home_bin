#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
==============================================
mksparse.py - sparse file / disk image creator
==============================================

Usage: mksparse.py <imagefile.img> <size>[k|m|g|t]

    This will create <imagefile.img> with size <size>. If the suffix is
not given then the size is in bytes, 'k' stands for kilobytes (1024),
'm' for megabytes and 'g' for gigabyes and 't' for terabytes.
K/M/G/T are not implemented, one can type some 000-s easy enough.

Simple python script that creates sparse files on unix / Win2k NTFS5.
This script opens a file for writing, seeks at the desired position
(or file size) and truncates the file there. Can be handy while
playing with KVM / qemu / bochs / loopback images.

Tested on linux-2.6+ only.

NB: Check fallocate from util-linux, may work even better for you.

Author: Doncho N. Gunchev <gunchev at gmail dot com>
Based on Brad Watson's work mkimage.py from
  http://lists.gnu.org/archive/html/qemu-devel/2004-07/msg00733.html
  http://qemu.dad-answers.com/download/qemu/utilities/QEMU-HD-Create/
"""

import os.path
import re
import sys

__version__   = "0.3"
__author__    = "Doncho Gunchev <gunchev@gmail.com>, Brad Watson"
__depends__   = ['Python-3']


# __copyright__ = 'Ask Brad Watson, I want nothing.'


class MkSparseError(Exception):
    """MkSpace errors"""


def mk_sparse(file_name: str, file_size: int):
    """Create a sparse file by truncating it at given position"""
    try:
        sparse_file = open(file_name, 'wb+')
    except EnvironmentError as exc:
        raise MkSparseError("Error: Can't create file {file_name!r}:\n\t{exc}")

    try:
        # Note that I don't want (you too) to write() anything in the file
        # because this will consume at least one sector/block.
        sparse_file.truncate(int(file_size))
    except EnvironmentError as exc:
        try:
            os.unlink(file_name)  # clean the mess...
        except EnvironmentError:
            pass
        try:  # could close in finally, but would lose the option to report close error properly.
            sparse_file.close()
        except EnvironmentError:
            pass
        raise MkSparseError("Error: Can't truncate {file_name!r}:\n\t{exc}")

    try:
        sparse_file.close()
    except EnvironmentError as exc:
        raise MkSparseError(f"Error: Can't close {file_name!r}:\n\t{exc}")


def parse_file_size(file_size: str) -> int:
    """file size validation and parsing"""
    xlt: dict[str, int] = dict(k=2 ** 10, m=2 ** 20, g=2 ** 30, t=2 ** 40, p=2 ** 50, e=2 ** 60, z=2 ** 70, y=2 ** 80)
    try:
        size_str, dim = re.match('^(\\d+)([' + ''.join(xlt.keys()) + '])?$', file_size).groups()
    except AttributeError:  # if it did not match we get None, which has no .groups...
        raise ValueError('Bad image size given: {!r}'.format(file_size))

    size: int = int(size_str)  # can not raise...
    if dim is None:
        return size

    return size * xlt[dim]


def main():
    """The main function for a command line execution"""
    my_name = os.path.basename(sys.argv[0])

    if len(sys.argv) != 3:
        # .pyo (docstrings stripped) workaround, no idea if needed any more or at all ;-) just having fun obv.
        print((__doc__ and __doc__ or ("Usage: " + my_name + " <image-name> <size>[kmgt]")), file=sys.stderr)
        print("Version:", __version__, file=sys.stderr)
        sys.exit(1)

    # 'Process' command line parameters
    file_name: str = sys.argv[1]
    file_size: str = sys.argv[2]

    def err_exit(reason: str, code: int):
        """Print error (exception) and exit with error code"""
        print(f'{my_name}: {reason}', file=sys.stderr)
        sys.exit(code)

    # Check if the file exists, -f (force) would be a good parameter to add
    if os.path.exists(file_name):
        err_exit(f'Error: file/directory {file_name!r} already exists!', 17)

    try:
        mk_sparse(file_name, parse_file_size(file_size))
    except MkSparseError as exc:
        err_exit(str(exc), 1)
    except (ValueError, KeyError) as exc:
        err_exit(str(exc), 64)  # EX_USAGE


if __name__ == "__main__":
    main()
