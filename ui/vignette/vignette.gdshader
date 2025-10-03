shader_type canvas_item;
render_mode unshaded;

uniform float progress = 0.0f;

const float strength = 1.3f;
const float strength_inv = 1.0f/strength;

void fragment() {
	float alpha = 0.0f;
	float x_max = (SCREEN_UV.x - strength_inv)*strength;
	float y_max = (SCREEN_UV.y - strength_inv)*strength;
	
	float x_min = (1.0-SCREEN_UV.x - strength_inv)*strength;
	float y_min = (1.0-SCREEN_UV.y - strength_inv)*strength;
	COLOR.a = max(max(x_max, y_max), max(x_min, y_min)) * progress;
}