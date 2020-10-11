#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
This program check if the given EGN (Universal Citizen Number)
is valid in Bulgaria. All EGNs are accepted as arguments.

You can also import egn_check from this file.
"""

__version__ = "0.0.2"
__author__ = "Doncho Gunchev <gunchev@gmail.com>"
__depends__ = ["Python-3"]
__copyright__ = "GPLv2+/BSD"


def egn_check(egn):
    '''Check if the given EGN (Bulgarian Universal Citizen Number) is valid.'''
    if len(egn) != 10:
        return False
    multipliers = (2, 4, 8, 5, 10, 9, 7, 3, 6)
    check_sum = 0
    for i in range(9):
        check_sum += int(egn[i]) * multipliers[i]
    check_sum %= 11
    if check_sum > 9:
        check_sum = 0  # hmm? should it not just subtract 10?
    return int(egn[9]) == check_sum


if __name__ == '__main__':
    import sys
    print("EGN check version " + __version__ + ", by Mr.700")
    if len(sys.argv) < 2:
        print("\n" + __doc__.strip())
    else:
        for arg in sys.argv[1:]:
            if egn_check(arg):
                print(arg + " - OK")
            else:
                print(arg + " - BAD")
