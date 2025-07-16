#!/bin/bash
clc -l tcl -s
nagelfar.sh \
    | grep -v Unknown.command \
    | grep -v Unknown.variable \
    | grep -v No.info.on.package.*found \
    | grep -v Bad.option.-striped.to..ttk::treeview. \
    | grep -v Variable.*is.never.read \
    | grep -v Found.constant.*which.is.also.a.variable \
    | grep -v Suspicious.variable.name...my.varname \
    | grep -v test_store.tcl.*Found.constant..filename
git st
