#!/usr/bin/env wish
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

package require main_window
package require ui
package require util

namespace eval app {}


proc app::main {} {
    read_scale
    wm withdraw .
    wm title . [tk appname]
    wm iconname . [tk appname]
    wm iconphoto . -default [util::icon icon.svg]
    wm minsize . 260 300
    wm protocol . WM_DELETE_WINDOW actions::on_quit
    ui::make_fonts
    option add *font default
    ttk::style configure TButton -font default
    main_window::show
    wm deiconify .
    raise .
    focus .
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
