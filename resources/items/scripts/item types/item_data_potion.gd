extends ItemData
class_name ItemDataPotion

@export var effect_type: String = ""   # "heal", "speed", "oxygen", "invincible", etc.
@export var effect_value: float = 0.0  # e.g., 20 HP, 1.5x speed, 50 oxygen
@export var effect_duration: float = 0.0  # 0 = instant, >0 = buff duration in seconds
