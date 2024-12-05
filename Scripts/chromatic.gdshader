shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 r_displacement = vec2(3.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-3.0, 0.0);
uniform float intensity : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    // Sample each color channel with different pixel offsets
    float r = texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * r_displacement * intensity).r;
    float g = texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * g_displacement * intensity).g;
    float b = texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * b_displacement * intensity).b;

    // Combine the color channels
    COLOR = vec4(r, g, b, 1.0);
}