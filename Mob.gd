extends CharacterBody3D

# Minumum speed of the mob in meters per second.
@export var min_speed = 10;
# Maximum speed of the mob in meters per second.
@export var max_speed = 18;

# Emitted when the player jumped on the mob.
signal squashed

func _physics_process(delta):
	move_and_slide();

# This function will be called form the Main scene.
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and  rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP);
	# Rotate this mob randomly with range of -45 and +45 degrees,
	# so that it doens't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4));
	
	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed);
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed;
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction to the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y);
	
	#Adding the animation speed as we copied that animationplayer to the mob.
	$AnimationPlayer.speed_scale = random_speed / min_speed;


func _on_visible_on_screen_notifier_3d_screen_exited():
	#pass # Replace with function body.
	queue_free(); # This function destroys the instance it's called on.

func squash():
	squashed.emit();
	queue_free();
