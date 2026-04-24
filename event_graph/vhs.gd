@tool
extends Control

## 蟷ｳ謌仙・譛溘・繝・Ξ繝・VHS諢溘ｒ蜀咲樟縺吶ｋ鬮伜ｺｦ縺ｪ繧ｨ繝輔ぉ繧ｯ繝亥宛蠕｡繧ｹ繧ｯ繝ｪ繝励ヨ
## 讒区・: Control (縺薙・繧ｹ繧ｯ繝ｪ繝励ヨ) > CanvasLayer > ColorRect (ShaderMaterial)

# --- CRT & Lens ---
@export_group("CRT & Lens")
@export_range(0.0, 0.5) var barrel_distortion: float = 0.05:
	set(v): barrel_distortion = v; _update_shader("barrel_distortion", v)
@export_range(0.0, 1.0) var vignette_intensity: float = 0.4:
	set(v): vignette_intensity = v; _update_shader("vignette_intensity", v)
@export_range(0.0, 1.0) var vignette_opacity: float = 0.5:
	set(v): vignette_opacity = v; _update_shader("vignette_opacity", v)

# --- Signal & Color ---
@export_group("Signal & Color")
@export_range(0.0, 5.0) var color_bleeding: float = 1.2:
	set(v): color_bleeding = v; _update_shader("color_bleeding", v)
@export_range(0.0, 0.1) var aberration_amount: float = 0.005:
	set(v): aberration_amount = v; _update_shader("aberration_amount", v)
@export_range(0.0, 2.0) var saturation: float = 1.1:
	set(v): saturation = v; _update_shader("saturation", v)
@export_range(0.0, 2.0) var contrast: float = 1.1:
	set(v): contrast = v; _update_shader("contrast", v)
@export_range(0.0, 2.0) var brightness: float = 1.05:
	set(v): brightness = v; _update_shader("brightness", v)
@export var color_tint: Color = Color(1.0, 0.98, 0.95):
	set(v): color_tint = v; _update_shader("color_tint", v)

# --- Scanlines & Interlacing ---
@export_group("Scanlines & Interlacing")
@export_range(1.0, 1080.0) var scanline_count: float = 480.0:
	set(v): scanline_count = v; _update_shader("scanline_count", v)
@export_range(0.0, 1.0) var scanline_opacity: float = 0.15:
	set(v): scanline_opacity = v; _update_shader("scanline_opacity", v)
@export_range(0.0, 1.0) var interlacing_opacity: float = 0.2:
	set(v): interlacing_opacity = v; _update_shader("interlacing_opacity", v)

# --- Noise & Jitter ---
@export_group("Noise & Jitter")
@export_range(0.0, 1.0) var static_noise_intensity: float = 0.03:
	set(v): static_noise_intensity = v; _update_shader("static_noise_intensity", v)
@export_range(0.0, 1.0) var grain_intensity: float = 0.02:
	set(v): grain_intensity = v; _update_shader("grain_intensity", v)
@export_range(0.0, 0.1) var tracking_jitter: float = 0.01:
	set(v): tracking_jitter = v; _update_shader("tracking_jitter", v)
@export_range(0.0, 1.0) var tape_crease_intensity: float = 0.05:
	set(v): tape_crease_intensity = v; _update_shader("tape_crease_intensity", v)
@export_range(0.0, 1.0) var head_switching_noise: float = 0.5:
	set(v): head_switching_noise = v; _update_shader("head_switching_noise", v)

# --- CRT Mask ---
@export_group("CRT Mask")
@export_range(0.0, 1.0) var mask_intensity: float = 0.15:
	set(v): mask_intensity = v; _update_shader("mask_intensity", v)
@export_range(1.0, 10.0) var mask_size: float = 2.0:
	set(v): mask_size = v; _update_shader("mask_size", v)


func _ready() -> void:
	_update_all_parameters()


func _update_all_parameters() -> void:
	_update_shader("barrel_distortion", barrel_distortion)
	_update_shader("vignette_intensity", vignette_intensity)
	_update_shader("vignette_opacity", vignette_opacity)
	_update_shader("color_bleeding", color_bleeding)
	_update_shader("aberration_amount", aberration_amount)
	_update_shader("saturation", saturation)
	_update_shader("contrast", contrast)
	_update_shader("brightness", brightness)
	_update_shader("color_tint", color_tint)
	_update_shader("scanline_count", scanline_count)
	_update_shader("scanline_opacity", scanline_opacity)
	_update_shader("interlacing_opacity", interlacing_opacity)
	_update_shader("static_noise_intensity", static_noise_intensity)
	_update_shader("grain_intensity", grain_intensity)
	_update_shader("tracking_jitter", tracking_jitter)
	_update_shader("tape_crease_intensity", tape_crease_intensity)
	_update_shader("head_switching_noise", head_switching_noise)
	_update_shader("mask_intensity", mask_intensity)
	_update_shader("mask_size", mask_size)


func _update_shader(param_name: String, value: Variant) -> void:
	var color_rect = _find_color_rect(self)
	if color_rect and color_rect.material is ShaderMaterial:
		color_rect.material.set_shader_parameter(param_name, value)


func _find_color_rect(node: Node) -> ColorRect:
	if node is ColorRect and node.material is ShaderMaterial:
		return node
	for child in node.get_children():
		var found = _find_color_rect(child)
		if found: return found
	return null
