#!/usr/bin/env wish9
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

const PATH [file normalize [file dirname [info script]]]
tcl::tm::path add $PATH

package require prepare_gui

tk appname Gravitate

package require app

app::main
