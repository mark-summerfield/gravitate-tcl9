#!/usr/bin/env wish9
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

package require main_window
package require ui
package require util

namespace eval app {}


proc app::main {} {
    wishinit
    tk appname Gravitate
    read_scale
    main_window::show
}

proc wishinit {} {
    catch {
        set fh [open [file join [file home] .wishinit.tcl]]
        set raw [read $fh]
        close $fh
        eval $raw
    }
    const LINEHEIGHT [expr {[font metrics font -linespace] * 1.0125}]
    ttk::style configure Treeview -rowheight $LINEHEIGHT
    ttk::style configure TCheckbutton -indicatorsize \
        [expr {$LINEHEIGHT * 0.75}]
    set ::ICON_SIZE [expr {max(24, round(20 * [tk scaling]))}]
}

proc read_scale {} {
    set ini [::ini::open [util::get_ini_filename] -encoding utf-8 r]
    try {
        set scale [::ini::value $ini $::INI_WINDOW $::INI_SCALE $::INVALID]
        if {$scale != $::INVALID} {
            tk scaling $scale
        }
    } finally {
        ::ini::close $ini
    }
}
