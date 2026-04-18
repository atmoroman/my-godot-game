extends Node2D

@onready var chord_players = {
	"Am": $Am,
	"G":  $G,
	"C":  $C,
	"F":  $F
}

@onready var strum_players = [$StrumA, $StrumB]
@onready var chord_label   = $ChordLabel
@onready var pattern_btn   = $PatternButton

# Map keyboard keys → chord names
var key_to_chord = {
	KEY_A: "Am",
	KEY_S: "G",
	KEY_D: "C",
	KEY_F: "F"
}
