shader_type canvas_item;

uniform vec2 r_displacement = vec2(3.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-3.0, 0.0);

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

void fragment()
{
	vec2 center_offset = SCREEN_UV - vec2(0.5,0.5);
	float centerdist = sqrt(center_offset.x * center_offset.x + center_offset.y * center_offset.y);
	
	float r = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*r_displacement * centerdist), 0.0).r;
	float g = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*g_displacement * centerdist), 0.0).g;
	float b = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*b_displacement * centerdist), 0.0).b;
	
	COLOR = vec4(r, g, b, 1.0);
}