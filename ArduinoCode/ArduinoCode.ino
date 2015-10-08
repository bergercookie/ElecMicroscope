  //////////////////////////////////////////////////////////////////////
// NATIONAL TECHNICAL UNIVERSITY OF ATHENS                          //
// SYSTEMS BIOENGINEERING GROUP                                     //
// Nikolaos Koukis, Antonis Theodosopoulos                          //
// Control of Electrically-driven microscope using Arduino Board   //
// Septempber 2015,                                                //
/////////////////////////////////////////////////////////////////////

// LIBRARISES INPUT
/////////////////////////////////

#include <Servo.h>

// for the xyStage
#include <AccelStepper.h>

// INITIALIZATION - SPECIAL OBJECTS
////////////////////////////////////

Servo lamp_servo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

// GLOBAL VARS INITIALIZATION
/////////////////////////////////

// inputString
String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete

// xystageStr
String xystageStr = "";  //
boolean xystageComplete = false; // whether the string is complete

int lamppos = 0;    // variable to store the servo position
int lamppos_OFF = 55;
int lamppos_ON = 0;

// GLOBAL VARS - FILTER
int Position;
int nextstep;
int nexthole;
int stepCount;
int prevstep = 0 ;
int prevhole = 0 ;
int steps;
int holes;
int MaxLimit;
int MinLimit;
int i;
boolean FinalDestination;

int dirpin = 9;
int steppin = 8;
int OpSwitchPin  = 10;
//int TestLED = 9;
int HoleCount;
int stCount;
int Direction;
boolean OpSwitchState;
boolean dataAvailable_filter = false;
boolean HoleVal = false;

int HoleDistance = 300 ;
boolean LastHoleVal = false;
boolean InitializationVal;
boolean FirstHoleVal = true;
boolean StartInitialVal = false;


// GLOBAL VARS - XYSTAGE
/////////////////////////////////
// todo, check the pins
int buttonX = 2;
int buttonY = 3;
// STEPPERS VARS
AccelStepper stepperX(1, A4, A5);
AccelStepper stepperY(1, 5, 6);
int enableXstepper = A0;
int enableYstepper = 4;

int MS1pin = A1;
int MS2pin = A2;
int MS3pin = A3;

// SETUP
void setup() {
  // initialize serial:
  Serial.begin(9600);
  // reserve 200 bytes for the inputString:
  inputString.reserve(200);


  // Specify servo pin
  lamp_servo.attach(11);  // attaches the servo on pin 9 to the servo object

  // FILTER - Setup Phase
  //////////////////////////

  pinMode(dirpin, OUTPUT);                  //orizoume PIN gia kateuthinsh
  pinMode(steppin, OUTPUT);                 //orizoume PIN gia arithmo steps
  //  pinMode(TestLED, OUTPUT);                 //orizoume PIN gia LED
  pinMode(OpSwitchPin, INPUT);              //orizoume PIN gia aisthitira
  FinalDestination = false;
  dataAvailable_filter = false;

  stepCount = 0;               //midenizei metrhth
  digitalWrite(dirpin, LOW);    // kateythinsh pros ta dexia
  StartInitial();               // kalei sinarthsh poy entopizei tin prwth trypa poy vriskei brosta toy. mexri kai to teleutaio dexi simeio exei trypa
  digitalWrite(dirpin, HIGH);  // orizetai kateythinsh pros ta aristera

  // XYSTAGE - Setup Phase
  /////////////////////////

  pinMode(MS1pin, OUTPUT);
  pinMode(MS2pin, OUTPUT);
  pinMode(MS3pin, OUTPUT);
  pinMode(enableXstepper, OUTPUT);
  pinMode(A4, OUTPUT);
  pinMode(A5, OUTPUT);

  //When enable%stepper is HIGH, drivers are OFF. In that way the system remains Cool.
  digitalWrite(enableXstepper, HIGH);
  digitalWrite(enableYstepper, HIGH);

  stepperX.setMaxSpeed(10000.0);
  stepperX.setAcceleration(5000.0);
  stepperY.setMaxSpeed(10000.0);
  stepperY.setAcceleration(5000.0);

  //  // XYSTAGE - Initialization Phase
  //  // Initialization of X, Y axis. Set Coordinates (0,0)
  X_Initialization();
  Y_Initialization();

  // initialize
  initialize();

  ////////////////////////////////////////////////////////////////////
  ////////// set microstepping mode... ///////////////////////////////
  ////////////////////////////////////////////////////////////////////
  ////////// MS1  MS2 MS3 Microstep Resolution /////////
  ////////// Low  Low Low Full step            /////////
  ////////// High Low Low Half step            /////////
  ////////// Low  High  Low Quarter step         /////////
  ////////// High High  Low Eighth step          /////////
  ////////// High High  High  Sixteenth step       /////////
  ////////////////////////////////////////////////////////////////////
  //    STEPPING MODE SET -- MICROSTEPPING 1/16    ///////////////////
  ////////////////////////////////////////////////////////////////////
  digitalWrite(A1, HIGH);
  digitalWrite(A2, HIGH);
  digitalWrite(A3, HIGH);



}

