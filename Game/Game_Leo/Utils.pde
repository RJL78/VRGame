class Utils{

  float clamp(float nb, float bot, float top){
    if(bot > nb) return bot;
    if(top < nb) return top;
    else return nb;
  }
  
  float clampAngle(float nb){
    return clamp(nb, - PI/3, PI/3);
  }
  
  /*PVector pop(PVector vector){
  PVector result = new PVector();
    
    return result;
  }*/
  
  /*public static void updatePhysics(PVector location, PVector velocity, float w, float h){
    location.add(velocity);
if ((location.x > w) || (location.x < 0)) {
velocity.x = velocity.x * -1;
}
if ((location.y > h) || (location.y < 0)) {
velocity.y = velocity.y * -1;
}
 }*/
 

}