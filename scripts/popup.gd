extends PanelContainer
class_name GamePopup

@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var is_open = false
@export var banner : TextureRect
@export var text : Label

signal open
signal close


func popup():
	is_open = true
	animation_player.play("pop_up")
	open.emit()

func _input(event: InputEvent) -> void:
	if is_open && Input.is_key_pressed(KEY_ENTER):
		popdown()

func popdown():
	is_open = false
	animation_player.play("pop_down")
	close.emit()
