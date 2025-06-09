#!/usr/bin/env wish
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

package require inifile 0

namespace eval util {}

proc util::icon {svg {width 0}} {
    set opt [expr {$width ? [list -format [
        list svg -scaletowidth $width]] : ""}]
    image create photo -file $::APPPATH/images/$svg {*}$opt
}


proc util::commas x {
    regsub -all \\d(?=(\\d{3})+([regexp -inline {\.\d*$} $x]$)) $x {\0,}
}


proc util::get_ini_filename {} {
    set home [file home]
    set names [list]
    if {[tk windowingsystem] eq "win32"} {
        lappend names [file join $home gravitate.ini] \
                      $::APPPATH/gravitate.ini
        set index 0
    } else {
        lappend names [file join $home .config/gravitate.ini] \
                      [file join $home .gravitate.ini] \
                      $::APPPATH/gravitate.ini
        set index [expr {[file isdirectory [
                            file join $home .config]] ? 0 : 1}]
    }
    foreach name $names {
        set name [file normalize $name]
        if {[file exists $name]} {
            return $name
        }
    }
    set name [lindex $names $index]
    make_default_ini $name
    return $name
}


proc util::make_default_ini name {
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
        ::ini::set $ini $section $::INI_FONTSIZE \
            [dict get [font actual TkDefaultFont] -size]
        ::ini::commit $ini
    } finally {
        ::ini::close $ini
    }
}


proc util::open_webpage url {
    if {[tk windowingsystem] eq "win32"} {
        set cmd [list {*}[auto_execok start] {}]
    } else {
        set cmd [auto_execok xdg-open]
    }
    try {
        exec {*}$cmd $url &
    } trap CHILDSTATUS {err} {
        puts "failed to open $url: $err"
    }
}


proc util::isnan x { return [expr {![string is double $x] || $x != $x}] }
