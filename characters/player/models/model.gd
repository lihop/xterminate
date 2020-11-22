extends Spatial


var is_moving := false


func _physics_process(_delta):
	var anim_to_play := "Idle"
	if is_moving:
		anim_to_play = "Run"
	var current_anim = $AnimationPlayer.current_animation
	if current_anim != anim_to_play:
		$AnimationPlayer.play(anim_to_play)
