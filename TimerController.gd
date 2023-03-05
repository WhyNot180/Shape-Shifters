extends Node
class_name TimerController


signal gravity_change(gravity_strength)
signal side_amount_change(side_amount)
signal hidden_side_amount_change(hidden_side_amount)


# how fast time goes on
export (float) var easy_time_scale = 0.5
export (float) var normal_time_scale = 1.0
export (float) var hard_time_scale = 2.0


export (float) var gravity_strength = 500.0 # pixels/second^2
export (int) var sides = 3
export (int) var hidden_sides = 1


export (float) var gravity_strength_increase_factor = 1.10
export (float) var side_increase_amount = 1.0
export (float) var hidden_side_increase_amount = 0.5


export (float) var gravity_strength_increase_interval = 4.0 # seconds
export (float) var side_increase_interval = 4.0 # seconds
export (float) var hidden_side_increase_interval = 4.0 # seconds
export (float) var hidden_side_shuffle_interval = 2.0 # seconds


func _init():
	# if false, there will eventually be more hidden sides than actual sides
	assert(side_increase_amount >= hidden_side_increase_amount)
	assert(side_increase_interval >= hidden_side_increase_interval)


func _ready():
	set_normal_difficulty()


func _on_gravity_increase_timeout():
	gravity_strength *= gravity_strength_increase_factor
	emit_signal("gravity_change", gravity_strength)
	get_node("GravityIncreaseTimer").start()


func _on_side_increase_timeout():
	sides += side_increase_amount
	emit_signal("side_amount_change", float(sides))
	get_node("SideIncreaseTimer").start()


func _on_hidden_side_increase_timeout():
	hidden_sides += hidden_side_increase_amount
	emit_signal("hidden_side_amount_change", float(hidden_sides))
	get_node("HiddenSideIncreaseTimer").start()


func _on_hidden_side_shuffle_timeout():
	# do *not* increase hidden_side_amount
	emit_signal("hidden_side_amount_change", float(hidden_sides))
	get_node("HiddenSideShuffleTimer").start()


func _on_game_start():
	get_node("GravityIncreaseTimer").start()
	get_node("SideIncreaseTimer").start()
	get_node("HiddenSideIncreaseTimer").start()
	get_node("HiddenSideShuffleTimer").start()


func _on_game_end():
	get_node("GravityIncreaseTimer").stop()
	get_node("SideIncreaseTimer").stop()
	get_node("HiddenSideIncreaseTimer").stop()
	get_node("HiddenSideShuffleTimer").stop()


func _set_wait_times(time_scale: float):
	get_node("GravityIncreaseTimer").wait_time = gravity_strength_increase_interval / time_scale
	get_node("SideIncreaseTimer").wait_time = side_increase_interval / time_scale
	get_node("HiddenSideIncreaseTimer").wait_time = hidden_side_increase_interval / time_scale
	get_node("HiddenSideShuffleTimer").wait_time = hidden_side_shuffle_interval / time_scale


func set_easy_difficulty():
	_set_wait_times(easy_time_scale)


func set_normal_difficulty():
	_set_wait_times(normal_time_scale)


func set_hard_difficulty():
	_set_wait_times(hard_time_scale)
