# FTTZ (aka *Yet Another Stupid Idea™*)

*Find Twitter TimeZone.*

The idea is to approximate the timezone of a Twitter user using their last 200 tweets distribution throughout the day.

    iex(1)> FTTZ.stats("twitter")
    Most likely time offset is UTC-07:00

    Tweet distribution throughout the day (at UTC±00:00):

    00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
    ██ ██    ██                                        ██ ██ ██ ██ ██ ██ ██
    ██ ██    ██                                        ██ ██ ██ ██ ██ ██ ██
    ██ ██    ██                                        ██ ██ ██ ██ ██ ██ ██
    ██ ██                                              ██ ██ ██ ██ ██ ██ ██
    ██ ██                                              ██ ██ ██ ██ ██ ██ ██
    ██ ██                                                 ██ ██ ██ ██ ██ ██
    ██ ██                                                 ██ ██ ██ ██ ██ ██
    ██ ██                                                 ██ ██ ██ ██ ██ ██
    ██ ██                                                 ██ ██ ██ ██ ██ ██
    ██ ██                                                 ██ ██ ██ ██ ██ ██
    ██ ██                                                 ██ ██ ██ ██    ██
    ██                                                       ██ ██ ██    ██
    ██                                                          ██ ██    ██
    ██                                                          ██ ██    ██
    ██                                                          ██ ██    ██
    ██                                                             ██

    :ok

It just counts the number of shifts required to make it look like most of the tweets were created during daytime (from 8:00AM until 8:00PM) at UTC±00:00.

It is pretty much useless. Inaccurate too. Also don't look at the code.
