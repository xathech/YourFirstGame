extends Area2D
signal hit(lives)
signal game_over


export var speed = 400 # How fast the player will move (pixels/sec).
export var lives = 3 # How many lives the player has before game over.

var screen_size # Size of the game window.
var remaining_lives # How many lives the player has remaining


# Called when the node enters the scene tree for the first time.
func _ready():
	
	hide()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity = Vector2() # The player's movement vector.
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
		
	else:
		
		$AnimatedSprite.stop()
	
	position += velocity * delta
	# Limit position to screen size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# if/else shorthand
		$AnimatedSprite.flip_h = velocity.x < 0
		
	elif velocity.y != 0:
		
		$AnimatedSprite.animation = "up"
		# if/else shorthand
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	
	# When a Mob touches the player	
	remaining_lives-=1
	
	emit_signal("hit",remaining_lives)

	if remaining_lives <= 0:# If there are no remaining lives
		hide()
		emit_signal("game_over")
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		decrease_lives()
	
func start(pos):
	
	# Reset lives
	remaining_lives = lives
	emit_signal("hit",remaining_lives)
	position = pos
	show()
	$CollisionShape2D.disabled = false

func decrease_lives():
	
	# Disable collision
	$CollisionShape2D.set_deferred("disabled", true)
	# Halve sprite alpha to indicate invulnerability
	modulate.a = 0.5
	# Stop execution while timer is active
	yield(get_tree().create_timer(3.0), "timeout")
	# Restore sprite alpha
	modulate.a = 1
	# Enable collision
	$CollisionShape2D.set_deferred("disabled", false)	
