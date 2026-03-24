shader_type canvas_item;

uniform float charge_progress : hint_range(0.0, 1.0) = 0.0;
uniform float min_scale : hint_range(0.1, 2.0) = 0.4;
uniform float max_scale : hint_range(0.1, 2.0) = 1.5;
uniform float ripple_strength : hint_range(0.0, 1.0) = 0.05;
uniform float ripple_frequency : hint_range(0.0, 50.0) = 30.0;
uniform float ripple_speed : hint_range(0.0, 10.0) = 2.0;
uniform float time : hint_range(0.0, 1000.0) = 0.0;

void fragment() {
	vec2 center_uv = vec2(0.5);
	vec2 offset = UV - center_uv;
	float dist = length(offset);

	// Animate ripple based on time
	float ripple_wave = sin(dist * ripple_frequency - time * ripple_speed) * ripple_strength * (1.0 - dist);
	offset += normalize(offset) * ripple_wave;

	// Shrink then burst
	float scale = (charge_progress < 0.99)
		? mix(1.0, min_scale, charge_progress / 0.99)
		: max_scale;

	vec2 scaled_uv = offset / scale + center_uv;
	vec4 tex = texture(TEXTURE, scaled_uv);
	COLOR = tex;
}
