extends CharacterBody3D

# Emitted when the player was hit by a mob.
# Put this at the top of the script.
signal hit;

# How fast teh player moves in meters per second.
@export var speed = 14;
# The downward accelaration when in the air, in meters per second squared.
@export var fall_accelaration = 75;

# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20;

#When squashing an enemy, we don't necessarily want the character to go
#as high up as when jumping.
# Vertical impulse applied to the character upon bouncing over a mob in
# meters per second.
@export var bounce_impulse = 16;

var target_velocity = Vector3.ZERO;
#The target_veolocity is a 3d vector combining a speed with a direction.
#We define it as a property because we want to update and reuse it across frames.
#In 2D, 1000 is for pixels, but in 3D it's a kilometer.

#We start by calculating the input direction vector using the global Input object,
#in _physics_process().
func _physics_process(delta):
	var direction = Vector3.ZERO;
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1;
	if Input.is_action_pressed("move_left"):
		direction.x -= 1;
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1;
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1;
	"""
	Moving up or down will have the model move 1 meter. But if the
	player decides to move diagnocally, by default the character 
	will move faster diagnally at 1.4. We want the vector's length
	to be consistent. To do so, we can call its normalized() method.  
	"""
	if direction != Vector3.ZERO:
		direction = direction.normalized();
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction);
	#We only normalized if the vector if the direction has a length greater
	#than zero, which means the player is pressing a direction key.
		#Adding code for the animation of character
		$AnimationPlayer.speed_scale = 4;
	else:
		$AnimationPlayer.speed_scale = 1;
		#This code makes it so when the player moves, we multiply the playback
		#speed by 4. When they stop, we rest it to normal.
	
	#We have to calculate the ground velocity and the fall speed separately.
	# Ground Velocity.
	target_velocity.x = direction.x * speed;
	target_velocity.z = direction.z * speed;
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity.
		target_velocity.y = target_velocity.y - (fall_accelaration * delta);
		
	# Moving the Character
	velocity = target_velocity;
	
	#Added before the move_and_slide() code block.
	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse;
		
	"""
	In every iteration of the loop, we check if we landed on a mob. If so, we kill it and bounce.
	With this code, if no collisions occurred on a given frame, the loop won't run.
	"""
	# Iterate though all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index);
		
		# If the collision is with ground
		if collision.get_collider() == null:
			continue;
		
		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider();
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				mob.squash();
				target_velocity.y = bounce_impulse;
				# Prevent further duplicate calls.
				break
				
	move_and_slide();
	
	#We can make the character arc when jumping using the following line of code.
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse;

# And this function at the bottom.
func die():
	hit.emit();
	queue_free();

func _on_mob_detector_body_entered(body):
	#pass # Replace with function body.
	die();
