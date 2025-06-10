#!/bin/bash
clc -l tcl -s
nagelfar.sh \
    | grep -v 'W Variable "moves" is never read' \
    | grep -v '^[ \t]\+Argument' \
    | grep -v Found.constant.. \
    | grep -v Wrong.number.of.arguments.*to..actions::on_game_over \
    | grep -v Wrong.number.of.arguments.*to..ini::open \
    | grep -v gravitate.tcl.*Unknown.variable..APPPATH \
    | grep -v board.*tm.*Suspicious.variable.*board::drawing \
    | grep -v board.*tm.*Unknown.variable.*dark \
    | grep -v board.*tm.*Unknown.variable.*height \
    | grep -v board.*tm.*Unknown.variable.*light \
    | grep -v board.*tm.*Unknown.variable.*move \
    | grep -v board.*tm.*Unknown.variable.*n[xy] \
    | grep -v board.*tm.*Unknown.variable.*width \
    | grep -v tm.*Unknown.command.*lambda \
    | grep -v options_form.*tm.*Unknown.command..ini:: \
    | grep -v util.*tm.*Unknown.command.*make_default_ini \
    | grep -v Unknown.subcommand.*home.*to.*file \
    | grep -v Unknown.command.*const \
    | grep -v Unknown.command.*delete_tile \
    | grep -v Unknown.command.*ini:: \
    | grep -v Unknown.command.*::lambda \
    | grep -v Unknown.command.*_form::show.* \
    | grep -v Unknown.command.*board::* \
    | grep -v Unknown.command.*app::main \
    | grep -v Unknown.command.*main_window::* \
    | grep -v Unknown.command.*struct::set \
    | grep -v Unknown.command.*tooltip::tooltip \
    | grep -v Unknown.command.*ttk::spinbox \
    | grep -v Unknown.command.*ui::* \
    | grep -v Unknown.command.*util::* \
    | grep -v Unknown.variable.*app::.*
git st
