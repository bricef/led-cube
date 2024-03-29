/**
 * LED CUBE Implementation, has all functions drscribed in the CORE API. + some extra for drawing...
 * NB: this verisn contains Layer drawing debugging tool: ability to only draw one layer!
 */


/**
 * Core LED Cube API.
 * @author Michael Overington 
 * @author Edward Overton
 * @author Brice Fernandes
 * @author Thomas Loussert
 * @author Chris Ryan
 * @author Samuel Dove
 */
class LedCube{
  /**
   * 	 * @status
   * 	 * The status code for the LEDs
   * 	 * OFF|RED|GREEN|ORANGE
   	 */
  final static int OFF = 0;
  final static int RED = 1;
  final static int GREEN = 2;
  final static int ORANGE = 3;
  
  int onlylayer = -1;


  /**
   * Here we define our 3d Cube
   */

  final static int CUBESIZE = 8; //size of cube
  final static float LEDSPACE = 40; //led spacing
  final static float startX = -CUBESIZE*40/2; //XYZ starting locations. eg. location of first LED (X,Y,Z)
  final static float startY = -CUBESIZE*40/2;
  final static float startZ = -CUBESIZE*40/2;

  int cubeState[][][] = new int[CUBESIZE][CUBESIZE][CUBESIZE]; // this is the variable used to export the cube, in the ReadCube function
  LED[][][] mycube = new LED[CUBESIZE][CUBESIZE][CUBESIZE]; //our LED's used in the cube
  //cubeState = new int[CUBESIZE][CUBESIZE][CUBESIZE];
  /*
         * Initilization of the cube...
   */

  LedCube(){
    for (int x = 0; x<CUBESIZE; x++){
      for (int y = 0; y<CUBESIZE; y++){
        for (int z = 0; z<CUBESIZE; z++){
          //here we create each LED, and set its XYZ location, the confusing (Y,Z,X) is to make sure the LED's
          mycube[x][y][CUBESIZE-z-1] = new LED(0,startY + float(y)*LEDSPACE ,startZ + float(z)*LEDSPACE , startX + float(x)*LEDSPACE);
        }
      }
    }
  }

  /*
          * Added function to draw the cube...
   */
   
/*D*/ void setOnly(int only){
       onlylayer = only;
     }

  void drawCube(){
    
    noStroke();
    for (int x = 0; x<CUBESIZE; x++){
      for (int y = 0; y<CUBESIZE; y++){
        for (int z = 0; z<CUBESIZE; z++){
    /*D*/   if ((onlylayer<0) || (onlylayer==z)) 
                  mycube[x][y][z].drawLED();
          //mycube[x][y][z].setXYZ(startX + float(x)*LEDSPACE, startY + float(y)*LEDSPACE, startZ + float(z)*LEDSPACE);
        }
      }
    }
  }
  /**
   * 	 * The Clear Cube method clears the internal representation of 
   * 	 * the LED cube, as well as switching off all the LEDs.
   	 */
  public void clearCube(){
    for (int x = 0; x<CUBESIZE; x++){
      for (int y = 0; y<CUBESIZE; y++){
        for (int z = 0; z<CUBESIZE; z++){
          mycube[x][y][z].changeState(0);
          //mycube[x][y][z].setXYZ(startX + float(x)*LEDSPACE, startY + float(y)*LEDSPACE, startZ + float(z)*LEDSPACE);
        }
      }
    }
  }    

  /**
   * 	 * The setLED method sets a given LED to a particular state
   * 	 * @param status The status of the LED (OFF|RED|GREEN|ORANGE)
   * 	 * @param x The x coordinate (0-7)
   * 	 * @param y The y coordinate (0-7)
   * 	 * @param z The z coordinate (0-7)
   * 	 * @see status
   	 */
  public void setLED(int status, int x, int y, int z){
    mycube[x][y][z].changeState(status);
  }

  /**
   * 	 * Sets the cube to a particular state.
   * 	 * @param status[][][] a three dimensional int array using status ints
   * 	 * @see status
   	 */
  public void setCube(int[][][] status){
    for (int x = 0; x<CUBESIZE; x++){
      for (int y = 0; y<CUBESIZE; y++){
        for (int z = 0; z<CUBESIZE; z++){
          mycube[x][y][z].changeState(status[x][y][z]);
        }
      }
    }
  }

