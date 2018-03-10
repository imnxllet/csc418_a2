// Fragment shader template for the bonus question

precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
// NOTE: You may need to edit this section to add additional variables
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Interpolated view vector

// uniform values remain the same across the scene
// NOTE: You may need to edit this section to add additional variables
uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform vec3 lightPos; // Light position in camera space

uniform sampler2D uSampler; // 2D sampler for the earth texture

float checkDraw(float val, float dist, float dotprod, float upperlimit) {
    // Check whether or not a dark pixel should be drawn based on diffuse and position.
    if (mod(val, dist) == 0.0) {
        if (dotprod <= upperlimit) {
            return 1.0;
        }
    }
    return 0.0;
}

void main() {
 // Your solution should go here.
  // Only the ambient colour calculations have been provided as an example.
  //gl_FragColor = vec4(ambientColor, 1.0);

  float opacity = dot(normalize(normalInterp), normalize(-viewVec));
  opacity = abs(opacity);
  opacity = 1.0 - pow(opacity, 2.0);
  vec4 ambient_color = vec4(ambientColor*opacity, 1.0);

  //diffuse
  vec3 light = normalize(lightPos - vertPos);
  float diffuse_intensity = dot(light, normalInterp) * Kd;
  if (diffuse_intensity < 0.0){
    diffuse_intensity = 0.0;
  }
  vec4 diffuse_color = vec4(diffuseColor * diffuse_intensity * opacity, 1.0);
  
  gl_FragColor = ambient_color + diffuse_color;
}