
#include <Wasp4G.h>
#include <WaspFrame.h>

// APN settings
///////////////////////////////////////
char apn[] = "mmsbouygtel.com";
char login[] = "";
char password[] = "";
///////////////////////////////////////

// SERVER settings
///////////////////////////////////////
//char host[] = "serveurgarage.ddns.net";
//uint16_t port = 80;
//char resource[] = "/writePDO.php?no m=david&possesseur=SAMY&prix=3"; 
//char resource[] = "/getpost_frame_parser.php?id_wasp=WASPMOTE1&id_secret=3764392763&frame_type=155&frame_number=12&BAT=71&HUMA=34&TCA=22&ACC=45,67,89";

///////////////////////////////////////
//char resource[100];
char nom[] = "dav";
char possess[] = "possess";
int prixx = 420;


//char int = 30;
//char nom[20] = "crash_bandicoot";
//char possesseur[] = "dav";

// SERVER settings
///////////////////////////////////////
char host[] = "10.10.10.1";
uint16_t port = 80;
///////////////////////////////////////

// define the Waspmote ID
char moteID[] = "node_04";


/*
char host[] = "test.libelium.com";
uint16_t port = 80;
char resource[] = "/test-get-post.php?varA=1&varB=2&varC=3&varD=4&varE=5&varF=6&varG=7&varH=8&varI=9&varJ=10&varK=11&varL=12&varM=13&varN=14&varO=15";*/

// variable
uint8_t error;
uint8_t PIN_status;
char PIN_code[30];

int counter;
int temp;
uint32_t previous;

void setup()
{
  USB.ON();
  frame.setID(moteID);
  USB.println(F("Start program"));

  USB.println(F("********************************************************************"));
  USB.println(F("GET method to the Libelium's test url"));
  USB.println(F("You can use this php to test the HTTP connection of the module."));
  USB.println(F("The php returns the parameters that the user sends with the URL."));
  USB.println(F("********************************************************************"));



  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();
}



void loop()
{
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();
  

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));
  USB.println(F("2. Reading code..."));
  PIN_status = _4G.checkPIN();
  USB.println(F("Please, enter the code: "));
  readString(PIN_code);
  if ((PIN_status != 0) && (PIN_status < 16))
  {
    USB.print(F("3. Entering PIN code..."));
    if (_4G.enterPIN(PIN_code) == 0) 
    {
      USB.println(F("3. done"));
    }
    else
    {
      USB.println(F("3. error"));
    }
  }
  _4G.checkConnection(60);
  
    ////////////////////////////////////////////////
    // 2. HTTP GET
    ////////////////////////////////////////////////

    USB.print(F("2. Getting URL with GET method..."));
/*
    int prix = 50;
    float longi = 356.1;
    char nom[] = "test";
    char possesseur[] = "testefkndk";
    char resSource[] = " " ;
  sprintf(resSource, "/writePDO.php?nom=%DAV&possesseur=%LOL&prix=%5"); */
  
   //char resource[]="";

  //char nom[] = "dav";
//char possesseur[] = "moi";
//int prix = 34;

 
   //snprintf(resource,sizeof(resource), "/writePDO.php?nom=%s&possesseur=%s&prix=%d", nom, possess, prixx  );
   //USB.println( resource );
    // send the request
//create frame;
 RTC.ON();
    RTC.getTime();
 frame.createFrame(ASCII);
    // set frame fields (Time from RTC)
    frame.addSensor(SENSOR_TIME, RTC.hour, RTC.minute, RTC.second);


    ////////////////////////////////////////////////
    // 3. Send to Meshlium
    ////////////////////////////////////////////////
    USB.print(F("Sending the frame..."));
    error = _4G.sendFrameToMeshlium( host, port, frame.buffer, frame.length);


    
   // error = _4G.http( Wasp4G::HTTP_GET, host, port, resource);
  
    // Check the answer
    if (error == 0)
    {
      USB.print(F("Done. HTTP code: "));
      USB.println(_4G._httpCode);
      USB.print("Server response: ");
      USB.println(_4G._buffer, _4G._length);
    }
    else
    {
      USB.print(F("Failed. Error code: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }

/*
  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("3. Switch OFF 4G module"));
  _4G.OFF();


  ////////////////////////////////////////////////
  // 4. Sleep
  ////////////////////////////////////////////////
  USB.println(F("4. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("5. Wake up!!\n\n"));
*/

}

void readString(char* message)
{
  int x = 0;  

  // clean input buffer
  USB.ON();
  USB.flush();
  
  // wait for incoming data from keyboard
  while(USB.available() == 0);

  // Treat all incoming bytes
  while (USB.available() > 0)
  {
    message[x] = USB.read();

    if( (message[x] == '\r') || (message[x] == '\n') )
    {
      message[x]='\0';
    }
    else
    {
      x++;
    }
  }
}
