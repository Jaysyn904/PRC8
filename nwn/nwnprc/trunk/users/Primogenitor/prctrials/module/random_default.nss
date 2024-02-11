#include "prc_gateway"
#include "random_inc"

void main()
{
    int nValue = GetLocalInt(OBJECT_SELF, RANDOM_2DA_SEED);
    int nOriginalValue = nValue;
    int nLevel = GetLocalInt(OBJECT_SELF, "Random_Default_Level");
    object oObject = GetLocalObject(OBJECT_SELF, "Random_Default_Object");
    /*
    if(nValue >= 10000 && nValue < 11000)
    {
        //narrowband 2-sided at level;
        //   0  25  50  75 100  75  50  25   0
        //nValue = 100-(25*abs(nLevel-(nValue-1000)));
        //DoDebug("nValue = "+IntToString(nValue));
        int nTemp = nValue-10000;
        //DoDebug("nTemp = "+IntToString(nTemp));
        nTemp = nLevel-nTemp;
        //DoDebug("nTemp = "+IntToString(nTemp));
        nTemp = abs(nTemp);
        //DoDebug("nTemp = "+IntToString(nTemp));
        nTemp = 25*nTemp;
        //DoDebug("nTemp = "+IntToString(nTemp));
        nValue = 100-nTemp;
        //DoDebug("nValue = "+IntToString(nValue));
    }    
    else if(nValue >= 11000 && nValue < 12000)
        //broadband 2-sided at level;
        //   0  10  20  30  40  50  60  70   80  90 100  90  80  70  60  50  40  30  20  10  0
        //nValue = 100-(10*abs(nLevel-(nValue-1100)));
    {
        //narrowband 2-sided at level;
        //   0  25  50  75 100  75  50  25   0
        //DoDebug("nValue = "+IntToString(nValue));
        int nTemp = nValue-11000;
        //DoDebug("nTemp = "+IntToString(nTemp));
        nTemp = nLevel-nTemp;
        //DoDebug("nTemp = "+IntToString(nTemp));
        nTemp = abs(nTemp);
        //DoDebug("nTemp = "+IntToString(nTemp));
        nTemp = 10*nTemp;
        //DoDebug("nTemp = "+IntToString(nTemp));
        nValue = 100-nTemp;
        //DoDebug("nValue = "+IntToString(nValue));
    }    
    */            
    if(nValue >= 100000 && nValue < 1000000)
    {
//((sin((1-(ABS(offset-A16)/(width*0.5)))*pi()*0.5)*100)*0.5)+50
        int nTemp  =          nValue %  1000;
        int nWidth = (nValue-100000) /  1000;
        if(nLevel < nTemp-nWidth)
            nValue = 0;
        else if(nLevel > nTemp+nWidth)
            nValue = 0;
        else
        {
            float fTemp;
            fTemp = IntToFloat(nTemp-nLevel);
            fTemp = fabs(fTemp);
            fTemp = (fTemp/IntToFloat(nWidth))/0.5;
            fTemp = 1.0-fTemp;
            //fTemp = fTemp*PI*0.5;
            fTemp = fTemp*90;
            fTemp = sin(fTemp);
            fTemp = fTemp* 100.0;
            fTemp = fTemp*   0.5;
            fTemp = fTemp+  50.0; 
            nTemp = FloatToInt(fTemp);
            nValue = nTemp;
            if(nValue < 1)
                nValue = 1;
            
        }    
//DoDebug("random_default nOriginalValue="+IntToString(nOriginalValue)+" nValue="+IntToString(nValue)+" nTemp="+IntToString(nTemp)+" nWidth="+IntToString(nWidth));
    }  
    else if(nValue >= 1000 && nValue < 1100)
    {  
        //narrowband 1-sided at level;
        //   100 100 100 100  75  50  25   0
        nValue = nValue-1000;
        if(nLevel < nValue)
            nValue = 100;
        else    
            nValue = 100-(25*abs(nLevel-nValue));
    }
    else if(nValue >= 1100 && nValue < 1200)
    {  
        //wideband 1-sided at level;
        //   100 100 100 100  90  80  70  60  50  40  30  20  10  0
        nValue = nValue-1100;
        if(nLevel < nValue)
            nValue = 100;
        else    
            nValue = 100-(10*abs(nLevel-nValue));
    }
    else if(nValue >= 1200 && nValue < 1300)
    {
        //greater than level
        if(nLevel >  (nValue-1200)) nValue = 100; else nValue = 0;
    }    
    else if(nValue >= 1300 && nValue < 1400)
    {
        //less than level
        if(nLevel <  (nValue-1300)) nValue = 100; else nValue = 0;
    }    
    else if(nValue == 1500)
    {
        //is epic
        if(nLevel > 20)
            nValue = 100;
        else
            nValue = 0;
    }        
    else if(nValue == 1501)
    {
        //is not epic
        if(nLevel > 20)
            nValue = 0;
        else
            nValue = 100;
    }        
    else if(nValue >= 1600 && nValue < 1650)
        //fire once in this script for self
    {
        if(GetIsResultRun())
        {
            SetLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue), TRUE);
            DelayCommand(0.0,
                DeleteLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue)));
        }
        if(GetLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue)))
            nValue = 0;
        else
            nValue = 100;
    }
    else if(nValue >= 1650 && nValue < 1700)
        //fire once within 10 seconds for self
    {
        if(GetIsResultRun())
        {
            SetLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue), TRUE);
            DelayCommand(10.0,
                DeleteLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue)));
        }
        if(GetLocalInt(OBJECT_SELF, "random_oneshot_"+IntToString(nValue)))
            nValue = 0;
        else
            nValue = 100;
    }
    else if(nValue >= 1700 && nValue < 1750)
        //fire once in this script for mod
    {
        if(GetIsResultRun())
        {
            SetLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue), TRUE);
            AssignCommand(GetModule(),
                DeleteLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue)));
        }
        if(GetLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue)))
            nValue = 0;
        else
            nValue = 100;
    }
    else if(nValue >= 1750 && nValue < 1800)
        //fire once within 10 seconds for mod
    {
        if(GetIsResultRun())
        {
            SetLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue), TRUE);
            AssignCommand(GetModule(),
                DelayCommand(10.0,
                    DeleteLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue))));
        }
        if(GetLocalInt(GetModule(), "random_oneshot_"+IntToString(nValue)))
            nValue = 0;
        else
            nValue = 100;
    }
    else if(nValue >= 1800 && nValue < 2000)
    {
        //spare for future use
        nValue = 0;
    }
    else if(nValue >= 2000 && nValue < 2300)
    {
        //split items by base item type
        if(GetObjectType(oObject) != OBJECT_TYPE_ITEM)        
            nValue = 0;
        else
        {
            int nType = GetBaseItemType(oObject)+2000;
            if(nType != nValue)
                nValue = 0;
            else
                nValue = 100;
        }
    }    
    else
    {
        //some other value, shouldnt happen
        nValue = 0;
    }
    
    //sanity check
    if(nValue < 0)
        nValue = 0;
    if(nValue > 100)
        nValue = 100;
        
        
    //DoDebug("Firing random_default on "+GetName(OBJECT_SELF)+" with value of "+IntToString(nOriginalValue)+" at level "+IntToString(nLevel)+" returning "+IntToString(nValue));

    
    //store this value for pass-back
    SetLocalInt(OBJECT_SELF, RANDOM_2DA_SEED, nValue);
}