// LOOP
void loop() {
  serialEvent(); //call the function
  // print the string when a newline arrives:


  if (stringComplete) {
    // max  == OFF
    // min  == ON

    // String complete.. now choose the case...

    // LAMP CASES
    if (inputString == "lampon\n") {
      if (lamppos != lamppos_ON) {
        lampon();
        Serial.println("lampon OK");
      }
      else {
        Serial.println("Lamp already ON");
      }
      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "lampoff\n") {
      if (lamppos != lamppos_OFF) {
        lampoff();
        Serial.println("lampoff OK");
      }
      else {
        Serial.println("Lamp already OFF");
      }
      stringComplete = false;
      inputString = "";
    }

    // FILTER POSITIONS
    else if (inputString == "filter\n") {
      Serial.println("Going into filter mode..");
      loop_filter();
      Serial.println("Returned from filter mode successfully.");

      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "UP\n") {
      Serial.println("going  UP");
      digitalWrite(A1, LOW);
      digitalWrite(A2, LOW);
      digitalWrite(A3, LOW);
      while (xystageComplete == false && xystageStr != "RELEASE\n") {
        serialEventXY(); // Now read for any new char..
        digitalWrite(enableYstepper, LOW);
        stepperY.setSpeed(-1000);
        stepperY.runSpeed();
      }
      digitalWrite(enableYstepper, HIGH);
      xystageStr = "";
      xystageComplete = false;

      // stringComplete
      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "DOWN\n") {
      Serial.println("going  DOWN");
      digitalWrite(A1, LOW);
      digitalWrite(A2, LOW);
      digitalWrite(A3, LOW);
      while (xystageComplete == false && xystageStr != "RELEASE\n") {
        serialEventXY(); // Now read for any new char..
        digitalWrite(enableYstepper, LOW);
        stepperY.setSpeed(1000);
        stepperY.runSpeed();
      }
      digitalWrite(enableYstepper, HIGH);
      xystageStr = "";
      xystageComplete = false;

      // stringComplete
      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "RIGHT\n") {

      Serial.println("i am going RIGHT");
      digitalWrite(A1, LOW);
      digitalWrite(A2, LOW);
      digitalWrite(A3, LOW);

      while (xystageComplete == false && xystageStr != "RELEASE\n") {
        serialEventXY(); // Now read for any new char..
        digitalWrite(enableXstepper, LOW);
        stepperX.setSpeed(-1000);
        stepperX.runSpeed();
      }
      digitalWrite(enableXstepper, HIGH);
      xystageStr = "";
      xystageComplete = false;

      // stringComplete
      stringComplete = false;
      inputString = "";
    }
    else if (inputString == "LEFT\n") {

      Serial.println("i am going LEFT");
      digitalWrite(A1, LOW);
      digitalWrite(A2, LOW);
      digitalWrite(A3, LOW);

      while (xystageComplete == false && xystageStr != "RELEASE\n") {
        serialEventXY(); // Now read for any new char..
        digitalWrite(enableXstepper, LOW);
        stepperX.setSpeed(1000);
        stepperX.runSpeed();
      }
      digitalWrite(enableXstepper, HIGH);
      xystageStr = "";
      xystageComplete = false;

      // stringComplete
      stringComplete = false;
      inputString = "";
    }
    else {
      Serial.println("MAIN LOOP: String not recognised");
      Serial.println(inputString);
      stringComplete = false;
      inputString = "";
    }
  }
}


// INITIALIZATION FUNCTIONS
///////////////////////////
void initialize() {

  initlamp();

  // todo add this again
  //  initfilter();

  // XYSTAGE - Initialization Phase
  // Initialization of X, Y axis. Set Coordinates (0,0)
  X_Initialization();
  Y_Initialization();
}

void initlamp() {
  // LAMP
  lampon();
  lampoff();
}

