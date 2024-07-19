///WARNING - AUDIO FILE MAY BE A BIT LOUD!!

//quick overview of the game and what the goal is
//1. player will begin the game with objects falling from the top of the screen (the sky) and will the an objective to catch the glass falling. 
//2.if the player catches the glass, the player will receive 1 point and the point system will update.
//3.if the player catches any other object then the player will lose a live and if the lives reach 0, the game will be over.
//4.the player will be given a choice to try again.
//5.difficulty increases when the score are divisible by 12 (so 12, 24...) in which the speed of the objects falling will increase.



   
// soundfile libary;
//this library import was taken from cs171 lab 3 to get an audio file
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim       minim; //make sure to import the minim library before running this code 
AudioPlayer jingle;

//line allows me to import an image for the background and bin that will catch the glass
PImage scene, bin;

// variables to be used in the game
int score = 0;
int lives = 5;
int Speed = 5;

// Item names and information
String[] items = {"Paper", "Plastic", "Glass", "Organic"};
PImage[] Pictures = new PImage[items.length];
float[] X, Y;
int[] itemIndex;

// Player's bin variables
float bX, bY;
int Width = 80;
int Height = 75;

void setup() {
  //SETTING THE GAME FUNCTIONALITY
  size(1280, 720);
  
  // Load item images from file saved on laptop
  for (int i = 0; i < items.length; i++) {
    Pictures[i] = loadImage(items[i].toLowerCase() + ".png");
  }
  
  
  //importing the image to be used as the bin
  bin = loadImage("pngimg.com - recycle_bin_PNG32.png");
  
  // Initializeing arrays to allow me to chose which item i want to catch 
  X = new float[items.length];
  Y = new float[items.length];
  itemIndex = new int[items.length];
  
  // Setting initial positions for items on screen
  for (int i = 0; i < items.length; i++) {
    X[i] = random(width - 30);
    Y[i] = -30 - i * 100;
    itemIndex[i] = i;
  }
  
  
  // Setting initial position for the player's bin on screen
  bX = width / 2 - Width / 2;
  bY = height - 50;
  
  
    //importing the image to be used as the background
  scene = loadImage("jurassic_park_background_by_jakeysamra_dfo1izw-fullview.jpg"); // load image
  
  //code below is adapted from CS171 LAB 3 
// Load a beat I produced and import from the data folder of the sketch and play it back in a loop
minim = new Minim(this);
jingle = minim.loadFile("AKI0!!!.mp3");   // load the music file into memory
jingle.loop();                          //  play the file on a loop
}


boolean gameOver = false; //this is a variable to track whether the game is over

void draw() {
  
    // this will check if the game is over
  if (lives <= 0 && !gameOver) {
    gameOver = true; // starts the game over process
    jingle.close();
    noLoop(); //stops the music
    gameOver();
  }
  
  if (gameOver) {
      // Display the game over screen with the "try again" button
    return; // Stop the void draw loop when the game is over
  }
  
   //SETTING THE GAME APPEARANCE
  background(scene);
  bX = constrain(mouseX - Width / 2, 0, width - Width);
  
  // Display player's score and lives
  fill(255,255);
  textSize(20);
  text("Score: " + score, 50, 30);
  text("Lives: " + lives, width - 150, 30);
  text("CATCH THE GLASS ", 550, 30);
  
  // Draw player's bin
  image(bin, bX, bY, Width, Height);
  
  // Move and draw the items with images
  for (int i = 0; i < items.length; i++) {
    Y[i] += Speed;
    
    // Check if the suitable item is caught in the bin
    if (isItemCaught(i)) {
      handleCaughtItem(i);
    }
    
    // Check if the items reach the bottom
    if (isItemAtBottom(i)) {
      resetItemState(i);
    }
    
    // Draw the item image
    drawItemPicture(i);
  }
}


//this code will begin setting the objective of the game 
//the code will determin if the item is caught in the bin is glass and if so, the point will increase by 1 or else the player will lose a live

boolean isItemCaught(int i) {
  return Y[i] > bY && Y[i] < bY + 20 && X[i] > bX && X[i] < bX + Width;
}

void handleCaughtItem(int i) {
  if (itemIndex[i] == 2) {
    // glass - increase score
    score += 1;
  } else {
    // Incorrect item - lose a life
    lives--;
  }
  
  //code will help to increase difficulty 
  //speed of falling object will increase for every 20 points but only if it is glass
  if (score % 12 == 0 && itemIndex[i] == 2) {
        // glass- increase score
        Speed += 1;
      }
      
  // Reset the item positions
  resetItemState(i);
}


//this line checks if the items has reached the bottom of the screen
//this will then reset the item position back to the top
boolean isItemAtBottom(int i) {
  return Y[i] > height;
}


//Reset the item positions
// the y position will be placed above the window and x position will be random
void resetItemState(int i) {
  Y[i] = -30;
  X[i] = random(width - 30);
}

//this takes the image falling back to the top onces the function has checked that it has reached the bottom
void drawItemPicture(int i) {
  image(Pictures[itemIndex[i]], X[i], Y[i], 60, 60);
}



//CREATING A NEW FUNCTION FOR WHEN THE GAME IS OVER
//SETTING THE FUNCTIONS AND APPEARANCE

void gameOver()
{
  background (150,2,0);
  fill(255);
  textSize(40);
  textAlign(CENTER, CENTER); //processing.org/reference/textAlign...
  text("Oops, Game Over!", width/2, height/2);

//play button
  noStroke();
  fill(350, 355, 0);
  rect(width / 2 - 50, height / 2 + 50, 100, 40);
  fill(0);
  textSize(30);
  text("Again?", width / 2, height / 2 + 70);
}

void mousePressed() {
// once the game is over a new screen must open 
//which gives player the option to play again

  if (gameOver) {

    float BXaxis = width / 2 - 50;
    float BYaxis = height / 2 + 50;
    float Width2 = 80;
    float Height2 = 40;

    if (mouseX > BXaxis && mouseX < BXaxis + Width2 && mouseY > BYaxis && mouseY < BYaxis + Height2) {

      resetGame();
    }
  }
}

void resetGame() {
//this will reset the game variables when the player opts to try again
  score = 0;
  lives = 5;
  Speed = 5;
  gameOver = false;
  setup();  // reset the function of the game
  draw(); // reset the appearance of the game
  loop(); //reset the draw functions and loops
  
}
