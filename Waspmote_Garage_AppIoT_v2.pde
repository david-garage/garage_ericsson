/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to perform HTTP GET requests
 *  to the Meshlium device. A special php file parses the fields and
 *  insert them into the Meshlium's database
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify  
 *  it under the terms of the GNU General Public License as published by  
 *  the Free Software Foundation, either version 3 of the License, or  
 *  (at your option) any later version.  
 *   
 *  This program is distributed in the hope that it will be useful,  
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of  
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
 *  GNU General Public License for more details.  
 *   
 *  You should have received a copy of the GNU General Public License  
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 *  
 *  Version:           3.0
 *  Design:            David Gascon 
 *  Implementation:    Yuri Carmona 
 */

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO.h> 
#include <WaspFrame.h>
#include <WaspSensorGas_v30.h>

float temperature; // Stores the temperature in ºC
float humidity;     // Stores the realitve humidity in %RH
float pressure;    // Stores the pressure in Pa

// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////
// WiFi AP settings (CHANGE TO USER'S AP)
///////////////////////////////////////
char ESSID[] = "meshliumfa50";
char PASSW[] = "Garage!2017";
///////////////////////////////////////
// choose URL settings
///////////////////////////////////////
char type[] = "http";
char host[] = "10.10.10.1";
char port[] = "80";
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;

// CO Sensor must be connected physically in SOCKET_4
COSensorClass COSensor(SOCKET_4); 
// Concentratios used in calibration process
#define POINT1_PPM_CO 100.0   // <--- Ro value at this concentration
#define POINT2_PPM_CO 300.0   // 
#define POINT3_PPM_CO 1000.0  // 
// Calibration resistances obtained during calibration process
#define POINT1_RES_CO 230.30 // <-- Ro Resistance at 100 ppm. Necessary value.
#define POINT2_RES_CO 40.665 //
#define POINT3_RES_CO 20.300 //


// CO2 Sensor must be connected physically in SOCKET_2
CO2SensorClass CO2Sensor(SOCKET_2);
// Concentratios used in calibration process (PPM Values)
#define POINT1_PPM_CO2 350.0  //   <-- Normal concentration in air
#define POINT2_PPM_CO2 1000.0
#define POINT3_PPM_CO2 3000.0
// Calibration vVoltages obtained during calibration process (Volts)
#define POINT1_VOLT_CO2 0.300
#define POINT2_VOLT_CO2 0.350
#define POINT3_VOLT_CO2 0.380


// NO2 Sensor must be connected physically in SOCKET_3
NO2SensorClass NO2Sensor(SOCKET_3); 
// Concentrations used in calibration process
#define POINT1_PPM_NO2 10.0   // <-- Normal concentration in air
#define POINT2_PPM_NO2 50.0   
#define POINT3_PPM_NO2 100.0 
// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_NO2 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_NO2 25.50
#define POINT3_RES_NO2 3.55

// Air Pollutans Sensor can be connected in SOCKET6 or SOCKET7
APSensorClass APPSensor(SOCKET_7); 
  // Concentratios used in calibration process (in PPM)
#define POINT1_PPM_AP 10.0   // <-- Normal concentration in air
#define POINT2_PPM_AP 50.0   
#define POINT3_PPM_AP 100.0 
  // Calibration resistances obtained during calibration process (in Kohms)
#define POINT1_RES_AP 45.25  // <-- Ro Resistance at 100 ppm. Necessary value.
#define POINT2_RES_AP 25.50
#define POINT3_RES_AP 3.55
 
// Define the number of calibration points
#define numPoints 3

//VARIABLES
byte capteur[4];

// CO sensor
float concentrationsCO[] = { POINT1_PPM_CO, POINT2_PPM_CO, POINT3_PPM_CO};
float resValuesCO[] =      { POINT1_RES_CO, POINT2_RES_CO, POINT3_RES_CO};

//CO2 sensor
float concentrationsCO2[] = { POINT1_PPM_CO2, POINT2_PPM_CO2, POINT3_PPM_CO2};
float voltagesCO2[] =       { POINT1_VOLT_CO2, POINT2_VOLT_CO2, POINT3_VOLT_CO2};

//NO2 sensor
float concentrationsNO2[] = {POINT1_PPM_NO2, POINT2_PPM_NO2, POINT3_PPM_NO2};
float voltagesNO2[] =       {POINT1_RES_NO2, POINT2_RES_NO2, POINT3_RES_NO2};

