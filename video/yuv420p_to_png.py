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

def load_yuv420p(yuv_file_path, width, height):
    """Read YUV420p file and return PIL Image"""
    yuv_file = open(yuv_file_path, "rb")

    y_data_size = height * width
    uv_data_size = y_data_size // 4
    yuv_data = array('B')
    yuv_data.fromfile(yuv_file, y_data_size + 2 * uv_data_size)

    result = Image.new("RGB", (width, height))
    pixels = result.load()
    for y in range(height):
        for x in range(width):
            y_value = (yuv_data[(y * width) + x] - 16) * 1.164
            offset = y_data_size + ((y // 2) * (width // 2)) + (x // 2)
            u_value = yuv_data[offset] - 128
            v_value = yuv_data[offset + uv_data_size] - 128
            # B = 1.164(Y - 16)                  + 2.018(U - 128)
            # G = 1.164(Y - 16) - 0.813(V - 128) - 0.391(U - 128)
            # R = 1.164(Y - 16) + 1.596(V - 128)
            b_value = y_value + 2.018 * u_value
            g_value = y_value - 0.813 * v_value - 0.391 * u_value
            r_value = y_value + 1.596 * v_value
            pixels[x, y] = (int(r_value), int(g_value), int(b_value))

    return result

def main():
    yuv_file_path = sys.argv[1]
    width, height = int(sys.argv[2]), int(sys.argv[3])
    picture = load_yuv420p(yuv_file_path, width, height)
    picture.save(splitext(yuv_file_path)[0] + '.png')
    picture.show()


if __name__ == "__main__":
    main()
