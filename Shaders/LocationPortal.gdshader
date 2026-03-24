shader_type canvas_item;

uniform float time;
uniform float speed = 1.0;
uniform float strength = 1.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform float wave_frequency = 12.0;
uniform float wave_amplitude = 0.03;
uniform float wave_speed = 4.0;
uniform float rotation_speed = 1.5;

void fragment() {
    vec2 uv = UV;

    // Direction from center
    vec2 dir = uv - center;
    float dist = length(dir);

    // Get angle of current pixel relative to center
    float angle = atan(dir.y, dir.x);

    // Add rotation
    angle += time * rotation_speed;

    // Tentacle wave distortion: sine wave along radial angle
    float wave = sin(angle * wave_frequency + time * wave_speed) * wave_amplitude;

    // Apply distortion outward from center
    vec2 distorted = center + normalize(dir) * (dist + wave);

    vec4 tex_color = texture(TEXTURE, distorted);
    COLOR = tex_color * COLOR;
}