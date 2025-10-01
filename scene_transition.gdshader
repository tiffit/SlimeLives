shader_type canvas_item;
render_mode unshaded;

uniform float circle_size : hint_range(0.0, 2.00);
uniform float screen_width;
uniform float screen_height;
uniform float player_x = 200;
uniform float player_y = 200;

void fragment() {
	float ratio = screen_width / screen_height;
	float dist = distance(vec2(player_x / screen_width, player_y / screen_height), vec2(mix(player_x / screen_width, UV.x, ratio), UV.y));
	COLOR.a = step(circle_size, dist);
}