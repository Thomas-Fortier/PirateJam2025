extends Control

@export var _name: String = "Sound"
@export var _sound_type: Sound.SoundType = Sound.SoundType.MUSIC

@onready var _slider: HSlider = %Slider
@onready var _name_label: Label = %NameLabel
@onready var _slider_value_label: Label = %SliderValueLabel

var _slider_value: float:
	set(value):
		var display_value: float = value
		var actual_value: float = value / 100
		
		_slider_value = display_value
		_slider_value_label.text = str(display_value)
		
		_set_settings_manager_sound(actual_value)

func _ready():
	_name_label.text = _name
	_slider_value = _get_settings_manager_sound() * 100
	_slider.set_value_no_signal(_slider_value)

func _set_settings_manager_sound(value: float) -> void:
	match _sound_type:
		Sound.SoundType.MUSIC:
			SettingsManager.music_volume = value
		Sound.SoundType.SFX:
			SettingsManager.sfx_volume = value
		_:
			SettingsManager.master_volume = value

func _get_settings_manager_sound() -> float:
	match _sound_type:
		Sound.SoundType.MUSIC:
			return SettingsManager.music_volume
		Sound.SoundType.SFX:
			return SettingsManager.sfx_volume
		_:
			return SettingsManager.master_volume

func _on_slider_value_changed(value: float) -> void:
	_slider_value = value
