#!/usr/bin/env wish9
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

package require util

namespace eval about_form {}


proc about_form::show_modal {} {
    make_widgets
    make_layout
    make_bindings
    ui::prepare_form .about "About — [tk appname]" { about_form::on_close }
    focus .about.text
}


proc about_form::make_widgets {} {
    tk::toplevel .about
    wm resizable .about false false
    set height 14
    tk::text .about.text -width 50 -height $height -wrap word \
        -background "#F0F0F0" -spacing3 $::VGAP
    populate_about_text
    .about.text configure -state disabled
    ttk::button .about.close_button -text Close -compound left \
        -image [util::icon close.svg $::ICON_SIZE] \
        -command { about_form::on_close }
}


proc about_form::make_layout {} {
    grid .about.text -sticky nsew -pady $::PAD
    grid .about.close_button -pady $::PAD
}


proc about_form::make_bindings {} {
    bind .about <Escape> { about_form::on_close }
    bind .about <Return> { about_form::on_close }
    .about.text tag bind url <Double-1> {
        about_form::on_click_url @%x,%y
    }
}


proc about_form::on_click_url index {
    set indexes [.about.text tag prevrange url $index]
    set url [string trim [.about.text get {*}$indexes]]
    if {$url ne ""} {
        if {![string match -nocase http*://* $url]} {
            set url [string cat http:// $url]
        }
        util::open_webpage $url
    }
}


proc about_form::on_close {} {
    grab release .about
    destroy .about
}


proc about_form::populate_about_text {} {
    ui::add_text_tags .about.text
    set img [.about.text image create end -align center \
             -image [util::icon icon.svg 64]]
    .about.text tag add spaceabove $img
    .about.text tag add center $img
    .about.text insert end "\nGravitate v$::VERSION\n" {center title}
    .about.text insert end "A TileFall/SameGame-like game.\n" {center navy}
    set year [clock format [clock seconds] -format %Y]
    if {$year > 2020} {
        set year "2020-[string range $year end-1 end]"
    }
    set bits [expr {8 * $::tcl_platform(wordSize)}]
    set distro [exec lsb_release -ds]
    .about.text insert end \
        "http://mark-summerfield.github.io/gravitate.html\n" \
        {center green url}
    .about.text insert end "Copyright © $year Mark Summerfield.\
                            \nAll Rights Reserved.\n" {center green}
    .about.text insert end "License: GPLv3.\n" {center green}
    .about.text insert end "[string repeat " " 60]\n" {center hr}
    .about.text insert end "Tcl/Tk $::tcl_patchLevel (${bits}-bit)\n" center
    if {$distro != ""} { .about.text insert end "$distro\n" center }
    .about.text insert end "$::tcl_platform(os) $::tcl_platform(osVersion)\
        ($::tcl_platform(machine))\n" center
}