void initfilter() {               //programma initialization
  LastHoleVal = LastHole();    // kalei sunarthsh pou vriskei to teleutaio epitrepto simeio tou rack (aristero shmeio)
  if (LastHoleVal) { // an to vrei
    FirstHoleVal = FirstHole();            //kalei sunarthsh pou vriskei tin prwth trypa (paei pros ta dexia mehri na vrei tin prwti trypa)
  }
  if (FirstHoleVal == true) { // an vrei tin prwth trypa pigainei automata sti prwth thesi tou filterset
    InitializationVal = false;
    stepCount = 0;
    while (!InitializationVal) {
      stepCount = stepCount + 1;
      digitalWrite(dirpin, HIGH);
      StepperMover();
      if (stepCount == 387) { //VALE TIMH poso apexxei i thesi ena apo tin prwth (apo aristera) trypa se step
        InitializationVal = true;
        Serial.println("initialization FINITO...ready for use");
        Serial.println(stepCount);
      }
    }
    stepCount = 0;    //midenizei to metrhth twn step kai ksekiname
  }
}

// FINISH FUNCTIONS
///////////////////////////

void finish() {
  // LAMP
  lampoff();

  // FILTER PISITION
}

////////////////////////////////
// SUPPLEMENTARY FUNCTIONS
////////////////////////////////
//void loop_xystage() {
//  Serial.println("[XYSTAGE] Issue the direction (UP/DOWN/LEFT/RIGHT)");
//  while (1) {
//  serialEvent(); //call the function
//  // print the string when a newline arrives:
//  if (stringComplete) {
//
//    ///////////////////////////////////////
//    ////   ATTACH THE OTHER PROGRAM    ////
//    ///////////////////////////////////////
//    //    XY STAGE POSITION      //////////
//    if (inputString == "UP\n") {
//
//      Serial.println("i am going UP");
//      digitalWrite(enableYstepper, LOW);
//      stepperY.setSpeed(-100);
//      stepperY.runSpeed();
//      digitalWrite(enableYstepper, HIGH);
//
//      stringComplete = false;
//      inputString = "";
//      break;
//    }
//    else if (inputString == "DOWN\n") {
//
//      Serial.println("i am going DOWN");
//      digitalWrite(enableYstepper, LOW);
//      stepperY.setSpeed(-100);
//      stepperY.runSpeed();
//      digitalWrite(enableYstepper, HIGH);
//
//      stringComplete = false;
//      inputString = "";
//      break;
//    }
//    else if (inputString == "RIGHT\n") {
//
//      Serial.println("i am going RIGHT");
//
//      digitalWrite(enableXstepper, LOW);
//      stepperX.setSpeed(-1000);
//      stepperX.runSpeed();
//      digitalWrite(enableXstepper, HIGH);
//
//      stringComplete = false;
//      inputString = "";
//      break;
//    }
//    else if (inputString == "LEFT\n") {
//
//      Serial.println("i am going LEFT");
//
//      digitalWrite(enableXstepper, LOW);
//      stepperX.setSpeed(1000);
//      stepperX.runSpeed();
//      digitalWrite(enableXstepper, HIGH);
//
//      stringComplete = false;
//      inputString = "";
//      break;
//    }
//    else {
//      Serial.println("XYSTAGE-LOOP: String not recognised");
//      Serial.println(inputString);
//      stringComplete = false;
//      inputString = "";
//      break;
//    }
//  }
//}
//}

