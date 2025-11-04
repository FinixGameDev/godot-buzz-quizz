extends Control

@export var answer_buttons : Array[Button]
@export var buzzer_buttons : Array[Button]
@export var player_labels : Array[Label]

@export var question_label : Label
@export var question_banner : TextureRect
@onready var qID : int = 0

@onready var icon_tex : Texture2D = load("res://resources/sprites/button.png")
@onready var icon_pressed : Texture2D = load("res://resources/sprites/button_pressed.png")

@export var timer : Timer

var selected_player : int = -1

enum STATE {START_QUESTION, PLAYER_SELECT, ANSWER, TIME_OUT, END_QUESTION, END_GAME}

var state : STATE

func _ready() -> void:
	var i = 0
	for button in answer_buttons:
		button.shortcut = Shortcut.new()
		button.pressed.connect(func(): if state == STATE.ANSWER: check_answer(i))
		i += 1
	
	state_switch(STATE.START_QUESTION)
	

func state_switch(state : STATE):
	match state:
		STATE.START_QUESTION:
			for button in answer_buttons:
				button.disabled = true
			
			for button in buzzer_buttons:
				button.icon = icon_tex
			
			if (Global.selected_quiz != null):
				var question : Question = Global.selected_quiz.questions[qID]
				question_label.text = question.question
				question_banner.texture = question.image
				var aID : int = 0
				for answer in question.answers:
					answer_buttons[aID].text = answer
					aID += 1
			
			self.state = STATE.START_QUESTION
			timer.start()
			attach_buzzer_buttons()
			state_switch(STATE.PLAYER_SELECT)
			
		STATE.PLAYER_SELECT:
			BuzzLights.blinking = true
			var id = 0
			for button in buzzer_buttons:
				button.disabled = false 
				button.pressed.connect(func(): select_player(id), CONNECT_ONE_SHOT)
				id += 1
			self.state = STATE.PLAYER_SELECT
			
		STATE.ANSWER:
			BuzzLights.blinking = false
			for button in buzzer_buttons:
				button.disabled = true
			
			buzzer_buttons[selected_player].disabled = false
			
			for button in answer_buttons:
				button.disabled = false
				attach_answer_buttons(selected_player)
			self.state = STATE.ANSWER
			
		STATE.END_QUESTION:
			release_answer_buttons()
			for button in buzzer_buttons:
				button.disabled = true
			for button in answer_buttons:
				button.disabled = true
			selected_player = -1
			qID += 1
			
			self.state = STATE.END_QUESTION
			
			if qID < Global.selected_quiz.questions.size():
				state_switch(STATE.START_QUESTION)
			else: 
				state_switch(STATE.END_GAME)
		
		STATE.END_GAME:
			Global.reset_score()
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
		STATE.TIME_OUT:
			if selected_player == -1:
				for score in Global.player_score:
					score -= 1
			else:
				Global.player_score[selected_player] -= 1
			#state_switch(STATE.END_QUESTION)

func attach_buzzer_buttons():
	var i = 1
	for button in buzzer_buttons:
		button.shortcut = Shortcut.new()
		var input = InputEventAction.new()
		input.action = "player_" + str(i) + "_button_1"
		i += 1

func attach_answer_buttons(player_id : int):
	var i = 1
	for button in answer_buttons:
		var input = InputEventAction.new()
		input.action = "player_" + str(player_id) + "_button_" + str(i)
		button.shortcut.events.append(input)
		i += 1



func release_answer_buttons():
	for button in answer_buttons:
		button.shortcut.events.clear()

func release_buzzer_buttons():
	for button in buzzer_buttons:
		button.shortcut.events.clear()

func check_answer(id : int):
	if  id == Global.selected_quiz.questions[qID].correctIndex:
		Global.player_score[selected_player] += 1
		player_labels[selected_player].text = str(Global.player_score[selected_player])
	else:
		Global.player_score[selected_player] -= 1
		player_labels[selected_player].text = str(Global.player_score[selected_player])
	state_switch(STATE.END_QUESTION)

func select_player(id: int):
	selected_player = id
	for i in range(1, 4):
		buzzer_buttons[i - 1].set_pressed_no_signal(false)
		BuzzLights.set_buzz_light(i, false)
		
	buzzer_buttons[id].set_pressed_no_signal(true)
	buzzer_buttons[id].icon = icon_pressed
	release_buzzer_buttons()
	
	state_switch(STATE.ANSWER)

func _on_timer_timeout() -> void:
	state_switch(STATE.TIME_OUT)
