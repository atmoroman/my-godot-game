extends Node2D

var strum_direction = "down"
var key_to_chord = {
	KEY_A: "Am",
	KEY_S: "G",
	KEY_D: "C",
	KEY_F: "F"
}

# Map chord name to its UI button
var chord_buttons = {}
var chord_sounds = {}
var strum_players = []
var last_player = null  # tracks what's currently playing so we never cut it

@onready var chord_label     = $UI/ChordLabel
@onready var direction_label = $UI/DirectionLabel
@onready var player_sprite   = $AnimatedSprite2D

# Colors for highlight effect
const HIGHLIGHT_COLOR = Color(0.583, 0.583, 0.583, 1.0)   # yellow glow
const NORMAL_COLOR    = Color(1.0, 1.0, 1.0)     # white (no tint)

func _ready():
	chord_sounds = {
		"Am": { "up": $Audio/Am_Up,   "down": $Audio/Am_Down },
		"G":  { "up": $Audio/G_Up,    "down": $Audio/G_Down  },
		"C":  { "up": $Audio/C_Up,    "down": $Audio/C_Down  },
		"F":  { "up": $Audio/F_Up,    "down": $Audio/F_Down  }
	}


	#button references for highlight lookup
	chord_buttons = {
		"Am": $UI/AmButton,
		"G":  $UI/GButton,
		"C":  $UI/CButton,
		"F":  $UI/FButton
	}

	chord_label.text     = "Press A S D F"
	direction_label.text = "Strum: DOWN"

	$UI/AmButton.pressed.connect(func(): play_chord("Am"))
	$UI/GButton.pressed.connect(func():  play_chord("G"))
	$UI/CButton.pressed.connect(func():  play_chord("C"))
	$UI/FButton.pressed.connect(func():  play_chord("F"))
	$UI/UpArrowButton.pressed.connect(func():
		strum_direction = "up"
		direction_label.text = "Strum: UP"
	)
	$UI/DownArrowButton.pressed.connect(func():
		strum_direction = "down"
		direction_label.text = "Strum: DOWN"
	)
	player_sprite.play("idle")

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if key_to_chord.has(event.keycode):
			play_chord(key_to_chord[event.keycode])
		elif event.keycode == KEY_UP:
			strum_direction = "up"
			direction_label.text = "Strum: UP"
		elif event.keycode == KEY_DOWN:
			strum_direction = "down"
			direction_label.text = "Strum: DOWN"

func highlight_button(chord_name: String):
	# Reset all buttons to normal first
	for btn in chord_buttons.values():
		btn.modulate = NORMAL_COLOR

	# Highlight only the active one
	chord_buttons[chord_name].modulate = HIGHLIGHT_COLOR

func play_chord(chord_name: String):
	var new_player = chord_sounds[chord_name][strum_direction]
	new_player.play()

	chord_label.text = chord_name + " (" + strum_direction + ")"
	highlight_button(chord_name)

	# Switch to playing animation
	player_sprite.play("playing")

func _process(delta):
	# Go back to idle when no sound is playing
	var any_playing = false
	for dir_dict in chord_sounds.values():
		for player in dir_dict.values():
			if player.playing:
				any_playing = true
				break
	
	if any_playing:
		if player_sprite.animation != "playing":
			player_sprite.play("playing")
	else:
		if player_sprite.animation != "idle":
			player_sprite.play("idle")
