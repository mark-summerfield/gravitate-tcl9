#!/usr/bin/env wish
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

package require globals
package require tooltip 2

namespace eval options_form {}


variable options_form::ok false


proc options_form::show_modal {} {
    make_widgets
    make_layout
    make_bindings
    load_options
    ui::prepare_form .options "Options — [tk appname]" \
        { options_form::on_close }
    focus .options.columns_spinbox
    tkwait window .options
    return $::options_form::ok
}


proc options_form::make_widgets {} {
    tk::toplevel .options
    ttk::label .options.columns_label -text Columns -underline 2
    ttk::spinbox .options.columns_spinbox -from 5 -to 30 -format %.0f
    tooltip::tooltip .options.columns_spinbox \
        "Columns (default $::COLUMNS_DEFAULT)"
    ttk::label .options.rows_label -text Rows -underline 0
    ttk::spinbox .options.rows_spinbox -from 5 -to 30 -format %.0f
    tooltip::tooltip .options.rows_spinbox \
        "Rows (default $::ROWS_DEFAULT)"
    ttk::label .options.max_colors_label -text "Max. Colors" -underline 0
    ttk::spinbox .options.max_colors_spinbox -from 2 \
        -to [dict size $::COLORS] -format %.0f
    tooltip::tooltip .options.max_colors_spinbox \
        "Max. Colors (default $::MAX_COLORS_DEFAULT)"
    ttk::label .options.delay_label -text "Delay (ms)" -underline 0
    ttk::spinbox .options.delay_spinbox -from 0 -to 1000 -format %.0f \
        -increment 10
    tooltip::tooltip .options.delay_spinbox \
        "Delay to show tile movement (default\
        $::DELAY_MS_DEFAULT milliseconds)"
    ttk::label .options.scale_label -text "Scale" -underline 0
    ttk::spinbox .options.scale_spinbox -from 1.0 -to 10.0 -format %.2f \
        -increment 0.1
    tooltip::tooltip .options.scale_spinbox \
            "Application's scale (default 1)"
    ttk::frame .options.buttons
    ttk::button .options.buttons.ok_button -text OK -compound left \
        -image [util::icon ok.svg $::ICON_SIZE] \
        -command { options_form::on_ok } -underline 0 
    ttk::button .options.buttons.close_button -text Cancel -compound left \
        -image [util::icon close.svg $::ICON_SIZE ] \
        -command { options_form::on_close } -underline 0 
}


proc options_form::make_layout {} {
    grid .options.columns_label -row 0 -column 0
    grid .options.columns_spinbox -row 0 -column 1 -sticky ew
    grid .options.rows_label -row 1 -column 0
    grid .options.rows_spinbox -row 1 -column 1 -sticky ew
    grid .options.max_colors_label -row 2 -column 0
    grid .options.max_colors_spinbox -row 2 -column 1 -sticky ew
    grid .options.delay_label -row 3 -column 0
    grid .options.delay_spinbox -row 3 -column 1 -sticky ew
    grid .options.scale_label -row 4 -column 0
    grid .options.scale_spinbox -row 4 -column 1 -sticky ew
    grid .options.buttons.ok_button -row 0 -column 0
    grid .options.buttons.close_button -row 0 -column 1
    grid .options.buttons -row 5 -column 0 -columnspan 2
    grid .options.columns_label .options.columns_spinbox \
         .options.rows_label .options.rows_spinbox \
         .options.max_colors_label .options.max_colors_spinbox \
         .options.delay_label .options.delay_spinbox \
         .options.scale_label .options.scale_spinbox \
         .options.buttons.ok_button .options.buttons.close_button \
         -padx $::PAD -pady $::PAD
}


proc options_form::make_bindings {} {
    bind .options <Alt-d> { focus .options.delay_spinbox }
    bind .options <Alt-s> { focus .options.scale_spinbox }
    bind .options <Alt-l> { focus .options.columns_spinbox }
    bind .options <Alt-m> { focus .options.max_colors_spinbox }
    bind .options <Alt-r> { focus .options.rows_spinbox }
    bind .options <Alt-o> { options_form::on_ok }
    bind .options <Return> { options_form::on_ok }
    bind .options <Alt-c> { options_form::on_close }
    bind .options <Escape> { options_form::on_close }
}


proc options_form::load_options {} {
    set ini [::ini::open [util::get_ini_filename] -encoding utf-8 r]
    try {
        set section $::INI_BOARD
        .options.columns_spinbox set \
            [::ini::value $ini $section $::INI_COLUMNS \
             $::COLUMNS_DEFAULT]
        .options.rows_spinbox set \
            [::ini::value $ini $section $::INI_ROWS $::ROWS_DEFAULT]
        .options.max_colors_spinbox set \
            [::ini::value $ini $section $::INI_MAX_COLORS \
             $::MAX_COLORS_DEFAULT]
        .options.delay_spinbox set \
            [::ini::value $ini $section $::INI_DELAY_MS \
             $::DELAY_MS_DEFAULT]
        # This ignores the -format option (hence the use of format)
        # .options.scale_spinbox set \
        #     [::ini::value $ini $::INI_WINDOW $::INI_SCALE [tk scaling]]
         .options.scale_spinbox set [format %.2f \
             [::ini::value $ini $::INI_WINDOW $::INI_SCALE [tk scaling]]]
    } finally {
        ::ini::close $ini
    }
}


proc options_form::on_ok {} {
    set scale [.options.scale_spinbox get]
    set ini [::ini::open [util::get_ini_filename] -encoding utf-8]
    try {
        set section $::INI_BOARD
        ::ini::set $ini $section $::INI_COLUMNS \
            [.options.columns_spinbox get]
        ::ini::set $ini $section $::INI_ROWS \
            [.options.rows_spinbox get]
        ::ini::set $ini $section $::INI_MAX_COLORS \
            [.options.max_colors_spinbox get]
        ::ini::set $ini $section $::INI_DELAY_MS \
            [.options.delay_spinbox get]
        ::ini::set $ini $::INI_WINDOW $::INI_SCALE $scale
        ::ini::commit $ini
    } finally {
        ::ini::close $ini
    }
    tk scaling $scale
    do_close true
}


proc options_form::on_close {} { do_close }


proc options_form::do_close {{result false}} {
    set ::options_form::ok $result
    grab release .options
    destroy .options
}
