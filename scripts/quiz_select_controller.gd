extends Control

@export var buttons : Array[Button]
@export var quizzes : Array[Quiz] = [null, null, null, null]

func _ready() -> void:
	attach_buttons()

func attach_buttons():
	var iter = 1
	var quizI = 0
	for button in buttons:
		button.shortcut = Shortcut.new()
		button.pressed.connect(func(): Global.play_quiz(quizzes[quizI]))
		button.text = quizzes[quizI].name
		button.icon = quizzes[quizI].banner
		for i in range(1,5):
			var input = InputEventAction.new()
			input.action = "player_" + str(i) + "_button_" + str(iter)
			button.shortcut.events.append(input)
		iter += 1
