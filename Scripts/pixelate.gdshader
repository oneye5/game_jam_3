shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

// Controls the pixel block size
uniform float pixel_size : hint_range(1.0, 256.0) = 10.0;

void fragment() {
    // Get the size of the screen texture
    vec2 screen_size = vec2(textureSize(SCREEN_TEXTURE, 0));
    
    // Calculate pixel coordinates without distorting aspect ratio
    vec2 pixel_uv = (floor(SCREEN_UV * screen_size / pixel_size) + 0.5) * (pixel_size / screen_size);
    
    // Sample the texture at the pixelated coordinates
    vec4 pixel_color = texture(SCREEN_TEXTURE, pixel_uv);
    
    // Output the pixelated color
    COLOR = pixel_color;
}