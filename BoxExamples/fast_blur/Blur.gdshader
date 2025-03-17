shader_type canvas_item;

uniform sampler2D back_screen_texture : repeat_disable, filter_nearest;

// Radius that the shader was designed for.
const float DEFAULT_RADIUS = 10.000000;

// Unit vector: (1, 0) or (0, 1)
uniform vec2 step;
// Desired blur radius.
uniform float radius = 10.000000;

void fragment() {
	vec2 s = radius / DEFAULT_RADIUS * step / vec2(textureSize(back_screen_texture, 0));
	COLOR.rgb =
		0.011194727 * texture(back_screen_texture, UV - 10.000000000 * s).rgb +
		0.039368696 * texture(back_screen_texture, UV - 8.415809477 * s).rgb +
		0.071308558 * texture(back_screen_texture, UV - 6.435363708 * s).rgb +
		0.110237219 * texture(back_screen_texture, UV - 4.455121108 * s).rgb +
		0.145451038 * texture(back_screen_texture, UV - 2.475020813 * s).rgb +
		0.163798995 * texture(back_screen_texture, UV - 0.495000167 * s).rgb +
		0.157439298 * texture(back_screen_texture, UV + 1.485004498 * s).rgb +
		0.129158204 * texture(back_screen_texture, UV + 3.465057055 * s).rgb +
		0.090434685 * texture(back_screen_texture, UV + 5.445220765 * s).rgb +
		0.054043977 * texture(back_screen_texture, UV + 7.425557483 * s).rgb +
		0.027564604 * texture(back_screen_texture, UV + 9.406126897 * s).rgb;
	COLOR.w = pow(texture(TEXTURE, UV).x, 0.6)/2.0;
}
