attribute vec3 position; // Given vertex position in object space
attribute vec3 normal; // Given vertex normal in object space
attribute vec3 worldPosition; // Given vertex position in world space

uniform mat4 projection, modelview, normalMat; // Given scene transformation matrices
uniform vec3 eyePos;	// Given position of the camera/eye/viewer

// These will be given to the fragment shader and interpolated automatically
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Vector from the eye to the vertex
varying vec4 color;

uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform vec3 lightPos; // Light position in camera space


void main(){
  // Your solution should go here.
  // Only the ambient colour calculations have been provided as an example.

    
  vec4 vertPos4 = modelview * vec4(position, 1.0);
   vertPos = vec3(vertPos4) / vertPos4.w; 
  //find N, L, lambertian, 
  normalInterp = vec3(normalMat * vec4(normal, 0.0));
  vec3 N = normalize(normalInterp);
  vec3 L = normalize(lightPos - vertPos);
  
  vec4 view = normalize(vec4(vec4(eyePos, 1.0) - vertPos4));
  //use lambertian, shininess to find specular intensity
  
  
  float lambertian = max(dot(L, N), 0.0);
  
  //vec4 light_refl = normalize(-reflect(L, N));
  vec4 b = normalize(-vertPos4);
  float specular = 0.0;
  if(lambertian > 0.0) {
    vec3 R = reflect(-L, N);      // Reflected light vector
    vec3 V = normalize(-vertPos); // Vector to viewer
    // Compute the specular term
    float specAngle = max(dot(R, V), 0.0);
    specular = pow(specAngle, shininessVal);
  }
 // float specular = pow(max(dot(light_refl, b), 0.0), shininessVal);
//L(bi, ni, si) = (ra + Ia) + rdId(max(0, ni.si)) + rsIs(max(0,ri.bi)^a)
//r=reflection, s = incident light, b=camera, i intensity
  
  //color = vec4(Ka * ambientColor + Kd * lambertian * diffuseColor, 1.0); 
  color = vec4(Ka * ambientColor + Kd * lambertian * diffuseColor + Ks * specular * specularColor, 1.0); 
  gl_Position = projection * vertPos4;
  
  
  
  
 
}