extends Node

var selected_quiz : Quiz = null

var player_score : Array[int] = [0,0,0,0]

func play_quiz(quiz : Quiz):
	selected_quiz = quiz
	get_tree().change_scene_to_file("res://scenes/quiz_game.tscn")

func reset_score():
	player_score = [0,0,0,0]
