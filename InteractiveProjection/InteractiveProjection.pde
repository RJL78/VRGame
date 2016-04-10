void settings() {
  size(1000, 1000);
}
void setup() {
}
float value = 50;
float angleX = 0;
float angleY = 0;

void draw() {
  
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, value, value, value);
  
  //rotated around x
  float[][] transform1 = rotateXMatrix(angleX);
  float[][] transform11 = rotateYMatrix(angleY);
  input3DBox = transformBox(transformBox(input3DBox,transform11), transform1);

  
  //rotated and translated
  float[][] transform2 = translationMatrix(210, 210, 0);
  input3DBox = transformBox(input3DBox, transform2);
  
  //rotated, translated, and scaled
  float[][] transform3 = scaleMatrix(2, 2, 2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();
  
}

void mouseDragged() 
{  if ((pmouseY-mouseY)>0) {
    value +=5;  
} if ((pmouseY-mouseY)<0) {
    value+=-5;
}
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angleX += 0.1;
    } else if (keyCode == DOWN) {
      angleX -= 0.1;
    } else if (keyCode == LEFT) {
      angleY -= 0.1;
    } else if (keyCode == RIGHT) {
      angleY += 0.1;
    } 
  }
}

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    // Complete the code! use only line(x1, y1, x2, y2) built-in function.
    strokeWeight(2);
    for (int i=0; i<4; i++) {
      stroke(0, 0, 255);
      line(s[2*i].x, s[2*i].y, s[2*i+1].x, s[2*i+1].y);
      stroke(255, 0, 0);
      line(s[i].x, s[i].y, s[i+4].x, s[i+4].y);
    }
    stroke(0, 255, 0);
    for (int i=0; i<2; i++) {
      line(s[4*i].x, s[4*i].y, s[4*i+3].x, s[4*i+3].y);
      line(s[4*i+1].x, s[4*i+1].y, s[4*i+2].x, s[4*i+2].y);
    }
  }
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{new My3DPoint(x, y+dimY, z+dimZ), 
      new My3DPoint(x, y, z+dimZ), 
      new My3DPoint(x+dimX, y, z+dimZ), 
      new My3DPoint(x+dimX, y+dimY, z+dimZ), 
      new My3DPoint(x, y+dimY, z), 
      origin, 
      new My3DPoint(x+dimX, y, z), 
      new My3DPoint(x+dimX, y+dimY, z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float [][] T = { {1, 0, 0, -eye.x}, 
    {0, 1, 0, -eye.y}, 
    {0, 0, 1, -eye.z}, 
    {0, 0, 0, 1} }; 
  float [][] P = { {1, 0, 0, 0}, 
    {0, 1, 0, 0}, 
    {0, 0, 1, 0}, 
    {0, 0, -1/eye.z, 0} }; 
  float [] pvector = {p.x, p.y, p.z, 1}; 
  float[] resultVec = matrixProduct(P, matrixProduct(T, pvector) );
  return new My2DPoint(resultVec[0]/resultVec[3], resultVec[1]/resultVec[3]);
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] boxPoints = new My2DPoint[8];
  for (int i=0; i<8; i++) {
    boxPoints[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(boxPoints);
}



float [] matrixProduct( float [][] matrix1, float [] matrix2 ) {
  float [] result = new float [4]; 
  for (int i=0; i<4; i++) {
    result[i]=0; 
    for (int j=0; j<4; j++) {
      result[i] = result[i] + matrix1[i][j]*matrix2[j];
    }
  }
  return result;
}

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z, 1};
  return result;
}

float[][] rotateXMatrix(float angle) {
  return(new float[][] {{1, 0, 0, 0}, 
    {0, cos(angle), sin(angle), 0}, 
    {0, -sin(angle), cos(angle), 0}, 
    {0, 0, 0, 1}});
}
float[][] rotateYMatrix(float angle) {
  return(new float[][] {{cos(angle), 0, -sin(angle), 0}, 
    {0, 1, 0, 0}, 
    {sin(angle), 0, cos(angle), 0}, 
    {0, 0, 0, 1}});
}
float[][] rotateZMatrix(float angle) {
  return(new float[][] {{cos(angle), sin(angle), 0, 0}, 
    {-sin(angle), cos(angle), 0, 0}, 
    {0, 0, 1, 0}, 
    {0, 0, 0, 1}});
}
float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {{x, 0, 0, 0}, 
    {0, y, 0, 0}, 
    {0, 0, z, 0}, 
    {0, 0, 0, 1}});
}
float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1, 0, 0, x}, 
    {0, 1, 0, y}, 
    {0, 0, 1, z}, 
    {0, 0, 0, 1}});
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] newPoints = new My3DPoint[8] ;
  for (int i=0; i<8; i++) {
    newPoints[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i])));
  }
  return new My3DBox(newPoints);
}