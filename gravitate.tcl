#!/usr/bin/env wish9
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

const APPPATH [file normalize [file dirname [info script]]]
tcl::tm::path add $APPPATH

package require app

app::main
