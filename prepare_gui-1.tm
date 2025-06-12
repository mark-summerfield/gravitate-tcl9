# Copyright © 2024-25 Mark Summerfield. All rights reserved.

catch {
    set fh [open [file join [file home] .wishinit.tcl]]
    eval [read $fh]
    close $fh
}
ttk::style theme use clam
option add *tearOff 0
option add *insertOffTime 0
ttk::style configure . -insertofftime 0
const LINEHEIGHT [font metrics font -linespace]
ttk::style configure Treeview -rowheight $::LINEHEIGHT
ttk::style configure TCheckbutton -indicatorsize \
    [expr {$::LINEHEIGHT * 0.55}]
