extends Node2D

# References to all audio players
@onready var chord_players = {
	"Am": $Am,
	"G":  $G,
	"C":  $C,
	"F":  $F
}

@onready var strum_players = [$StrumA, $StrumB]
@onready var chord_label   = $ChordLabel
@onready var pattern_btn   = $PatternButton

# Keyboard binds for chords
var key_to_chord = {
	KEY_A: "Am",
	KEY_S: "G",
	KEY_D: "C",
	KEY_F: "F"
}

var current_strum_index = 0   # 0 = Pattern A, 1 = Pattern B
var pattern_names = ["Pattern A", "Pattern B"]

func _ready():
	chord_label.text  = "Press A S D F"
	pattern_btn.text  = "Strum: Pattern A"
	pattern_btn.pressed.connect(_on_pattern_button_pressed)

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if key_to_chord.has(event.keycode):
			play_chord(key_to_chord[event.keycode])

func play_chord(chord_name: String):
	# Stop all chord players first
	for player in chord_players.values():
		player.stop()

	# Play the selected chord
	chord_players[chord_name].play()
	chord_label.text = chord_name

	# Also trigger the current strum pattern
	strum_players[current_strum_index].stop()
	strum_players[current_strum_index].play()

func _on_pattern_button_pressed():
	# Toggle between pattern 0 and 1 (add more if needed)
	current_strum_index = (current_strum_index + 1) % strum_players.size()
	pattern_btn.text = "Strum: " + pattern_names[current_strum_index]
