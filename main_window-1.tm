#!/usr/bin/env wish9
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

package require actions
package require board
package require globals
package require inifile
package require lambda 1
package require tooltip 2

namespace eval main_window {
    variable status_timer_id {}
}


proc main_window::show {} {
    prepare
    make_widgets
    make_layout
    make_bindings
    read_options
    actions::on_new
    status_message "Click a tile to play…"
    display
}


proc main_window::prepare {} {
    wm withdraw .
    wm title . [tk appname]
    wm iconname . [tk appname]
    wm iconphoto . -default [util::icon icon.svg]
    wm minsize . 260 300
    wm protocol . WM_DELETE_WINDOW actions::on_quit
    ui::make_fonts
    option add *font default
    ttk::style configure TButton -font default
}

proc main_window::display {} {
    wm deiconify .
    raise .
    focus .
}


proc main_window::make_widgets {} {
    ttk::frame .main
    ttk::frame .main.toolbar
    ttk::button .main.toolbar.new -text New -style Toolbutton \
        -image [util::icon new.svg $::ICON_SIZE] -command actions::on_new
    tooltip::tooltip .main.toolbar.new "New game"
    ttk::button .main.toolbar.options -text Options -style Toolbutton \
        -image [util::icon options.svg $::ICON_SIZE] \
        -command actions::on_options
    tooltip::tooltip .main.toolbar.options "Options…"
    ttk::button .main.toolbar.about -text About -style Toolbutton \
        -image [util::icon about.svg $::ICON_SIZE] \
        -command actions::on_about
    tooltip::tooltip .main.toolbar.about "About"
    ttk::button .main.toolbar.help -text Help -style Toolbutton \
        -image [util::icon help.svg $::ICON_SIZE] -command actions::on_help
    tooltip::tooltip .main.toolbar.help "Help"
    ttk::button .main.toolbar.quit -text Quit -style Toolbutton \
        -image [util::icon quit.svg $::ICON_SIZE] \
        -command actions::on_quit
    tooltip::tooltip .main.toolbar.quit "Quit"
    board::make
    ttk::frame .main.status_bar
    ttk::label .main.status_bar.label
    ttk::label .main.status_bar.score_label
}


proc main_window::make_layout {} {
    grid .main -sticky nsew
    grid .main.toolbar -sticky ew
    grid .main.toolbar.new -row 0 -column 0 -sticky w
    grid .main.toolbar.options -row 0 -column 1 -sticky w
    grid .main.toolbar.about -row 0 -column 2 -sticky w
    grid .main.toolbar.help -row 0 -column 3 -sticky w
    grid .main.toolbar.quit -row 0 -column 4 -sticky e
    grid columnconfigure .main.toolbar 1 -weight 1
    grid columnconfigure .main.toolbar 4 -weight 1
    grid .main.board -sticky nsew -pady $::PAD
    grid .main.status_bar -sticky ew
    grid .main.status_bar.label -row 0 -column 0 -sticky we
    grid .main.status_bar.score_label -row 0 -column 1 -sticky e
    grid columnconfigure .main.status_bar 0 -weight 1
    grid columnconfigure .main 0 -weight 1
    grid rowconfigure .main 1 -weight 1
    grid columnconfigure . 0 -weight 1
    grid rowconfigure . 0 -weight 1
}


proc main_window::make_bindings {} {
    bind . n { actions::on_new }
    bind . o { actions::on_options }
    bind . a { actions::on_about }
    bind . h { actions::on_help }
    bind . <F1> { actions::on_help }
    bind . q { actions::on_quit }
    bind . <Escape> { actions::on_quit }
    bind .main.board $::SCORE_EVENT { actions::on_score %d }
    bind .main.board $::GAME_OVER_EVENT { actions::on_game_over %d }
}


proc main_window::read_options {} {
    set ini [::ini::open [util::get_ini_filename] -encoding utf-8 r]
    try {
        set section $::INI_BOARD
        set ::board::high_score \
            [::ini::value $ini $section $::INI_HIGH_SCORE -1]
        if {$::board::high_score == -1} {
            set ::board::high_score [::ini::value $ini $section \
                $::INI_HIGH_SCORE_COMPAT $::HIGH_SCORE_DEFAULT]
        }
        .main.status_bar.score_label configure \
            -text "0 • [util::commas $::board::high_score]"
        set section $::INI_WINDOW
        set invalid $::INVALID
        set scale [tk scaling]
        set width [::ini::value $ini $section $::INI_WINDOW_WIDTH $invalid]
        set height [::ini::value $ini $section \
                    $::INI_WINDOW_HEIGHT $invalid]
        set x [::ini::value $ini $section $::INI_WINDOW_X $invalid] 
        set y [::ini::value $ini $section $::INI_WINDOW_Y $invalid] 
        if {$width != $invalid && $height != $invalid &&
                $x != $invalid && $y != $invalid} {
            set x [expr {int($scale * $x)}]
            set y [expr {int($scale * $y)}]
            set width [expr {int($scale * $width)}]
            set height [expr {int($scale * $height)}]
            wm geometry . "${width}x$height+$x+$y"
        }
    } finally {
        ::ini::close $ini
    }
}


proc main_window::status_message {msg {ms 5000}} {
    after cancel $::main_window::status_timer_id
    .main.status_bar.label configure -text $msg
    if {$ms > 0} {
        set ::main_window::status_timer_id \
            [after $ms [::lambda {} {
                .main.status_bar.label configure -text "" }]]
    }
}
