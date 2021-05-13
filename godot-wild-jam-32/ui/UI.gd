extends CanvasLayer

signal upgrade_fishing_rod_length
signal upgrade_fishing_rod_weight
signal update_sail_color(new_color)
signal update_flag_color(new_color)
signal pause
signal update_music_volume(new_value)
signal update_sfx_volume(new_value)
signal menu_click
signal start_game

var depth_label: Label
var money_label: Label

var menu: PopupPanel
var menu_titles: Array
var menu_content: Array
var fish_content: GridContainer
var equipment_content: Panel
var color_panel: Panel

onready var length_upgrade_button: TextureButton = $MarginContainer/VBoxContainer/Menu/VBoxContainer/EquipmentContent/MarginContainer/VBoxContainer/LengthContainer/UpgradeButton
onready var weight_upgrade_button: TextureButton = $MarginContainer/VBoxContainer/Menu/VBoxContainer/EquipmentContent/MarginContainer/VBoxContainer/WeightContainer/UpgradeButton2
onready var price_message: Label = $MarginContainer/VBoxContainer/PriceMessage
onready var price_message_timer: Timer = $MarginContainer/VBoxContainer/PriceMessageTimer

onready var music_label: Label = $MarginContainer/VBoxContainer/Menu/VBoxContainer/OptionsPanel/MarginContainer/VBoxContainer/MusicContainer/HBoxContainer/MusicLabel
onready var sfx_label: Label = $MarginContainer/VBoxContainer/Menu/VBoxContainer/OptionsPanel/MarginContainer/VBoxContainer/SFXContainer/HBoxContainer/SFXLabel

onready var boost_timer_label: Label = $MarginContainer/VBoxContainer/BoostTimerLabel
onready var boost_progress_bar: ProgressBar = $MarginContainer/VBoxContainer/BoostProgressBar
onready var boost_progress_tween: Tween = $MarginContainer/VBoxContainer/BoostProgressTween

onready var splash_screen: VBoxContainer = $MarginContainer/VBoxContainer/SplashScreen
onready var how_to_screen: VBoxContainer = $MarginContainer/VBoxContainer/HowToPlay
onready var win_screen: Label = $MarginContainer/VBoxContainer/WinScreen
onready var previous_button: TextureButton = $MarginContainer/VBoxContainer/HowToPlay/Buttons/PreviousButton
onready var next_button: TextureButton = $MarginContainer/VBoxContainer/HowToPlay/Buttons/NextButton
onready var game_ui: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer

var is_game_running: bool = true
var how_to_screen_page: int = 1

var new_color: Color
var change_sail_color: bool = false
var change_flag_color: bool = false

func _ready():
	get_nodes()

func get_nodes() -> void:
	depth_label = get_node("MarginContainer/VBoxContainer/HBoxContainer/DepthLabel")
	money_label = get_node("MarginContainer/VBoxContainer/HBoxContainer/MoneyLabel")
	
	menu = get_node("MarginContainer/VBoxContainer/Menu")
	menu_titles = get_node("MarginContainer/VBoxContainer/Menu/VBoxContainer/MenuTitles").get_children()
	# fish menu content
	fish_content = get_node("MarginContainer/VBoxContainer/Menu/VBoxContainer/FishGrid")
	equipment_content = get_node("MarginContainer/VBoxContainer/Menu/VBoxContainer/EquipmentContent")
	var options_content = get_node("MarginContainer/VBoxContainer/Menu/VBoxContainer/OptionsPanel")
	color_panel = get_node("MarginContainer/VBoxContainer/Menu/VBoxContainer/ColorPanel")
	menu_content = [fish_content, equipment_content, options_content, color_panel]

### Menu
func _on_MenuButton_pressed():
	emit_signal("pause")
	emit_signal("menu_click")
	load_fish_menu()
	menu.popup_centered()
	boost_progress_bar.hide()
	boost_timer_label.hide()

func _on_Menu_popup_hide():
	emit_signal("menu_click")
	get_tree().paused = false
	boost_progress_bar.show()
	boost_timer_label.show()

func _on_Fish_pressed():
	emit_signal("menu_click")
	load_fish_menu()

