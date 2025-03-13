class_name GameMenu

extends Control

var main_game

static var censor_cateogry_porn = "0"
static var censor_cateogry_sexy = "1"
static var censor_cateogry_cute = "2"
static var censor_cateogry_beta = "3"
static var censor_cateogry_male = "4"
static var censor_cateogry_faces = "5"

# Called when the node enters the scene tree for the first time.
func _ready():
	BetaData.menu = self
	main_game = get_parent().get_parent()
	var wind: Window = get_parent()
	wind.connect("close_requested", _on_exit_button_pressed)
	await get_tree().process_frame
	apply_menu_config()


func apply_menu_config():
	# all the saved config will be applied before the first frame proccessed
	# it's like if the user clicked on all the menu buttons he wants
	var is_game_mode = BetaData.game_data.game_mode
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/CheckBox.button_pressed = is_game_mode
	var hud_visible = BetaData.game_data.hud_visible
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/CheckBox2.button_pressed = hud_visible
	var xp_multiplier = BetaData.game_data.xp_multiplier
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/HBoxContainer4/HSliderXpMult.value = xp_multiplier
	var hud_x = BetaData.game_data.hud_x
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/HBoxContainer/HSliderHoriz.value = hud_x
	var hud_y = BetaData.game_data.hud_y
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/HBoxContainer2/HSliderVert.value = hud_y
	var hud_scale = BetaData.game_data.hud_scale
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/HBoxContainer3/HSliderScale.value = hud_scale
	var fs_text = BetaData.game_data.fs_text_censor
	$PanelContainer/VBoxContainer/TabContainer/Censor/ScrollContainer/Vbox/HBoxContainer/TextEdit.text = fs_text
	var cd_detections = BetaData.game_data.cd_detections
	$PanelContainer/VBoxContainer/TabContainer/Performance/Vbox/HBoxContainer/HSliderDetectionsCD.value = cd_detections
	var eco_detections = BetaData.game_data.eco_detections
	$PanelContainer/VBoxContainer/TabContainer/Performance/Vbox/CheckBoxEco.button_pressed = eco_detections
	var cd_comments = BetaData.game_data.cd_comments
	$PanelContainer/VBoxContainer/TabContainer/Audio/Vbox/HBoxContainer/HSliderCommentsCD.value = cd_comments
	setup_custom_censor()
	var fps_screen_recorder = BetaData.game_data.fps_screen_recorder
	$PanelContainer/VBoxContainer/TabContainer/Performance/Vbox/HBoxContainer2/HSliderRecorderFPS.value = fps_screen_recorder

func get_check_button(grid_node, censor_cat):
	match censor_cat:
			0: return grid_node.get_node("CheckButtonPorn")
			1: return grid_node.get_node("CheckButtonSexy")
			2: return grid_node.get_node("CheckButtonCute")
			3: return grid_node.get_node("CheckButtonBeta")
			4: return grid_node.get_node("CheckButtonMale")
			5: return grid_node.get_node("CheckButtonFaces")
			
func get_option_button(grid_node, censor_cat):
	match censor_cat:
			0: return grid_node.get_node("OptionButtonPorn")
			1: return grid_node.get_node("OptionButtonSexy")
			2: return grid_node.get_node("OptionButtonCute")
			3: return grid_node.get_node("OptionButtonBeta")
			4: return grid_node.get_node("OptionButtonMale")
			5: return grid_node.get_node("OptionButtonFaces")

func setup_custom_censor():
	var custom_censor = BetaData.game_data.custom_censors
	$PanelContainer/VBoxContainer/TabContainer/Censor/ScrollContainer/Vbox/OptionButton.selected = custom_censor
	var grid_node = get_node("PanelContainer/VBoxContainer/TabContainer/Censor/ScrollContainer/Vbox/GridContainer")
	BetaData.game_data.custom_censor_mask = int(BetaData.game_data.custom_censor_mask)
	for i in range(int(grid_node.get_child_count()/3.)):
		var button: CheckButton = get_check_button(grid_node, i)
		button.set_pressed_no_signal(BetaData.game_data.custom_censor_mask & (1 << i))
		var option: OptionButton = get_option_button(grid_node, i)
		option.select(BetaData.game_data.custom_censor_override[str(i)])
	_on_FileDialog_file_selected(BetaData.game_data.custom_texture)

func _process(_delta):
	var score_percentage = snapped(BetaData.game_data.score / BetaData.get_score_next_lvl() * 100.0, 1)
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/Label2.text = "Next filter progression : " + str(score_percentage) + "%"
	var lvl = BetaData.game_data.lvl
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/Label.text = "Filter level : " + str(lvl)
	const sign2emote = {true: "⚠️", false: "✅"}
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/Label3.text = "Current screen : " + \
		sign2emote[BetaData.current_screen_score_diff > 0].repeat(int(BetaData.game_data.game_mode) + int(min(7, abs(BetaData.current_screen_score_diff)/2))) 
	

func _on_exit_button_pressed():
	# Save config data if needed
	get_tree().quit()


func _on_check_box_toggled(toggled_on):
	# toggle game mode
	BetaData.set_game_mode(toggled_on)

func _on_check_box_2_toggled(toggled_on):
	BetaData.game_data.hud_visible = toggled_on
	BetaData.overlay.overlay_hud.visible = toggled_on and BetaData.game_data.game_mode

func _on_h_slider_value_changed(value):
	var hud_pos = BetaData.overlay.overlay_hud.position
	hud_pos.x = BetaData.overlay.screen_size.x * value
	BetaData.overlay.overlay_hud.position = hud_pos
	BetaData.game_data.hud_x = value