//AP sensor
float concentrationsAP[] = { POINT1_PPM_AP, POINT2_PPM_AP, POINT3_PPM_AP};
float resValuesAP[] =      { POINT1_RES_AP, POINT2_RES_AP, POINT3_RES_AP};

int COPPM,CO2PPM,NO2PPM,APP_PPM;

// define the Waspmote ID 
char moteID[] = "WaspGarage_01";


void setup() 
{
  //USB.println(F("Start program"));  
     // Calculate the slope and the intersection of the logarithmic function
  COSensor.setCalibrationPoints(resValuesCO, concentrationsCO, numPoints);
  CO2Sensor.setCalibrationPoints(voltagesCO2, concentrationsCO2, numPoints);
  NO2Sensor.setCalibrationPoints(voltagesNO2, concentrationsNO2, numPoints);
  APPSensor.setCalibrationPoints(resValuesAP, concentrationsAP, numPoints);
  
  //USB.println(F("start sensors "));

  
// set the Waspmote ID
  frame.setID(moteID);

// Switch ON and configure the Gases Board
  Gases.ON();
  delay(100); 
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO.ON(socket);
  //if (error == 0){USB.println(F("WiFi switched ON"));}else{USB.println(F("WiFi did not initialize correctly"));}
  //On clean les valeurs WiFI precedentes
  error = WIFI_PRO.resetValues();
  //if (error == 0){USB.println(F("2. WiFi reset to default"));}else{USB.println(F("2. WiFi reset to default ERROR"));}
  //On fixe le essid
  error = WIFI_PRO.setESSID(ESSID);
  //if (error == 0){USB.println(F("3. WiFi set ESSID OK"));}else{USB.println(F("3. WiFi set ESSID ERROR"));}
  //On fixe le psw WiFi
  error = WIFI_PRO.setPassword(WPA2, PASSW);
  //if (error == 0){USB.println(F("4. WiFi set AUTHKEY OK"));}else{USB.println(F("4. WiFi set AUTHKEY ERROR"));}
  //On fait un soft reset pour prendre en commpte les valeurs
  error = WIFI_PRO.softReset();
  //if (error == 0){USB.println(F("5. WiFi softReset OK"));}else{USB.println(F("5. WiFi softReset ERROR"));}
}


