shader_type canvas_item;
uniform float wave_strength : hint_range(0.0, 100.0) = 10.0;
uniform float wave_frequency : hint_range(0.0, 10.0) = 2.0;
uniform float wave_speed : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    // Time-based offset for animation
    float wave = sin(UV.x * wave_frequency * 10.0 + TIME * wave_speed) 
               + cos(UV.y * wave_frequency * 10.0 + TIME * wave_speed);

    // Modify UVs to distort texture like water
    vec2 uv_distorted = UV + vec2(0.0, wave * 0.005 * wave_strength);

    COLOR = texture(TEXTURE, uv_distorted);
}
