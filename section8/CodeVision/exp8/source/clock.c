


#include "./source/headers.h"
#include "./source/clock.h"


//global variable

float status_degree;

//function definition

void Draw_clock_hand(int xcoordinate,int ycoordinate)
{
    glcd_line(64,32,xcoordinate,ycoordinate);
    delay_us(10);
}

float degree_to_radian(float degree)
{
    float radian;
    radian=(degree*(0.0174));
    return radian;
}


int min_x_coordinate_finder(unsigned int min,unsigned int radius,float degree)
{
    int xcoordinate,intermediate;
    float actualdegree;
    float radian;
    actualdegree= (90-(degree*min));
    status_degree=actualdegree;
    radian= degree_to_radian(actualdegree);
    intermediate= radius*(cos(radian));
    xcoordinate= (64+intermediate);
    return xcoordinate;
}


int min_y_coordinate_finder(unsigned int min,unsigned int radius,float degree)
{
    int ycoordinate,intermediate;
    float actualdegree;
    float radian;
    actualdegree= (90-(degree*min));
    status_degree=actualdegree;
    radian= degree_to_radian(actualdegree);
    intermediate= radius*(sin(radian));
    ycoordinate= (32-intermediate);
    return ycoordinate;
}

int sec_x_coordinate_finder(unsigned int sec,unsigned int radius,float degree)
{
    int ycoordinate,intermediate;
    float actualdegree;
    float radian;
    actualdegree= (90-(degree*sec));
    radian= degree_to_radian(actualdegree);
    intermediate= radius*(cos(radian));
    ycoordinate= (64+intermediate);
    return ycoordinate;
}

int sec_y_coordinate_finder(unsigned int sec,unsigned int radius,float degree)
{
    int ycoordinate,intermediate;
    float actualdegree;
    float radian;
    actualdegree= (90-(degree*sec));
    radian= degree_to_radian(actualdegree);
    intermediate= radius*(sin(radian));
    ycoordinate= (32-intermediate);
    return ycoordinate;
}

int hr_x_coordinate_finder(unsigned int hr,unsigned int radius,float degree)
{
    int xcoordinate,intermediate;
    float actualdegree;
    float radian;
    actualdegree= (90-(degree*hr));
    actualdegree= (actualdegree-((90-status_degree)/12));
    radian= degree_to_radian(actualdegree);
    intermediate= radius*(cos(radian));
    xcoordinate= (64+intermediate);
    return xcoordinate;
}

int hr_y_coordinate_finder(unsigned int hr,unsigned int radius,float degree)
{
    int ycoordinate,intermediate;
    float actualdegree;
    float radian;
    actualdegree= (90-(degree*hr));
    actualdegree= (actualdegree-((90-status_degree)/12));
    radian= degree_to_radian(actualdegree);
    intermediate= radius*(sin(radian));
    ycoordinate= (32-intermediate);
    return ycoordinate;
}





void Draw_clock(unsigned int hr,unsigned int min,unsigned int sec)
{
    
    int hr_x_coordinate,hr_y_coordinate,min_x_coordinate,min_y_coordinate,sec_x_coordinate,sec_y_coordinate;
    
    if(hr>=12 && hr<=24) hr=hr-12;
    
    
        
    if(sec==60)
    {
        sec=0;
        min=min+1;
        if(min==60)
        {
            min=0;
            
            hr=hr+1;            
        }
    }
    
    glcd_circle(64,32,30);
    
    hr_x_coordinate= hr_x_coordinate_finder(hr,HR_RADIUS,30);
    hr_y_coordinate= hr_y_coordinate_finder(hr,HR_RADIUS,30);
    Draw_clock_hand(hr_x_coordinate,hr_y_coordinate);
    
    delay_us(5);
    min_x_coordinate=min_x_coordinate_finder(min,MIN_RADIUS,6);
    min_y_coordinate=min_y_coordinate_finder(min,MIN_RADIUS,6);
    Draw_clock_hand(min_x_coordinate,min_y_coordinate);
    
    delay_us(5);
    sec_x_coordinate=sec_x_coordinate_finder(sec,SEC_RADIUS,6);
    sec_y_coordinate=sec_y_coordinate_finder(sec,SEC_RADIUS,6);
    Draw_clock_hand(sec_x_coordinate,sec_y_coordinate);
    //glcd_clear();
}
