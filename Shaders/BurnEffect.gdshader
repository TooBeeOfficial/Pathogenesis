shader_type canvas_item;

uniform float burn_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 burn_color : source_color = vec4(1.0, 0.4, 0.0, 1.0);
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.01;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 result = tex;

	if (tex.a >= alpha_threshold) {
		// Apply burn tint only to visible pixels, keep original alpha
		vec3 burned_rgb = mix(tex.rgb, burn_color.rgb, burn_amount);
		result = vec4(burned_rgb, tex.a);
	}

	COLOR = result;
}
