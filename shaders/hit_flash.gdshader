shader_type canvas_item;

// ควบคุมจาก GDScript ผ่าน material.set_shader_parameter("flash_amount", x)
// 0.0 = ปกติ, 1.0 = ขาวเต็มที่
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR.rgb = mix(tex_color.rgb, vec3(1.0), flash_amount);
	COLOR.a = tex_color.a;
}
