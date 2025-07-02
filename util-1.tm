#!/usr/bin/env wish9
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

package require config

namespace eval util {}

proc util::icon {svg {width 0}} {
    if {!$width} {
        return [image create photo -file $::APPPATH/images/$svg]
    }
    image create photo -file $::APPPATH/images/$svg \
        -format "svg -scaletowidth $width"
}

proc util::get_ini_filename {} {
    set home [file home]
    if {[tk windowingsystem] eq "win32"} {
        set names [list [file join $home gravitate.ini] \
                        $::APPPATH/gravitate.ini]
        set index 0
    } else {
        set names [list [file join $home .config/gravitate.ini] \
                        [file join $home .gravitate.ini] \
                        $::APPPATH/gravitate.ini]
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
    config::make_default_ini $name
    return $name
}


proc util::commas x {
    regsub -all \\d(?=(\\d{3})+([regexp -inline {\.\d*$} $x]$)) $x {\0,}
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
