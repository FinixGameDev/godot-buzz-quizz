extends Node

func _ready() -> void:
	setup_buzzers()

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		print_debug(event.button_index)

func setup_buzzers():
	for i in range(0, 20):
		var input_button : InputEventJoypadButton = InputEventJoypadButton.new()
		input_button.button_index = i
		
		if i % 5 == 0:
			InputMap.add_action("player_" + str(i / 5 + 1) + "_buzzer")
			InputMap.action_add_event("player_" + str(i / 5 + 1) + "_buzzer", input_button)
		else:
			InputMap.add_action("player_" + str(i / 5 + 1) + "_button_" + str(i % 5))
			InputMap.action_add_event("player_" + str(i / 5 + 1) + "_button_" + str(i % 5), input_button)
