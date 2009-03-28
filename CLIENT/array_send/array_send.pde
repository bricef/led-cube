
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
public static final int MAX_WAIT_MILLIS = 1000;
int returned=0;
int del=20;
byte[] buffer = {12,11,10,9,8,7,6,5,4,3,2,1,0};
byte[][] doubleBuffer = {
                          {12,11,10,9,8,7,6,5,4,3,2,1,0},
                          {12,11,10,9,8,7,6,5,4,3,2,1,0}
                         };
                         
void setup() 
{
 
  println(Serial.list());
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 115200);//must match the baud rate on the arduino.
  
  
  
}


void draw() {
  
  /*
   * INIT
   * CHECKED @ 115200 baud
   */
   print("Checking for readiness");
  while(returned!=INIT_OK){
    print(".");
   SSend(INIT_IS_READY);
    returned=myPort.read();
  }
  println();
  //delay(del);
  
  
  writeCube();
}



void writeCube(){
  

 try{
       
       //send begin cube
        //for layer in layers:   
           //send begin layer
           //send layer bytes
           //send endlayer
           //wait for layer ack
             //if layer ACK +ve layer+=1;
             //else leyer=layer;
       //send endcube
       
      SSend(BEGIN_CUBE);  
      for(int j=0; j<doubleBuffer.length;j++){
        SSend(BEGIN_LAYER);
        for(int i=0; i<doubleBuffer[j].length; i++){
          SSend(doubleBuffer[j][i]);
          if(myPort.available()==1){println(myPort.read());}
        }
        SSend(END_LAYER);
        if(!waitForLayerACK()){
            j--;
        }
      }
      SSend(END_CUBE);
      waitForCubeACK();
      
 }catch(Exception e){
  System.out.println(e);
  System.exit(1);
 } 
}

boolean waitForCubeACK()  throws Exception{
  int time = millis();
  int opcode = myPort.read();
    while(opcode!=CUBE_SUCCESS){
      if(millis()-time>MAX_WAIT_MILLIS){
         throw new Exception("the arduino board does not seem to be responding (NO CUBE ACK)");
        }
        opcode=myPort.read();
    }
    return true;
}


boolean waitForLayerACK()  throws Exception{
  int time = millis();
  boolean success=false;
  boolean acked=false;
  int opcode = myPort.read();
  println(opcode);
    while(!acked){
      if(millis()-time>MAX_WAIT_MILLIS){
         throw new Exception("the arduino board does not seem to be responding (NO LAYER ACK)");
        }
      if(opcode==LAYER_ACK_SUCCESS){
          acked=true;
          success= true;
      }else if(opcode==LAYER_ACK_FAIL){
          acked=true;
          success= false;
      };
      opcode=myPort.read();
    }
    return success;
}

void SSend(int toSend){
  myPort.write(toSend);
    delay(del);
}

