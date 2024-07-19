extends Node

#We first export a variable to the Inspector so that we can assign
#mob.tscn or any other monster to it.
@export var mob_scene: PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass # Replace with function body.
	#We want to hide the overlay at the start of the game.
	$UserInterface/Retry.hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

"""
1. Instantiate the mob scene.
2. Sample a random position on the spawn path.
3. Get the palyer's position.
4. Call the mob's initialize() method, passing it the random position
and the player's position.
5. Add the mob as a child of the Main node.
"""
func _on_mob_timer_timeout():
	#pass # Replace with function body.
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate();
	
	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation");
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf();
	
	var player_position = $Player.position;
	mob.initialize(mob_spawn_location.position, player_position);
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob);
	
	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind());
	#The above line means that when the mob emits the squashed signal, the ScoreLabel
	#node will receive it and call the funciton _on_mob_squashed().


func _on_player_hit():
	#pass # Replace with function body.
	$MobTimer.stop();
	#When the player gets hit, we show the overlay.
	$UserInterface/Retry.show();
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene();
