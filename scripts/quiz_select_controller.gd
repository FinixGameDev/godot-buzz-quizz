extends Control

@export var buttons : Array[Button]
@export var quizzes : Array[Quiz]

func _ready() -> void:
	attach_buttons()

func attach_buttons():
	var i = 0
	for button in buttons:
		button.pressed.connect(func(): select_quiz(i), CONNECT_ONE_SHOT)
		button.icon = quizzes[i].banner
		button.text = quizzes[i].name
		i += 1

func select_quiz(i : int):
	$AnimationPlayer.play_backwards("fade_in")
	await get_tree().create_timer(1).timeout
	Global.play_quiz(quizzes[i])
