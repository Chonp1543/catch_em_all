extends Node2D

const POWER_UP_BONUS_TIME : int = 5
const BASIC_LEVEL : int = 5
const CURRENT_LEVEL : int = 1
const BONUS_TIME : int = 5
const LIMIT_SPEED : int = 500
var level : int = 0
var screensize : Vector2 = Vector2.ZERO
#exportar la escena gem
export (PackedScene) var gem
var cherry = preload("res://tscn/cherry_tscn/cherry.tscn")
var time_left : int = 0
var score : int = 0
onready var game_over_timer : Timer = Timer.new()

func _ready() -> void:
#	$froggy.visible = false
	randomize()
	OS.center_window()
	timer_settings()
	time_left = 30
	$HUD/lblgameover.visible = false
	$HUD.update_timer(time_left)
	screensize = get_viewport().get_visible_rect().size
	spawn_gems()
	set_cherry_timer()
#	$froggy.visible = true

#hacer un timer desde el codigo
func timer_settings() -> void:
	game_over_timer.wait_time = 2
	game_over_timer.connect("timeout", self, "_on_game_over_timer_timeout")
	self.add_child(game_over_timer)


func _on_game_over_timer_timeout():
	get_tree().change_scene("res://tscn/menu_tscn/Menu.tscn")



func _process(_delta : float) -> void:

#	reiniciar la funcion spawn_gems()
	if $gemcontainer.get_child_count() == 0:
		level += 1
		time_left += BONUS_TIME
#		sonido al pasar de nivel
		var Audio = AudioStreamPlayer.new()
		Audio.stream = load("res://audio/Level.wav")
		add_child(Audio)
		Audio.play()
		spawn_gems()
		$HUD.update_level(level + CURRENT_LEVEL)
		player_speed_increment()



func player_speed_increment() -> void:
#	aumentar la velocidad con cada nivel
		for i in level + CURRENT_LEVEL:
				$player.speed += 10
#				tope de velocidad
				if level + CURRENT_LEVEL >= 6:
					$player.speed = LIMIT_SPEED


#hacer aparecer las gemas y aumentar su numero por cada nivel
func spawn_gems() -> void:
	for _index in range(BASIC_LEVEL + level):
#		instanciar una gema
		var Gem = gem.instance()
#		colocar gemas en posiciones aleatorias
#	screensize reemplaza los valores de x e y numericos
		Gem.position = Vector2(rand_range(0,screensize.x),
		rand_range(0,screensize.y))
		$gemcontainer.add_child(Gem)




func _on_Timer_timeout() -> void:
#	decrementar el timer
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
#		viene de player.gd
		game_over()




func game_over() -> void:
	$Timer.stop()
	$HUD/lblgameover.visible = true
	$player.game_over()
	$hurtaudio.play()
	game_over_timer.start()


func _on_player_picked(type) -> void:
	match type:
		"gem":
			score += 1
			$HUD.update_score(score)
		"cherry":
			time_left += POWER_UP_BONUS_TIME
			$HUD.update_timer(time_left)
			score += 5
			$HUD.update_score(score)


func set_cherry_timer() -> void:
	var interval = rand_range(5, 10)
	$cherryTimer.wait_time = interval
	$cherryTimer.start()



func _on_cherryTimer_timeout() -> void:
	$cherryTimer.stop()
	var Cherry = cherry.instance()
	Cherry.position = Vector2(rand_range(0,screensize.x),
	 rand_range(0,screensize.y))
	$gemcontainer.add_child(Cherry)
	set_cherry_timer()



func _on_player_hurt() -> void:
	game_over()

