# Copyright © 2024-25 Mark Summerfield. All rights reserved.

if {[info exists env(TK_SCALING)]} {tk scaling $env(TK_SCALING)}
ttk::style theme use clam
option add *tearOff 0
option add *insertOffTime 0
ttk::style configure . -insertofftime 0
const LINEHEIGHT [font metrics font -linespace]
ttk::style configure Treeview -rowheight $::LINEHEIGHT
ttk::style configure TCheckbutton -indicatorsize \
    [expr {$::LINEHEIGHT * 0.55}]
