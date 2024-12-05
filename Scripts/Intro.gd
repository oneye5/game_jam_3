extends Node

@export var fade_in_duration: float = 1.0
@export var fade_out_duration: float = 1.0
@export var text_display_duration: float = 3.0
@export var text_fade_duration: float = 0.5
@export var next_scene: PackedScene  # scene to load after intro

@onready var fg = $fg/ColorRect
@onready var l1 = $text/Label
@onready var l2 = $text/Label2
@onready var l3 = $text/Label3
@onready var l4 = $text/Label4

var current_label_index: int = 0
var labels: Array
var sequence_complete: bool = false

func _ready() -> void:
	labels = [l1, l2, l3, l4]
	
	for label in labels:
		label.visible = false
		label.modulate.a = 0.0
	
	fg.color = Color(0, 0, 0, 1)
	fg.visible = true
	
	start_intro_sequence()

func start_intro_sequence() -> void:
	var tween = create_tween()
	tween.tween_callback(show_next_label)

func show_next_label() -> void:
	if current_label_index >= labels.size():
		# transition to next scene when all labels are shown
		change_scene()
		return
	
	var out_tween = create_tween()
	out_tween.tween_property(fg, "color:a", 0.0, fade_out_duration)
	out_tween.tween_callback(func():
		labels[current_label_index].visible = true
		var label_tween = create_tween()
		label_tween.tween_property(labels[current_label_index], "modulate:a", 1.0, text_fade_duration)
	)
	out_tween.tween_interval(text_display_duration)
	out_tween.tween_callback(hide_current_label)

func hide_current_label() -> void:
	var label_fade_out = create_tween()
	label_fade_out.tween_property(labels[current_label_index], "modulate:a", 0.0, text_fade_duration)
	
	var in_tween = create_tween()
	in_tween.tween_property(fg, "color:a", 1.0, fade_in_duration)
	in_tween.tween_callback(func():
		labels[current_label_index].visible = false
		current_label_index += 1
		
		show_next_label()
	)

func change_scene() -> void:
	# use a fade transition when changing scenes
	var transition_tween = create_tween()
	transition_tween.tween_property(fg, "color:a", 1.0, fade_in_duration)
	transition_tween.tween_callback(func():
		# ensure scene is only changed when fully faded to black
		if next_scene:
			get_tree().change_scene_to_packed(next_scene)
		else:
			print("no next scene assigned")
	)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		change_scene()
