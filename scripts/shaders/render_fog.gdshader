shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;
//uniform sampler2D noise1: repeat_enable;
//uniform sampler2D noise2: repeat_enable;
//
//uniform vec2 scroll1 = vec2(0.02, 0.00);
//uniform vec2 scroll2 = vec2(-0.05, 0.02);
//
//varying vec2 world_position;

uniform vec4 fog_color: source_color;

//void vertex()
//{
//    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy / vec2(textureSize(noise1, 0));
//}

void fragment()
{
	vec2 center_offset = SCREEN_UV - vec2(0.5,0.5);
	float centerdist = pow(max(abs(center_offset.x), abs(center_offset.y)) * 1.7, 7.0);

	COLOR = texture(screen_texture, SCREEN_UV) + centerdist * fog_color;// * (texture(noise1, SCREEN_UV + scroll1 * TIME) + texture(noise2, SCREEN_UV + scroll2 * TIME));// + top_light; 
}