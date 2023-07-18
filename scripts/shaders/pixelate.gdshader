shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform int pixelSize: hint_range(1, 16, 1) = 4;
 
void fragment()
{
    vec2 iRes = 1.0 / SCREEN_PIXEL_SIZE;
    
    float onePixelSizeX = 1.0 / iRes.x;
    float onePixelSizeY = 1.0 / iRes.y;
    
    float cellSizeX =  float(pixelSize) * onePixelSizeX;
    float cellSizeY = float(pixelSize) * onePixelSizeY; 
    
    float x = cellSizeX * round(SCREEN_UV.x / cellSizeX);
    float y = cellSizeY * round(SCREEN_UV.y / cellSizeY);
    
    COLOR = texture(screen_texture, vec2(x, y));
}