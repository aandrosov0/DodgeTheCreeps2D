extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()
	
	if not $Player.visible:
		$MobTimer.start()
		
	
func game_over():
	$DeathSound.play()
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	
	$HUD.show_game_over()
	
func game_start():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()	
	$MobTimer.stop()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	var direction = mob_spawn_location.rotation + PI / 2 
	
	mob.position = mob_spawn_location.position
	
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func new_game():
	game_start()
	$Music.play()
	$HUD.update_score(0)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