func _on_Equipment_pressed():
	emit_signal("menu_click")
	load_equipment_menu()

func _on_Options_pressed():
	emit_signal("menu_click")
	load_options_menu()

func _on_ReturnButton_pressed():
	emit_signal("menu_click")
	menu.hide()
	boost_progress_bar.show()
	boost_timer_label.show()

func load_fish_menu():
	load_menu(1)

func load_equipment_menu() -> void:
	load_menu(2)

func load_options_menu() -> void:
	load_menu(3)

func load_menu(index: int) -> void:
	# check index
	var index_out_of_bounds = (index < 1) or (index > 4)
	if index_out_of_bounds:
		push_error("index out of bounds")
		return
	
	# load the desired menu and disable the others
	for i in 4:
		if i == index - 1:
			menu_titles[i].disabled = true
			menu_content[i].show()
		else:
			menu_titles[i].disabled = false
			menu_content[i].hide()

func reveal_fish(fish_number: int) -> void:	
	# check fish_number
	var index_out_of_bounds = (fish_number < 0) or (fish_number >= fish_content.get_child_count()) or (fish_number == 6)
	if index_out_of_bounds:
		push_error("index out of bounds")
		return
	
	# reveal the fish cell
	var cell: VBoxContainer = fish_content.get_child(fish_number)
	cell.get_node("Control").get_node("?").hide()
	cell.get_node("Control").get_node("Picture").show()
	cell.get_node("Name").show()

func update_depth_label(depth: int) -> void:
	check_strictly_positive_value(depth)
	depth_label.text = str(depth) + " m"

func update_money_label(money: int) -> void:
	check_positive_value(money)
	money_label.text = "$" + str(money)

func update_fishing_rod_length(length: int) -> void:
	check_strictly_positive_value(length)
	var length_label: Label = equipment_content.get_node("MarginContainer/VBoxContainer/LengthContainer/LengthLabel")
	length_label.text = str(length) + " m"

func update_fishing_rod_weight(weight: float) -> void:
	check_positive_value(int(weight))
	var weight_label: Label = equipment_content.get_node("MarginContainer/VBoxContainer/WeightContainer/WeightLabel")
	weight_label.text = str(weight) + " kg"

func update_fishing_rod_upgrade_length(price: int, money: int) -> void:
	check_strictly_positive_value(price)
	var length_upgrade_label = equipment_content.get_node("MarginContainer/VBoxContainer/LengthContainer/UpgradeLabel")
	length_upgrade_label.text = "$ " + str(price)
	if money < price:
		length_upgrade_button.disabled = true
	else:
		length_upgrade_button.disabled = false

func update_fishing_rod_upgrade_weight(price: int, money: int) -> void:
	check_strictly_positive_value(price)
	var weight_upgrade_label = equipment_content.get_node("MarginContainer/VBoxContainer/WeightContainer/UpgradeLabel2")
	weight_upgrade_label.text = "$ " + str(price)
	if money < price:
		weight_upgrade_button.disabled = true
	else:
		weight_upgrade_button.disabled = false

func check_positive_value(value: int) -> void:
	if value < 0:
		push_error("value cannot be negative")
		return 

func check_strictly_positive_value(value: int) -> void:
	if value <= 0:
		push_error("value cannot be negative or equal to zero")
		return 

func _on_UpgradeButton_pressed():
	emit_signal("upgrade_fishing_rod_length")

func _on_UpgradeButton2_pressed():
	emit_signal("upgrade_fishing_rod_weight")

func _on_ColorButton_pressed():
	change_sail_color = true
	emit_signal("menu_click")
	load_menu(4)

func _on_ColorButton2_pressed():
	change_flag_color = true
	emit_signal("menu_click")
	load_menu(4)

func _on_ColorPicker_color_changed(color):
	new_color = color

