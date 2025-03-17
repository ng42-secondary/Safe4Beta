extends BaseCensorBox

static var frame_count = -1  # only one node will update the material

func _ready():
	super._ready()
	update_back_screen()

func _blur_changed(radius: float):
	$%BlurX.material.set_shader_parameter("radius", radius)
	$%BlurY.material.set_shader_parameter("radius", radius)
	$%BlurRadiusLabel.text = "%.2f" % [radius]
	
	
func update_back_screen():
	var fc = Engine.get_process_frames()
	if frame_count == fc:
		return
	frame_count = fc
	var current_screen_texture : ImageTexture = BetaData.screen_recorder.get_screen_texture()
	var margin_x = MARGIN * box_detect[2]
	var margin_y = MARGIN * box_detect[3]
	position = Vector2(box_detect[0] - margin_x, box_detect[1] - margin_y)
	$TextureRectY.size = Vector2(box_detect[2] + 2*margin_x, box_detect[3] + 2*margin_y)
	$TextureRectY.texture = current_screen_texture
	$TextureRectX.size = Vector2(box_detect[2] + 2*margin_x, box_detect[3] + 2*margin_y)
	$TextureRectX.texture = current_screen_texture
	
func _process(_delta):
	# update material once per frame
	update_back_screen()
	