void loop_filter() {
  Serial.println("[FILTER] Choose position to go to.");
  // exw orisei to dataAvailable_filter=false, ara to !available einai true. vazw
  // while wste na perimenei na diavasei data kai otan diavasei
  //(parei timh true diladi) tote na sinehisei sto upoloipo programma

  while (!dataAvailable_filter) {
    if (Serial.available() > 0) {      //see if there is incominc serial
      Position = Serial.read();        //diavazei tin epomeni thesi poy theloyme na paei
      ReadValues();                    // diavazei apo tin subroutine READVALUES tis apolutes sintetagmenes (steps holes) t filtrou p theloume (1,2,3,4)
    }
    // check if same port
    if (prevstep == nextstep && dataAvailable_filter) {                        // ama kapoios pliktrologisei idia thesi me proigoumeni tou zitaei alli thesh
      Serial.println(" eisai hdh se auto to filtro stoke");
      Serial.println("  ");
      dataAvailable_filter = false;
    }
    HoleCount = 0;                                      // mhdenizoume to holecount gian a min perasei i proigoumeni timh sti metrhsh twn trypwn tis epomenis kinhshs
    stCount = 0;                                        // midenizoume stCount metrhth
  }
  steps = abs(prevstep - nextstep);                     // poia einai i diafora tvn step anamesa sti proigoumeni thesi kai stin epomeni
  holes = abs(prevhole - nexthole);                     // poses trypes prepei na dianusw apo tin proigoumeni thesi stin epomeni
  Serial.print("Prepei na dianusw ");
  Serial.print(steps);
  Serial.print(" step kai ");
  Serial.print(holes);
  Serial.print(" trypes ");
  Serial.println(" ");
  Serial.println(" ");

  // Choosing the direction
  if (nextstep > prevstep) {   //entopizei poia einai i kateuthinsh poy prepei na akolouthisei
    digitalWrite(dirpin, LOW);  //prepei na kinithei clockwise
    Direction = 0;
  } else {
    digitalWrite(dirpin, HIGH); //prepei na kinithei anticlockwise
    Direction = 1;
  }
  Serial.print(" Paw pros ta: ");        // 1 dexiostrofa, 0 aristerostrofa ( i anapoda)
  Serial.println(" ");
  Serial.println(Direction);
  Serial.println(" ");
  Serial.println(" ");


  while (!FinalDestination) {       // oso den ehei vrei tin telikh thesi tha kanei auto to while.
    if (Direction == 0) {           // an girizei anticlockwise ta step meiwnontai
      stepCount += 1;
    } else {                               // an clockwise ta steps auksanontai
      stepCount -= 1;
    }

    MaxLimit = steps + 100;
    MinLimit = steps - 100;

    if (stepCount == nextstep ) {
      FinalDestination = true;
      prevhole = nexthole;
      prevstep = nextstep;
      dataAvailable_filter = false;
    } else {

      digitalWrite(steppin, LOW);  // This LOW to HIGH change is what creates the
      digitalWrite(steppin, HIGH); // "Rising Edge" so the easydriver knows to when to step.
      delay(2) ;                   // This delay time is close to top speed for this
    }
  }
  prevhole = nexthole;     //prin diavasei tin epomeni thesi prepei na krathsei thn twrinh
  prevstep = nextstep;
  dataAvailable_filter = false;
}

/*
SerialEvent occurs whenever a new data comes in the
hardware serial RX.  This routine is run between each
time loop() runs, so using delay inside loop can delay
response.  Multiple bytes of data may be available.
*/
void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    // add it to the inputString:
    inputString += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      stringComplete = true;
      Serial.println(inputString);
    }
  }
  //  return inputString;
}

// serialEventXY() - duplicate of the above for the infinite loop inside the
// UP, DOWN, LEFT, RIGHT conditionals
void serialEventXY() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    // add it to the xyStageStr:
    xystageStr += inChar;
    // if the incoming character is a newline, set a flag
    // so the main loop can do something about it:
    if (inChar == '\n') {
      xystageComplete = true;
      Serial.println(xystageStr);
    }
  }
  //  return xystageStr;
}


// DEVICES FUNCTIONS
/////////////////////////

