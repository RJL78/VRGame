import processing.sound.*;

SoundFile sound_banana;
SoundFile sound_giggles;

int soundInc = 100;
int timePause = 0;
char banana = 'b';
char giggle = 'g';

void decrementSound(){
  if(timePause > 0){
    timePause --;
  }
}

void incrementSound(int i){
  if(timePause < 1500){
    timePause += i*soundInc;
  }
}

void playSound(char s){
  switch (s){
    case 'b' : if(timePause == 0){
       sound_banana.play();
       incrementSound(5);
    } break;
    case 'g' : if(timePause <= 200){
      sound_giggles.play();
      incrementSound(3);
    } break;
    
    default : break;
  }
}