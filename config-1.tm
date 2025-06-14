#!/usr/bin/env wish9
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

package require inifile

namespace eval config {}


proc config::make_default_ini name {
    set ini [::ini::open $name -encoding utf-8 w]
    try {
        set section $::INI_BOARD
        ::ini::set $ini $section $::INI_COLUMNS $::COLUMNS_DEFAULT
        ::ini::set $ini $section $::INI_ROWS $::ROWS_DEFAULT
        ::ini::set $ini $section $::INI_MAX_COLORS $::MAX_COLORS_DEFAULT
        ::ini::set $ini $section $::INI_DELAY_MS $::DELAY_MS_DEFAULT
        ::ini::set $ini $section $::INI_HIGH_SCORE $::HIGH_SCORE_DEFAULT
        set section $::INI_WINDOW
        set invalid $::INVALID
        ::ini::set $ini $section $::INI_WINDOW_HEIGHT $invalid
        ::ini::set $ini $section $::INI_WINDOW_WIDTH $invalid
        ::ini::set $ini $section $::INI_WINDOW_X $invalid
        ::ini::set $ini $section $::INI_WINDOW_Y $invalid
        ::ini::set $ini $section $::INI_SCALE [tk scaling]
        ::ini::commit $ini
    } finally {
        ::ini::close $ini
    }
}
