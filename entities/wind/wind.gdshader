shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform vec2 size = vec2(100, 100);

void fragment() {
	vec2 scaledUv = UV * (size/length(size));
	vec2 noiseUv = scaledUv/5.- vec2(TIME/5., 0);
	float noiseColor = 0.8 - min(0.8, texture(noise, noiseUv).r);
	float alpha = noiseColor - pow(max(UV.x, 1.-UV.x), 8)- pow(max(UV.y, 1.-UV.y), 8);
	COLOR.a = alpha;
}