func _on_OkButton_pressed():
	emit_signal("menu_click")
	if change_sail_color:
		var sail_color_rect: ColorRect = equipment_content.get_node("MarginContainer/VBoxContainer/SailContainer/HBoxContainer/SailColor")
		sail_color_rect.color = new_color
		emit_signal("update_sail_color", new_color)
		change_sail_color = false
	
	if change_flag_color:
		var flag_color_rect: ColorRect = equipment_content.get_node("MarginContainer/VBoxContainer/FlagContainer/HBoxContainer/FlagColor")
		flag_color_rect.color = new_color
		emit_signal("update_flag_color", new_color)
		change_flag_color = false
	
	load_menu(2)

func _on_CancelButton_pressed():
	emit_signal("menu_click")
	load_menu(2)

func display_reward_message(reward: int) -> void:
	price_message.text = "+ $" + str(reward)
	price_message.modulate = "#0eff00"
	price_message.show()
	price_message_timer.start()

func display_cost_message(cost: int) -> void:
	price_message.text = "- $" + str(cost)
	price_message.modulate = "#ff0000"
	price_message.show()
	price_message_timer.start()

func _on_PriceMessageTimer_timeout():
	price_message.hide()

func update_music_label(value: int) -> void:
	music_label.text = str(value)

func _on_MusicSlider_value_changed(value):
	emit_signal("update_music_volume", value)
	update_music_label(value)

func update_sfx_label(value: int) -> void:
	sfx_label.text = str(value)

func _on_SFXSlider_value_changed(value):
	emit_signal("update_sfx_volume", value)
	update_sfx_label(value)

func update_boost_timer_progress_bar(time_left: float) -> void:
	boost_progress_bar.value = time_left
	if time_left > 0.5:
		var _res = boost_progress_tween.interpolate_method(boost_progress_bar.get("custom_styles/fg"), "set_bg_color", Color("68e744"), Color("ff4444"), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		boost_timer_label.text = "PRESS SPACE TO GET A BOOST"
	else:
		var _res = boost_progress_tween.interpolate_method(boost_progress_bar.get("custom_styles/fg"), "set_bg_color", Color("ff4444"), Color("68e744"), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		boost_timer_label.text = "RELEASE SPACE TO RELOAD THE BOOST"
	var _res = boost_progress_tween.start()

func _on_BoostProgressTween_tween_step(_object, _key, _elapsed, _value):
	boost_progress_bar.update()

func _on_PlayButton_pressed():
	emit_signal("start_game")
	emit_signal("menu_click")
	splash_screen.hide()
	how_to_screen.hide()
	game_ui.show()
	boost_progress_bar.show()
	boost_timer_label.show()

func _on_HowToButton_pressed():
	emit_signal("menu_click")
	splash_screen.hide()
	how_to_screen.show()

func _on_CloseButton_pressed():
	emit_signal("pause")
	emit_signal("menu_click")
	splash_screen.show()
	game_ui.hide()
	boost_progress_bar.hide()
	boost_timer_label.hide()

func _on_CloseHowToButton_pressed():
	emit_signal("menu_click")
	how_to_screen.hide()
	splash_screen.show()

func display_win_screen():
	win_screen.show()
	game_ui.hide()
	boost_progress_bar.hide()
	boost_timer_label.hide()

func _process(_delta):
	update_how_to_screen_page()

# from 1 to 5 pages
func _on_PreviousButton_pressed():
	emit_signal("menu_click")
	if how_to_screen_page > 1:
		how_to_screen_page -= 1

func _on_NextButton_pressed():
	emit_signal("menu_click")
	if how_to_screen_page < 5:
		how_to_screen_page += 1

func update_how_to_screen_page() -> void:
	var pages: Array = [
		how_to_screen.get_node("MarginContainer/Story"),
		how_to_screen.get_node("MarginContainer/Catch"),
		how_to_screen.get_node("MarginContainer/FishMenu"),
		how_to_screen.get_node("MarginContainer/Upgrade"),
		how_to_screen.get_node("MarginContainer/Customize")
	]
	
	for i in range(len(pages)):
		if i == how_to_screen_page - 1:
			pages[i].show()
		else:
			pages[i].hide()
	
	if how_to_screen_page > 1:
		previous_button.disabled = false
	else:
		previous_button.disabled = true
	
	if how_to_screen_page < 5:
		next_button.disabled = false
	else:
		next_button.disabled = true
