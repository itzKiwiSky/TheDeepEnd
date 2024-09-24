extern number amplitude;
extern number waviness;
extern number offset;
vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 scoord)
{
    vec2 coordinates;
    coordinates = vec2(texcoord.x , ((1 - 2  amplitude)*texcoord.y+amplitude) * 1 + (amplitude * sin(texcoord.x * waviness + offset)));
    return color * Texel(tex, coordinates);
}