void loop()
{ 
   byte capteur[4];
  capteur[0]=1; //CO
  capteur[1]=1; // CO2
  capteur[2]=1; //NO2
  capteur[3]=1; // Polluant
    //////////////////////////////////////////
  // 3. Read CO sensors
  //////////////////////////////////////////
if (capteur[0] == 1 )
{COSensor.ON();
    //USB.println(F("start CO "));

  float COVol = COSensor.readVoltage();          // Voltage value of the sensor
  float CORes = COSensor.readResistance();       // Resistance of the sensor
  COPPM = COSensor.readConcentration(); // PPM value of CO

  // Print of the results
  //USB.print(F("CO Sensor Voltage: "));
  //USB.print(COVol);
  //USB.print(F(" mV |"));

  // Print of the results
  //USB.print(F(" CO Sensor Resistance: "));
  //USB.print(CORes);
  //USB.print(F(" Ohms |"));

  //USB.print(F(" CO concentration Estimated: "));
  //USB.print(COPPM);
  //USB.println(F(" ppm"));
  COSensor.OFF();
   //USB.println(F("end CO "));
}
   ///////////////////////////////////////////
  // 4. Read CO2 sensors
  ///////////////////////////////////////////  
if (capteur[1] == 1 )
{CO2Sensor.ON();
  //USB.println(F("start CO2 "));

  // Voltage value of the sensor
  float CO2Vol = CO2Sensor.readVoltage();
  // PPM value of CO2
  CO2PPM = CO2Sensor.readConcentration();

  // Print of the results
  //USB.print(F("CO2 Sensor Voltage: "));
  //USB.print(CO2Vol);
  //USB.print(F("volts |"));
  
  //USB.print(F(" CO2 concentration estimated: "));
  //USB.print(CO2PPM);
  //USB.println(F(" ppm"));
 CO2Sensor.OFF();
   //USB.println(F("end CO2 "));
} 
  //////////////////////////////////////
    // 5. Read NO2 sensors
  /////////////////////////////////////////
if (capteur[2] == 1 )
{NO2Sensor.ON();
  //USB.println(F("start NO2 "));
  
  // PPM value of NO2
  float NO2Vol = NO2Sensor.readVoltage();       // Voltage value of the sensor
  float NO2Res = NO2Sensor.readResistance();    // Resistance of the sensor
   NO2PPM = NO2Sensor.readConcentration(); // PPM value of NO2

  // Print of the results
  //USB.print(F("NO2 Sensor Voltage: "));
  //USB.print(NO2Vol);
  //USB.print(F(" V |"));
  
  // Print of the results
  //USB.print(F(" NO2 Sensor Resistance: "));
  //USB.print(NO2Res);
  //USB.print(F(" Ohms |"));

  // Print of the results
  //USB.print(F(" NO2 concentration Estimated: "));
  //USB.print(NO2PPM);
  //USB.println(F(" PPM"));
  NO2Sensor.OFF(); 
  //USB.println(F("end NO2 "));
}
 ///////////////////////////////////////////
  // 6. Read sensors
  /////////////////////////////////////////// 
if (capteur[3] == 1 )
{APPSensor.ON();
  //USB.println(F("start Polluant "));

  float APPVol = APPSensor.readVoltage();         // Voltage value of the sensor
  float APPRes = APPSensor.readResistance();      // Resistance of the sensor
  APP_PPM = APPSensor.readConcentration();  // PPM value of AP1

  // Print of the results
  //USB.print(F("Air Pollutans Sensor Voltage: "));
  //USB.print(APPVol);
  //USB.print(F(" V |"));

  // Print of the results
  //USB.print(F(" Air Pollutans Sensor Resistance: "));
  //USB.print(APPRes);
  //USB.print(F(" Ohms |"));

  //USB.print(F(" Air Pollutans concentration Estimated: "));
  //USB.print(APP_PPM);
  //USB.println(F(" ppm"));
//  APPSensor.OFF();
  //USB.println(F("end Polluant "));
}

  
  
  //Lecture des sensors de la carte
  temperature = int(Gases.getTemperature()*10)/10;
  humidity = Gases.getHumidity();
  pressure = Gases.getPressure();

  
  // Print of the results
  //USB.print(F("Temperature: "));
  //USB.print(temperature);
  //USB.print(F(" Celsius Degrees |")); 
  //USB.print(F(" Humidity : "));
  //USB.print(humidity);
  //USB.print(F(" %RH"));
  //USB.print(F(" Pressure : "));
  //USB.print(pressure);
  //USB.print(F(" Pa"));
  //USB.println();
    ///////////////////////////////
    // 3.1. Create a new Frame 
    ///////////////////////////////
    
    // create new frame (only ASCII)
  frame.createFrame(ASCII,moteID); 

    // add sensor fields
  //frame.addSensor(SENSOR_STR, "Waspmote Garage 1");
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());
  // Add temperature
  //frame.addSensor(SENSOR_GASES_TC, temperature);
  // Add humidity
  //frame.addSensor(SENSOR_GASES_HUM, humidity);
  // Add pressure
  //frame.addSensor(SENSOR_GASES_PRES, pressure);
     // Add CO PPM value
  frame.addSensor(SENSOR_GASES_CO, COPPM);
   // Add CO2 PPM value
  frame.addSensor(SENSOR_GASES_CO2, CO2PPM);
   // Add VOC PPM value
  frame.addSensor(SENSOR_GASES_NO2, NO2PPM);
   // Add APP PPM value
  frame.addSensor(SENSOR_GASES_AP1, APP_PPM);

  // print frame
  frame.showFrame();

  // Check if module is connected
  if (WIFI_PRO.isConnected() == true)
  {    
    //USB.print(F("WiFi is connected OK"));
    //USB.print(F(" Time(ms):"));    
    //USB.println(millis()-previous); 
  }
  else
  {
    //USB.print(F("WiFi is connected ERROR")); 
    //USB.print(F(" Time(ms):"));    
    //USB.println(millis()-previous);  
  }

  ///////////////////////////////
    // 3.2. Send Frame to Meshlium
    ///////////////////////////////
    // http frame
    error = WIFI_PRO.sendFrameToMeshlium( type, host, port, frame.buffer, frame.length);
    // check response
    if (error == 0){
      //USB.println(F("HTTP OK"));          
      //USB.print(F("HTTP Time from OFF state (ms):"));    
      //USB.println(millis()-previous);
    }
    else
    {
      //USB.println(F("Error calling 'getURL' function"));
      WIFI_PRO.printErrorCode();
    }

  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  //WIFI_PRO.OFF(socket);
  //USB.println(F("WiFi switched OFF\n\n")); 
 // PWR.delay(300000);
}







