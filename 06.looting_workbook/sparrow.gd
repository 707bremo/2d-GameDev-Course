extends Node2D

# Setup basic nodes for the bird scene, including Sprite1, Sprite2 (AKA: Shadow), and the timer.
# Hold shift and click top Sprite node, then timer node, then drag and hold CMD before releasing.
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shadow: Sprite2D = $Shadow
@onready var hop_timer: Timer = $HopTimer

func _ready() -> void:
# We must make the wait time of the timer random, or bird(s) would jump at the same time.
	hop_timer.wait_time = randf_range(1.0, 3.0)
	hop_timer.timeout.connect(_animate_one_hop)
	hop_timer.start()

# Create a animate one hop function following the ready() function.
# This function works around with the timeout signal (As seen in its parameter)
func _animate_one_hop() -> void:

# During the hop, it is calulated midway so that the jump patterns are random for each bird.
	const HOP_DURATION := 0.25
	const HALF_HOP_DURATION := HOP_DURATION / 2.0

# Demonstrate random directions and landing spots for the bird.
	var random_direction := Vector2(1.0, 0.0).rotated(randf() * 2.0 * PI)
	var land_position := random_direction * randf_range(0.0, 30.0)

# We must animate both the hop and shadow at the same time using tweens (Refer back to Tween in the API to understand what to use)
	var tween := create_tween().set_parallel()
	tween.tween_property(sprite_2d, "position:x", land_position.x, HOP_DURATION)
	tween.tween_property(shadow, "position", land_position, HOP_DURATION)

# Using tweens again, animate its up and down hop movement.
	tween = create_tween()

# Now use the properties we utilized in the lessons (You can refer to the API for futher guidance)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	const JUMP_HEIGHT := 16.0

# Jump can go up and down using these properties.
	tween.tween_property(sprite_2d, "position:y", land_position.y - JUMP_HEIGHT, HALF_HOP_DURATION)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(sprite_2d, "position:y", land_position.y, HALF_HOP_DURATION)

# This timer's activation duration is randomized through a 1-3 second variation.
	hop_timer.wait_time = randf_range(1.0, 3.0)

#In lessons 7-8, we learned about the finished signal. This stops the animations and restarts the timer so that the hop animation plays all over again.
	tween.finished.connect(hop_timer.start)
