precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Interpolated view vector

// uniform values remain the same across the scene
uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform vec3 lightPos; // Light position in camera space

// HINT: Use the built-in variable gl_FragCoord to get the screen-space coordinates
float Halftone(float lambertian){
    // Create halftone texture
  vec2 pixel = floor(vec2(gl_FragCoord.xy));

  float diameter = 8.0; 
  //Compute distance between pixel and origin of nearest circle
  pixel = mod(pixel, vec2(diameter));
  
  float radius = diameter * 0.5;
  float distance = distance(pixel, vec2(radius)) / radius; 
  
  //Handle small dots
  if (distance >= 0.01) { 
    vec3 diffusion = vec3(diffuseColor * Kd * lambertian);
    distance += diffusion.r + diffusion.g + diffusion.b; // Scale circle size by diffuse color
  }

  return clamp(pow(distance,1.0), 0.0, 1.0); 
}
void main() {
  // Your solution should go here.
  // Only the background color calculations have been provided as an example.
  // gl_FragColor = vec4(diffuseColor * Kd, 1.0);
  
  // Halftone requires a grid of dots coloured by the ambient colour, which are
  // decreased in size by the dot product for the diffuse calculation.
  
  // Light values
   vec3 normal = normalize(normalInterp);
    vec3 lightDir = normalize(lightPos - vertPos);
    vec3 reflectDir = reflect(-lightDir, normal);
    vec3 viewDir = normalize(-vertPos);

    float lambertian = max(dot(lightDir,normal), 0.0);
    float specular = 0.0;

    if(lambertian > 0.0) {
       float specAngle = max(dot(reflectDir, viewDir), 0.0);
       specular = pow(specAngle, shininessVal);
    }

  
  gl_FragColor = vec4((ambientColor * (1.0 - Halftone(lambertian))) + (diffuseColor * Halftone(lambertian)), 1.0);
}

