shader_type spatial;
render_mode depth_draw_alpha_prepass, cull_disabled, specular_schlick_ggx, skip_vertex_transform;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform float sway_freq = 1.0;
uniform float sway_amp = 0.05;
uniform float sway_phase_len = 8.0;
uniform vec4 transmission : hint_color;

void vertex() {
	vec3 local_vert = VERTEX;
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
    VERTEX.x += sin(VERTEX.x * sway_phase_len * 1.123 + TIME * sway_freq) * sway_amp * local_vert.y	;
    VERTEX.y += sin(VERTEX.y * sway_phase_len + TIME * sway_freq * 1.12412) * sway_amp * local_vert.y;
    VERTEX.z += sin(VERTEX.z * sway_phase_len * 0.9123 + TIME * sway_freq * 1.3123) * sway_amp * local_vert.y;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	ALPHA = albedo_tex.a;
	TRANSMISSION = transmission.rgb;
}
