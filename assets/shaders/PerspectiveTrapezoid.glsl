extern number depth;
vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 scoord)
{
    vec2 coordinates;
    coordinates = vec2((texcoord.x + (texcoord.y * depth / 2)) / (1 + texcoord.y * depth), (texcoord.y + (texcoord.y * depth)) / (1 + texcoord.y * depth));
    return color * Texel(tex, coordinates);
}