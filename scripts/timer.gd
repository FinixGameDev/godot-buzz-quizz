extends PanelContainer

@onready var timer = $Timer as Timer
@onready var slider = $MarginContainer/HBoxContainer/HSlider as HSlider
@onready var label = $MarginContainer/HBoxContainer/Label as Label


func _process(delta: float) -> void:
	slider.value = timer.time_left * (1000 / timer.wait_time)
	label.text = "0" + str(int(timer.time_left/60)) + ":" + (("0" + str(int(timer.time_left)%60)) if (int(timer.time_left)%60<10) else str(int(timer.time_left)%60))
	
