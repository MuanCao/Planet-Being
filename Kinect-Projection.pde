import java.util.*;
import KinectPV2.*;

KinectPV2 kinect;
float a,b,c,d;
//run Kinect_testRange to get them
float maxX=498.6;
float minX=75.45;
float maxY=396.2;
float minY=39.9;



float particlecount = 10;
float gravityF = 1;



ArrayList<Particle_Smoke> particles_smoke;

ArrayList<Particle_Spark> particles_spark;


float modeNum =0;
void setup(){
  //size(900,600);
  
  fullScreen();
  //background(0);
  kinect =new KinectPV2(this);
  
  kinect.enableSkeletonDepthMap(true);
  
  kinect.init();
  
    particles_smoke = new ArrayList<Particle_Smoke>();
  particles_spark = new ArrayList<Particle_Spark>();
  calFactor(maxX,minX,maxY,minY);
}

void draw(){
  background(0);
  ArrayList<KSkeleton> skeletonArray =kinect.getSkeletonDepthMap();
  
  for(int i=0;i<skeletonArray.size();i++){
    KSkeleton skeleton =(KSkeleton) skeletonArray.get(i);
    
    if(skeleton.isTracked()){
      KJoint[] joints=skeleton.getJoints();
      
      drawHand(joints[KinectPV2.JointType_HandRight]);  
      //drawHand(joints[KinectPV2.JointType_HandLeft]);
    }
  }
  
  
   //background(0);
  // create particles:
  //if (mousePressed) {

    //for (int i=0; i<5; i++) {
    //  particles_smoke.add(new Particle_Smoke());
    //};


    //for (int i=0; i<10; i++) {

    //  particles_spark.add(new Particle_Spark());
    //}
  


  if (particles_smoke.size()>0) {

    // move and show smoke
    for (int i = particles_smoke.size()-1; i > -1; i--) {
      particles_smoke.get(i).display();
      particles_smoke.get(i).update();
      // remove dead smoke
      if (particles_smoke.get(i).opacity <= 0) {
        particles_smoke.remove(i);
      }
    }
  }

  if (particles_spark.size()>0) {

    for (int i = particles_spark.size()-1; i > -1; i--) {
      particles_spark.get(i).display();
      particles_spark.get(i).update();
      // remove dead spark
      if (particles_spark.get(i).lifespan <= 0) {
        particles_spark.remove(i);
      }
    }
  }
}
void drawHand(KJoint joints){
  float X,Y;
  X=(float)joints.getX()*a+b;
  Y=(float)joints.getY()*c+d;
  //fill(255,0,0);
  //ellipse(X,Y,100,100);
  
  
  
      for (int i=0; i<5; i++) {
      particles_smoke.add(new Particle_Smoke(X,Y-height/2+80));
    };


    for (int i=0; i<15; i++) {

      particles_spark.add(new Particle_Spark(X,Y-height/2+80));
    }
}
void calFactor(float maxX,float minX,float maxY,float minY){
  a=width/(maxX-minX);
  b=-minX*width/(maxX-minX);
  c=height/(maxY-minY);
  d=-minY*height/(maxY-minY);
}


class Particle_Smoke {


  float x ;
  float y;
  float xv = random(-1, 1)*0.8;
  float yv = random(-1, 1)*0.8;

  // style
  float r = 100;
  float g = 150;
  float b = 200;
  float opacity = 10;
  float radius = 10;
  float gravity = 0.01;
  Particle_Smoke(float kx,float ky) {
    
    
    x = kx;
   y = ky;
    // physics
  }
  void display() {
    fill( r, g, b, opacity);
    ellipse( x, y, radius*4, radius*4);
  }
  void update() {
    // style
    opacity -= 0.1;
    radius += 0.4;
    // gravity
    yv +=  gravity;
    // movement
    x +=  xv;
    y +=  yv;
  }
}

class Particle_Spark {


  float x ;
  float y ;
  float xv = random(-1, 1)*0.5;
  float yv = random(-1, 1)*0.5;
  // style
  float r = 170;
  float g = 200;
  float b = 255;
  float lifespan = int(random(10, 150));
  float radius = random(1, 3);
  float weight = random(1);

  float   gravity = weight<0.8?0.01:0.02;
  float opacity= random(0, 255);
  Particle_Spark (float kx,float ky) {
    // physics
    
     x = kx;
   y = ky;
  }
  void display() {
    beginShape();
    fill( r, g, b, opacity);
    ellipse( x, y, radius*4, radius*4);
    endShape();
  }
  void update() {
    // style
    opacity = random(0, 255);
    lifespan--;

    yv +=  gravity;
    // movement
    x +=  xv;
    y +=  yv;
  }
}