func _on_h_slider_vert_value_changed(value):
	var hud_pos = BetaData.overlay.overlay_hud.position
	hud_pos.y = BetaData.overlay.screen_size.y * value
	BetaData.overlay.overlay_hud.position = hud_pos
	BetaData.game_data.hud_y = value

func _on_h_slider_scale_value_changed(value):
	BetaData.overlay.overlay_hud.scale.x = value
	BetaData.overlay.overlay_hud.scale.y = value
	BetaData.game_data.hud_scale = value



func _on_text_edit_text_changed():
	# fs text censor edit
	var new_text = $PanelContainer/VBoxContainer/TabContainer/Censor/ScrollContainer/Vbox/HBoxContainer/TextEdit.text
	await get_tree().process_frame
	BetaData.game_data.fs_text_censor = new_text
	BetaData.new_fullscreen_text_texture(new_text)


func _on_h_slider_detections_cd_value_changed(value):
	BetaData.game_data.cd_detections = value
	$PanelContainer/VBoxContainer/TabContainer/Performance/Vbox/HBoxContainer/Label2.text = str(snapped(value, 0.05)) + " s"
	# we use a 1 sec timer to avoid mass tcp restart when the user move the slider
	var timer: Timer = $PanelContainer/VBoxContainer/TabContainer/Performance/Vbox/HBoxContainer/HSliderDetectionsCD/Timer
	if timer.time_left == 0:
		timer.start(1)

func _on_timer_cd_duration_timeout():
	BetaData.overlay.tcp_listner.restart_detector(BetaData.game_data.cd_detections)
	BetaData.is_eco_active = false

func _on_check_box_eco_toggled(toggled_on):
	BetaData.game_data.eco_detections = toggled_on


func _on_h_slider_comments_cd_value_changed(value):
	BetaData.game_data.cd_comments = value
	$PanelContainer/VBoxContainer/TabContainer/Audio/Vbox/HBoxContainer/Label2.text = str(value) + " s"
	

func _on_option_button_item_selected(index):
	BetaData.game_data.custom_censors = index + 1
	BetaData.update_censor_settings()

func _on_option_button_porn_item_selected(index):
	BetaData.game_data.custom_censor_override.erase(censor_cateogry_porn)
	BetaData.game_data.custom_censor_override[censor_cateogry_porn] = index
	BetaData.update_censor_settings()
	
func _on_option_button_sexy_item_selected(index):
	BetaData.game_data.custom_censor_override.erase(censor_cateogry_sexy)
	BetaData.game_data.custom_censor_override[censor_cateogry_sexy] = index
	BetaData.update_censor_settings()
	
func _on_option_button_cute_item_selected(index):
	BetaData.game_data.custom_censor_override.erase(censor_cateogry_cute)
	BetaData.game_data.custom_censor_override[censor_cateogry_cute] = index
	BetaData.update_censor_settings()
	
func _on_option_button_faces_item_selected(index):
	BetaData.game_data.custom_censor_override.erase(censor_cateogry_faces)
	BetaData.game_data.custom_censor_override[censor_cateogry_faces] = index
	BetaData.update_censor_settings()
	
func _on_option_button_beta_item_selected(index):
	BetaData.game_data.custom_censor_override.erase(censor_cateogry_beta)
	BetaData.game_data.custom_censor_override[censor_cateogry_beta] = index
	BetaData.update_censor_settings()
	
func _on_option_button_male_item_selected(index):
	BetaData.game_data.custom_censor_override.erase(censor_cateogry_male)
	BetaData.game_data.custom_censor_override[censor_cateogry_male] = index
	BetaData.update_censor_settings()

func _on_check_button_custom_toggled(toggled_on, extra_arg_0):
	var mask = 1 << (extra_arg_0)
	var old_mask = BetaData.game_data.custom_censor_mask
	if toggled_on:
		BetaData.game_data.custom_censor_mask = old_mask | mask
	else:
		BetaData.game_data.custom_censor_mask = old_mask & ~mask
	BetaData.update_censor_settings()


func _on_label_texture_pressed():
	var file_dialog = FileDialog.new()
	file_dialog.exclusive = false
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.use_native_dialog = false
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = ["*.png, *.jpg, *.jpeg"]
	file_dialog.file_selected.connect(_on_FileDialog_file_selected)
	add_child(file_dialog)
	file_dialog.popup_centered(Vector2i(500, 400))
	var old_path = BetaData.game_data.custom_texture
	if old_path != "":
		file_dialog.current_path = old_path

func _on_FileDialog_file_selected(path: String):
	var image = Image.new()
	if image.load(path) != OK:
		return
	BetaData.game_data.custom_texture = path
	BetaData.custom_texture = ImageTexture.create_from_image(image)
	$PanelContainer/VBoxContainer/TabContainer/Censor/ScrollContainer/Vbox/HBoxContainer2/TextureRect.texture = BetaData.custom_texture


func _on_button_restart_pressed():
	BetaData.game_data.lvl = 0
	BetaData.game_data.score = 0
	BetaData.set_game_mode(true)
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/CheckBox.button_pressed = true
	BetaData.overlay.beta_voices.get_node("intro").play()
	await get_tree().create_timer(3.5).timeout
	BetaData.make_screen_glitched()
	


func _on_h_slider_recorder_fps_value_changed(value):
	BetaData.game_data.fps_screen_recorder = value
	$PanelContainer/VBoxContainer/TabContainer/Performance/Vbox/HBoxContainer2/Label2.text = str(value)


func _on_h_slider_xp_mult_value_changed(value):
	BetaData.game_data.xp_multiplier = value
	$PanelContainer/VBoxContainer/TabContainer/Game/Vbox/HBoxContainer4/Label4.text = str(value)
