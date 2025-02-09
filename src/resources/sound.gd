class_name Sound
extends Resource

## Represents a sound with configurable properties.

## Represents the sound type.
enum SoundType {
	SFX,
	MUSIC,
	MASTER,
}

## Represents the spacial type that the sound is. (e.g. 2d, 3d or none)
enum SpatialType {
	NONE,
	SPATIAL_2D,
	SPATIAL_3D
}

@export_category("Sound Settings")
## The audio stream to play.
@export var stream: AudioStream
## The type of sound. (e.g. music, sfx)
@export var sound_type: SoundType
## The volume.
@export var volume: float = 1.0
## If the audio stream should loop at the end.
@export var looping: bool = false
## The pitch scale. (Adjusts speed as a side effect)
@export var pitch_scale: float = 1.0
@export_category("Spatial Settings")
## The spatial type.
@export var spatial_type: SpatialType
## Controls how quickly sound fades with distance
@export var attenuation: float = 1.0
## Max distance before sound fades out completely.
@export var max_distance: float = 1000.0

## The bus that the stream belongs to.
var bus: String:
	get:
		return _get_bus_from_sound_type(self.sound_type)

## Determines the audio bus based on the sound type.
##
## @param current_sound_type The type of sound (SFX or MUSIC).
## @return The corresponding bus name.
func _get_bus_from_sound_type(current_sound_type: SoundType) -> String:
	match current_sound_type:
		SoundType.MUSIC:
			return "Music"
		SoundType.SFX:
			return "SFX"
		_:
			return "Master"
