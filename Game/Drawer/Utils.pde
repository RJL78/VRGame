class Utils {

  float clamp(float nb, float bot, float top) {
    if (bot > nb) {return bot;}
    if (top < nb) {return top;}
    else {return nb;}
  }

  float clampAngle(float nb) {
    return clamp(nb, - PI/3, PI/3);
  }
  
}}