extends BaseCensorBox


static var frame_count = -1  # only one node will update the material


func _ready():
	update_screen()


func update_screen():
	var fc = Engine.get_process_frames()
	if frame_count == fc:
		return
	frame_count = fc
	var current_screen_texture : ImageTexture = BetaData.screen_recorder.get_screen_texture()
	$TextureRect.material.set_shader_parameter("screen_texture", current_screen_texture)


func _process(_delta):
	# update material once per frame
	update_screen()
	
