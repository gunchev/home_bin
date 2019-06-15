#!/usr/bin/env python3

# Author : sherin.s@gmail.com (Sherin Sasidhan)
# Date   : 05-Oct-2010
# URL    : https://shrex999.wordpress.com/2013/07/31/yuv-to-rgb-python-imaging-library/
#
# Updated:  2019-06-15 - Doncho Gunchev <dgunchev@gmail.com>

from PIL import Image
import sys
from struct import *
from array import array
from os.path import splitext

if len(sys.argv) != 4:
    sys.exit("""***** Usage syntax Error!!!! *****
Usage:
    %r yuv420p_FILE.yuv WIDTH HEIGHT
""" % sys.argv[0])

def clamp(value, min_v=0, max_v=255):
    '''Clamp a value to a range, inclusive'''
    return min(max_v, max(min_v, value))

def load_yuv420p(yuv_file_path, width, height):
    """Read YUV420p file and return PIL Image"""
    yuv_file = open(yuv_file_path, "rb")

    y_data = array('B')
    y_data.fromfile(yuv_file, height * width)
    u_data = array('B')
    u_data.fromfile(yuv_file, (height // 2) * (width // 2))
    v_data = array('B')
    v_data.fromfile(yuv_file, (height // 2) * (width // 2))

    result = Image.new("RGB", (width, height))
    pixels = result.load()
    for i in range(height):
        for j in range(width):
            y_value = y_data[(i * width) + j]
            offset = ((i // 2) * (width // 2)) + (j // 2)
            u_value = u_data[offset] - 128
            v_value = v_data[offset] - 128
            # https://en.wikipedia.org/wiki/YUV#Y%E2%80%B2UV420sp_(NV21)_to_RGB_conversion_(Android)
            r_value = clamp(y_value + (1.370705 * v_value))
            g_value = clamp(y_value - (0.698001 * v_value) - (0.337633 * u_value))
            b_value = clamp(y_value + (1.732446 * u_value))

            pixels[j, i] = (int(r_value), int(g_value), int(b_value))

    return result

def main():
    yuv_file_path = sys.argv[1]
    width, height = int(sys.argv[2]), int(sys.argv[3])
    picture = load_yuv420p(yuv_file_path, width, height)
    picture.save(splitext(yuv_file_path)[0] + '-android.png')
    picture.show()


if __name__ == "__main__":
    main()