// SHUTTER LAMP FUNCTIONS
void lampon() {
  for (lamppos = lamppos_OFF; lamppos >= lamppos_ON; lamppos -= 1) { // goes from 180 degrees to 0 degrees
    lamp_servo.write(lamppos);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
  lamppos += 1;
}

void lampoff() {
  for (lamppos = lamppos_ON; lamppos <= lamppos_OFF; lamppos += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    lamp_servo.write(lamppos);              // tell servo to go to position in variable 'pos'
    delay(15);                       // waits 15ms for the servo to reach the position
  }
  lamppos -= 1;
}

// FILTER POSITION FUNCTIONS
void move2pos(int posnum_filter) {
  // TODO
}



// MOVE2POSITION FUNCTIONS
// [WARNING] todo - see here doesn't work correctly
void ReadValues() {          //oi syntetagmenes tvn shmeivn einai apolutes. (steps, holes)
  switch (Position) {              //periomenoume input 1,2,3,4 analoga me to poio filtro thelw na hrisimopoihsw kai epistrefei holes kai steps
    case '1':
      Serial.println("Filter 1 -> selected ");
      nextstep = 0;
      nexthole = 0;
      dataAvailable_filter = true;        // allazw tin sinthiki etsi wste na vgei apo ti while loop kai na prohwrisei sto upoloipo prohramma
      FinalDestination = false;    // allazw tin sinthiki gia ton telikh thesi wste na borei na bei sti loop kai na tin upologisei
      break;
    case '2':
      Serial.println("Filter 2 -> selected ");
      nextstep = 1496;
      nexthole = 5;
      dataAvailable_filter = true;
      FinalDestination = false;
      break;
    case '3':
      Serial.println("Filter 3 -> selected ");
      nextstep = 3355;
      nexthole = 12;
      dataAvailable_filter = true;
      FinalDestination = false;
      break;
    case '4':
      Serial.println("Filter 4 -> selected ");
      nextstep = 4851;
      nexthole = 17;
      dataAvailable_filter = true;
      FinalDestination = false;
      break;
    default :
      Serial.println("lathos.. try again");

  }                                                 // mehri edw to mono pou kanw einai na vrw ta steps kai holes
}

boolean LastHole() {  // vriskei to teleutaio epitrepto simeio tou rack
  while (LastHoleVal == false) {
    StepperMover();
    OpSwitchState = digitalRead(OpSwitchPin);
    if (OpSwitchState == HIGH) {
      if (stepCount > HoleDistance) {  //VALE POSA STEP APOSTASH EHEI KATHE TRYPA KAI PROSTHESE KAI MERIKA
        LastHoleVal = true;
        Serial.println("perasa tin teleutaia trypa ..");
      } else {
        stepCount = stepCount + 1;
      }
    } else {
      stepCount = 0;
    }
  }
  return LastHoleVal;
}
boolean FirstHole() {   //afou teliwsei i LASTHOLE epistrefei stin prwth trupa tou rack me auti ti synarthsh
  digitalWrite(dirpin, LOW);
  Serial.println("anapodaaaa mehri na vrw tin prwti trypa");
  stepCount = 0;
  FirstHoleVal = false;
  while (FirstHoleVal == false) {
    OpSwitchState = digitalRead(OpSwitchPin);
    if (OpSwitchState == LOW) {                 // an dhladh o aisthitiras entopisei tn trypa
      FirstHoleVal = true;                      // energopoieitai mia metavlhth
      Serial.println("WP na ti i prwti trypa.. ara twra prepei na paw sti thesi 1 tou filterset");
    }
    else {   //  tin prwth fora pou tha anapsei einai kai i prwth trupa
      if (stepCount < 600) {  //VALE ALLI TIMGH ston ELEGHO kineitai gia X steps mehri na vrei tin prvti trypa
        StepperMover();
        stepCount = stepCount + 1;
      } else {
        Serial.println( "something went TERRIBLY wrong, call an engineer"); // an den tin vrei einai paralogo
      }
    }
  }
  return FirstHoleVal;   // epistrefei TRUE otan vrei tin trypa
}

void StepperMover() {
  digitalWrite(steppin, LOW);  // This LOW to HIGH change is what creates the
  digitalWrite(steppin, HIGH); // "Rising Edge" so the easydriver knows to when to step.
  delay(4) ;    // This delay time is close to top speed for this
  // particular motor. Any faster the motor stalls.
}

void StartInitial() {
  while (StartInitialVal == false) {                 // gia na glutwsoume na eglwvistei sta akra paei pros ta dexiostrofa mehri na vrei trypa kai molis vrei tote ksekinaei to initialization
    OpSwitchState = digitalRead(OpSwitchPin);
    if (OpSwitchState == LOW) {
      StartInitialVal = true;
    } else {
      StepperMover();
    }
  }
}

// XYSTAGE FUNCTIONS
//////////////////////

//This function helps the motor run in both direction to demonstrate the movement of YX Stage
// At first the position is initalized and then the motors move in Fullstep mode
void TestProgramm() {
  X_Initialization();
  Y_Initialization();
  digitalWrite(enableXstepper, HIGH);
  digitalWrite(enableYstepper, HIGH);
}

// When the user demands three measuremetns for each well or point of specimen then it calls the function scann
// This function runs the motors in three different close positions
void scann() {
}

// INITIALIZATION OF X STEPPERMOTOR
void X_Initialization() {
  while (digitalRead(buttonX) == LOW) {
    digitalWrite(A1, LOW);
    digitalWrite(A2, LOW);
    digitalWrite(A3, LOW);
    digitalWrite(enableXstepper, LOW);
    stepperX.setSpeed(1000);
    stepperX.runSpeed();
  }
  digitalWrite(enableXstepper, HIGH);
}

// INITIALIZATION OF Y STEPPERMOTOR
void Y_Initialization() {
  digitalWrite(A1, LOW);
  digitalWrite(A2, LOW);
  digitalWrite(A3, LOW);
  while (digitalRead(buttonY) == LOW) {
    digitalWrite(enableYstepper, LOW);
    stepperY.setSpeed(1000);
    stepperY.runSpeed();
  }
  digitalWrite(enableYstepper, HIGH);
}
