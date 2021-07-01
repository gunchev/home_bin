#!/bin/bash

# https://pubs.opengroup.org/onlinepubs/009696699/basedefs/xbd_chap07.html
# use 'locale' and then 'locale -k LC_<ANY_VAR>' for more hints
(
for i in $(locale -a | grep -v '.iso88'); do
    L="${i}                    "
    # IDK, 20 is the answer, guessed it by chance the first time
    L="${L::20}:"
    echo -e "${L}:" $(LC_ALL="$i" locale -k d_fmt t_fmt date_fmt d_t_fmt am_pm abday measurement)
done
) | grep ';Mon;Tue;Wed;Thu;Fri' | grep ' am_pm=";"' | grep 'measurement=1' | sed 's/ measurement=1//g'

exit 0

abday
    Define the abbreviated weekday names, corresponding to the %a conversion specification (conversion specification in the strftime(), wcsftime(), and strptime() functions). The operand shall consist of seven semicolon-separated strings, each surrounded by double-quotes. The first string shall be the abbreviated name of the day corresponding to Sunday, the second the abbreviated name of the day corresponding to Monday, and so on.
day
    Define the full weekday names, corresponding to the %A conversion specification. The operand shall consist of seven semicolon-separated strings, each surrounded by double-quotes. The first string is the full name of the day corresponding to Sunday, the second the full name of the day corresponding to Monday, and so on.
abmon
    Define the abbreviated month names, corresponding to the %b conversion specification. The operand shall consist of twelve semicolon-separated strings, each surrounded by double-quotes. The first string shall be the abbreviated name of the first month of the year (January), the second the abbreviated name of the second month, and so on.
mon
    Define the full month names, corresponding to the %B conversion specification. The operand shall consist of twelve semicolon-separated strings, each surrounded by double-quotes. The first string shall be the full name of the first month of the year (January), the second the full name of the second month, and so on.
d_t_fmt
    Define the appropriate date and time representation, corresponding to the %c conversion specification. The operand shall consist of a string containing any combination of characters and conversion specifications. In addition, the string can contain escape sequences defined in the table in Escape Sequences and Associated Actions ( '\\', '\a', '\b', '\f', '\n', '\r', '\t', '\v' ).
d_fmt
    Define the appropriate date representation, corresponding to the %x conversion specification. The operand shall consist of a string containing any combination of characters and conversion specifications. In addition, the string can contain escape sequences defined in Escape Sequences and Associated Actions.
t_fmt
    Define the appropriate time representation, corresponding to the %X conversion specification. The operand shall consist of a string containing any combination of characters and conversion specifications. In addition, the string can contain escape sequences defined in Escape Sequences and Associated Actions.
am_pm
    Define the appropriate representation of the ante-meridiem and post-meridiem strings, corresponding to the %p conversion specification. The operand shall consist of two strings, separated by a semicolon, each surrounded by double-quotes. The first string shall represent the ante-meridiem designation, the last string the post-meridiem designation.
t_fmt_ampm
    Define the appropriate time representation in the 12-hour clock format with am_pm, corresponding to the %r conversion specification. The operand shall consist of a string and can contain any combination of characters and conversion specifications. If the string is empty, the 12-hour format is not supported in the locale.
era
    Define how years are counted and displayed for each era in a locale. The operand shall consist of semicolon-separated strings. Each string shall be an era description segment with the format:

    direction:offset:start_date:end_date:era_name:era_format

    according to the definitions below. There can be as many era description segments as are necessary to describe the different eras.

    Note:
        The start of an era might not be the earliest point in the era-it may be the latest. For example, the Christian era BC starts on the day before January 1, AD 1, and increases with earlier time.

    direction
        Either a '+' or a '-' character. The '+' character shall indicate that years closer to the start_date have lower numbers than those closer to the end_date. The '-' character shall indicate that years closer to the start_date have higher numbers than those closer to the end_date.
    offset
        The number of the year closest to the start_date in the era, corresponding to the %Ey conversion specification.
    start_date
        A date in the form yyyy/mm/dd, where yyyy, mm, and dd are the year, month, and day numbers respectively of the start of the era. Years prior to AD 1 shall be represented as negative numbers.
    end_date
        The ending date of the era, in the same format as the start_date, or one of the two special values "-*" or "+*". The value "-*" shall indicate that the ending date is the beginning of time. The value "+*" shall indicate that the ending date is the end of time.
    era_name
        A string representing the name of the era, corresponding to the %EC conversion specification.
    era_format
        A string for formatting the year in the era, corresponding to the %EY conversion specification.

era_d_fmt
    Define the format of the date in alternative era notation, corresponding to the %Ex conversion specification.
era_t_fmt
    Define the locale's appropriate alternative time format, corresponding to the %EX conversion specification.
era_d_t_fmt
    Define the locale's appropriate alternative date and time format, corresponding to the %Ec conversion specification.
alt_digits
    Define alternative symbols for digits, corresponding to the %O modified conversion specification. The operand shall consist of semicolon-separated strings, each surrounded by double-quotes. The first string shall be the alternative symbol corresponding with zero, the second string the symbol corresponding with one, and so on. Up to 100 alternative symbol strings can be specified. The %O modifier shall indicate that the string corresponding to the value specified via the conversion specification shall be used instead of the value. 
