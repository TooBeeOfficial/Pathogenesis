shader_type canvas_item;

uniform float amplitude : hint_range(-1, 50.0) = 5.0;
uniform float frequency : hint_range(0.0, 20.0) = 5.0;
uniform float speed : hint_range(0.0, 100.0) = 1.0;
uniform float time_offset : hint_range(0.0, 100.0) = 0.0;

void fragment() {
    // Get UV coordinates (0..1 range)
    vec2 uv = UV;

    // Animate phase over time
    float phase = TIME * speed + time_offset;

    // Apply horizontal offset based on vertical position (creates a horizontal wave)
    uv.x += sin(uv.y * frequency + phase) * (amplitude / TEXTURE_PIXEL_SIZE.x);

    // Sample texture
    COLOR = texture(TEXTURE, uv) * COLOR;
}
