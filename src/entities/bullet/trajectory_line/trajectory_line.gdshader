shader_type canvas_item;

uniform float dash_length = 16.0; // Length of each dash
uniform float gap_length = 8.0;   // Length of each gap
uniform vec4 dash_color = vec4(1.0, 1.0, 1.0, 1.0); // Dash color

void fragment() {
    // Compute distance from start of the trajectory
    float total_length = dash_length + gap_length;
    float distance = length(FRAGCOORD.xy);

    // Create a dashed effect based on world distance
    if (mod(distance, total_length) < dash_length) {
        COLOR = dash_color;
    } else {
        discard;
    }
}
