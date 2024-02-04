extends State

func enter(_laststate):
	parent.setParticle(0, false)
	parent.setParticle(1, false)

func process_state():
	if parent.onSlope() and Input.is_action_just_pressed("ui_down"):
		return "ROLL"
		
	elif Input.get_axis("ui_left", "ui_right") != 0:
		if Input.is_action_pressed("run") and parent.couldUncounch(true):
			return "TOP_SPEED"
		
		return "RUN"

	elif parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif not parent.onFloor().has(true):
		return "FALL"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0 and parent.couldUncounch(true):
		return "ATTACK"
	
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and parent.canLadder:
		return "LADDER"

	return null
	
func process_physics(_delta):

	parent.idleBase()
	
	if parent.counched:
		parent.playback.travel("COUNCH")
	else:
		parent.playback.travel("IDLE")