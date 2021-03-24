extends RigidBody2D


export var min_speed = 150 # Minimum speed range.
export var max_speed = 250 # Maximum speed range.


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()] # select random animation between 0 and n-1


# When the Mob exits the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
