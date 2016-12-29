/*
NOTE : See Number of Texts + Moods.xlsx Sheet 2
for data breakdown and mapping.
*/
PImage mapImage;                  //Image storing
Table locationTable; 
int rowCount;
int noc = 4;                      //No. of columns = 4 (in datatable)
Table dataTable;                  //Moods table
float dataMin = MAX_FLOAT;        //Circle size range (biggest value = 40), calculated later
float dataMax = MIN_FLOAT;        //Circle size range (smallest value = 10)

void setup() 
{
  size(1459, 562);
  mapImage = loadImage("map.png");
  locationTable = new Table("locations.tsv");
  rowCount = locationTable.getRowCount( );           //get the row numbers from the table i.e. 8
  
  // Read the data table.
  dataTable = new Table("moods.tsv");                //table with multiple columns
  
  // Find the minimum and maximum values from all columns of data table
  for (int row = 0; row < rowCount; row++)           //two for loops, columns & rows
  {
    for(int col = 1; col <= noc; col++)
    {
      float value = dataTable.getFloat(row, col);    //predefined function from the "moods" table
  // Finding the max. and min. values from the moods table.
      if (value > dataMax) 
      {
        dataMax = value;                             
      }
      if (value < dataMin) 
      {
        dataMin = value;
      }
    }  
  }
}
 
void draw( ) 
{
  background(255);            
  image(mapImage, 0, 0);
  smooth( );
  noStroke( );
  
  //Specifies x and y positions of circles relative to original big circle
  //Defining two arrays. (4 differnt values of xshift and yshift corresponds the dots)
  float[] xshift = {0,80,0,-80};     //radius of big circle of image is 80                                         
  float[] yshift = {-80,0,80,0};
  
  //Specifies colours for each circle [cc = Colour Change]
  float[][] cc = { {0,0,255}, {255,255,0}, {0,255,0}, {255,0,0} }; //Standard RGB colors in {} blue, yellow, green and red.
  
  //Specifies transparency of circles [Value between 0 and 255]
  float alpha = 150;
  
  for (int row = 0; row < rowCount; row++) 
  {
    for(int col = 0;col <noc;col++)
    {
      fill(cc[col][0],cc[col][1],cc[col][2], alpha);               //specifying the color according to array cc.
      String abbrev = dataTable.getRowName(row);                   //taking the coordinates of circle in location table
      float x = locationTable.getFloat(abbrev, 1);
      float y = locationTable.getFloat(abbrev, 2);
      drawData(x + xshift[col], y + yshift[col], abbrev, col+1);   //Function: reading values and drawing circles(left right etc.)
    }
  }
}

// Map the size of the ellipse to the data value
void drawData(float x, float y, String abbrev, int col)            
{
  // Get data value for state
  float value = dataTable.getFloat(abbrev, col);
  // Re-map the value to a number between given range:
  float minRemap = 10;
  float maxRemap = 40;
  float mapped = map(value, dataMin, dataMax, minRemap, maxRemap);
  // Draw an ellipse for this item
  ellipse(x, y, mapped, mapped);
}