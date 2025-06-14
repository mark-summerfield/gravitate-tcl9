#!/usr/bin/env wish9
# Copyright © 2020-25 Mark Summerfield. All rights reserved.

const VERSION 9.0.0
const INVALID -1
const PAD 3
const VGAP 6
const BACKGROUND_COLOR "#FFFEE0"

const COLUMNS_DEFAULT 9
const ROWS_DEFAULT 9
const MAX_COLORS_DEFAULT 4
const DELAY_MS_DEFAULT 200
const HIGH_SCORE_DEFAULT 0

const COLORS {
    "#A00000" "#F88888"
    "#A00000" "#F88888"
    "#00A000" "#88F888"
    "#A0A000" "#F8F888"
    "#0000A0" "#8888F8"
    "#A000A0" "#F888F8"
    "#00A0A0" "#88F8F8"
    "#A0A0A0" "#F8F8F8"
}
const INVALID_COLOR ""
const GAME_OVER_EVENT <<GameOver>>
const SCORE_EVENT <<Score>>

const INI_BOARD Board
const INI_COLUMNS columns
const INI_ROWS rows
const INI_MAX_COLORS maxColors
const INI_DELAY_MS delayMs
const INI_HIGH_SCORE highScore
const INI_HIGH_SCORE_COMPAT HighScore

const INI_WINDOW Window
const INI_WINDOW_HEIGHT height
const INI_WINDOW_WIDTH width
const INI_WINDOW_X x
const INI_WINDOW_Y y
const INI_SCALE scale
