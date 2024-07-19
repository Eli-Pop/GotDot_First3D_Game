extends Label

var score = 0;

func _on_mob_squashed():
	score += 1;
	text = "Score: %s" % score;
	#The above line, uses the value of the score variable to repalce the palceholder %s.
	#When using this feature, Godot automatically converts values to string text.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