  /**
   * 	 * sets an XY layer to the required states using a two dimensional 
   * 	 * int array.
   * 	 * @param status The two dimensional int array keeping the new plane state
   * 	 * @param layer The layer to be changed
   * 	 * @see status
   	 */
  public void setPlaneXY(int[][] status, int layer ){
    for (int x = 0; x<CUBESIZE; x++){
      for (int y = 0; y<CUBESIZE; y++){
        mycube[x][y][layer].changeState(status[x][y]);
      }
    }
  }

  /**
   * 	 * sets an XZ layer to the required states using a two dimensional 
   * 	 * int array.
   * 	 * @param status The two dimensional int array keeping the new plane state
   * 	 * @param layer The layer to be changed
   * 	 * @see status
   	 */
  public void setPlaneXZ(int[][] status, int layer ){
    for (int x = 0; x<CUBESIZE; x++){
      for (int z = 0; z<CUBESIZE; z++){
        mycube[x][layer][z].changeState(status[x][z]);
      }
    }
  }

  /**
   * 	 * sets an YZ layer to the required states using a two dimensional 
   * 	 * int array.
   * 	 * @param status The two dimensional int array keeping the new plane state
   * 	 * @param layer The layer to be changed
   * 	 * @see status
   	 */
  public void setPlaneYZ(int[][] status, int layer ){
    for (int y = 0; y<CUBESIZE; y++){
      for (int z = 0; z<CUBESIZE; z++){
        mycube[layer][y][z].changeState(status[y][z]);
      }
    }
  }

  /**
   * 	 * The readCube() method returns a representation of the cube as a three
   * 	 * dimensional int array using the built-in status codes.
   * 	 * @return status[][][] The representative array of the cube
   * 	 * @see status
   	 */
  public int[][][] readCube(){
    for (int x = 0; x<CUBESIZE; x++){
      for (int y = 0; y<CUBESIZE; y++){
        for (int z = 0; z<CUBESIZE; z++){
          cubeState[x][y][z] = mycube[x][y][z].getState();
        }
      }
    }

    return cubeState;
  }
  
  public byte[][] getByteStream(){ 
    
    /*
     * @Authors: Samuel Dove, Edward Overton.
     * Initial Work done by Sam.
     * tweaked and incoperated into LEDCUBE class done by Edward.
     *
     *  @About: Trying to solve byte array problem.
     *          Converting the data stored in the computer to draw the cube, to a ByteStream which can be written onto the cube
     */
    
    byte[][] stream = new byte[8][32];
    
    byte temp;
    
    //lets loop through z
    int x,y,i;
    for (int z=0; z<8; z++){
      
      //loop through all x'es. inside the loop the 4 (2nd half Green, Red, 1st half Greem, Red) different 'y' bytes will be calculated (for a given x)
      //and each written to the correct part of the array.
      for (x=7; x>=0; x--){
        
        temp = 0x00;//temp is the byte were manipulating, initilised each time.
        //looping through the bottom block of y's (these need to be written first)
        for (y=3; y<8; y++){
        
          //If green LED needs to be on
          if ( (mycube[x][y][z].getState() == GREEN) || (mycube[x][y][z].getState() == ORANGE)){
            //turn the corresponding bit on, done by shifting 00000001 to the correct bit, then using an OR opertation.
            //remenber 8 > y > 3, so to put the correct bit in the 0-4 range we need to subtract4.
            temp |= ( 0x01 << (y-4) );
          }
        }  
        //okay, now lets write the bits to the array... remenber the 0th element needs to be written first.
        stream[z][7-x] = temp;


        //repeating abouve for red
        temp = 0x00;
        for (y=3; y<8; y++)
          if ( (mycube[x][y][z].getState() == RED) || (mycube[x][y][z].getState() == ORANGE)){ //this time we are setting the RED led.
            temp |= ( 0x01 << (y-4) );
        }
        stream[z][8+7-x] = temp; // we need to manipulate the array 8 elements further along.
        
        //now we shall do the first half (y:0-4)
        temp = 0x00;
        for (y=0; y<4; y++)
          if ( (mycube[x][y][z].getState() == GREEN) || (mycube[x][y][z].getState() == ORANGE)){
            temp |= ( 0x01 << (y) ); //no need to subtract 4 now, scince y ranges from 0-3
          }
        stream[z][16+7-x] = temp; //we now need to write into the array between 15-23
        
        //now doing the first red half.
        temp = 0x00;
        for (y=0; y<4; y++)
          if ( (mycube[x][y][z].getState() == RED) || (mycube[x][y][z].getState() == ORANGE)){
            temp |= ( 0x01 << (y) );
          }
        stream[z][24+7-x] = temp;
        
      
    }
  }
    
    
    
    return stream;
    
  }

}

