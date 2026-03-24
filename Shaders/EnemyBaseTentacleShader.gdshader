shader_type canvas_item;

uniform float time;
uniform float wave_amplitude = 8.0;
uniform float wave_frequency = 12.0;
uniform float wave_speed = 4.0;
uniform float direction = 1.0; // 1.0 = horizontal waves, 0.0 = vertical

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;

    if (direction == 1.0) {
        uv.y += sin(uv.x * wave_frequency + time * wave_speed) * wave_amplitude / 100.0;
    } else {
        uv.x += sin(uv.y * wave_frequency + time * wave_speed) * wave_amplitude / 100.0;
    }

    COLOR = texture(TEXTURE, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
