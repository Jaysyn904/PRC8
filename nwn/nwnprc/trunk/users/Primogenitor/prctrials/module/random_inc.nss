const string RANDOM_2DA_SEED = "Random2DASeed";

int GetIsResultRun()
{
    return GetLocalInt(GetModule(), "RandomResultRun");
}

int CheckedStringToInt(string sString)
{
    string sIn = sString;
    string sResult;
    while(GetStringLength(sString))
    {
        string sTest = GetStringLeft(sString, 1);
        if(sTest == "0" || sTest == "1"
            || sTest == "2" || sTest == "3"
            || sTest == "4" || sTest == "5"
            || sTest == "6" || sTest == "7"
            || sTest == "8" || sTest == "9")
            sResult += sTest;
        sString = GetStringRight(sString, GetStringLength(sString)-1);
    }
    int nResult = StringToInt(sResult);
//DoDebug("CheckedStringToInt("+sIn+") = "+sResult);
    return nResult;
}

//s2DA    = 2da file to read from
//sScript = script name to test with
//nSeed   = row to start at
//returns the value from the random row selected
string GetRandomFrom2DA(string s2DA, string sScript = "random_default", int nSeed = 0);

//private function
//sScript = script name to test with
//s2DA    = 2da file to read from
//nRow    = row in 2da file to use
//nColumn = column in 2da file to use
int GetRandomWeight(string sScript, string s2DA, int nRow, int nColumn)
{
    string sWeight = Get2DACache(s2DA, "Random"+IntToString(nColumn)+"Weight", nRow);
    int nWeight = CheckedStringToInt(sWeight);
    if(GetStringLeft(sWeight, 1) == "s")
    {
        SetLocalInt(OBJECT_SELF, RANDOM_2DA_SEED, nWeight);
        ExecuteScript(sScript, OBJECT_SELF);
        nWeight = GetLocalInt(OBJECT_SELF, RANDOM_2DA_SEED);
    }
    
    //sanity checks
    if(nWeight < 0)
        nWeight = 0;
    else if(nWeight > 500)
        nWeight = 500;
    return nWeight;
}

string GetRandomFrom2DA(string s2DA, string sScript = "random_default", int nSeed = 0)
{
    int nRow = nSeed;
    int nOrigRow = nSeed;
    string sReturn;
    string sWeight;
    int nBadRow1, nBadRow2, nBadRow3, nBadRow4, nBadRow5;
    nBadRow1 = -1;
    nBadRow2 = -1;
    nBadRow3 = -1;
    nBadRow4 = -1;
    nBadRow5 = -1;

DoDebug("GetRandomFrom2DA("+s2DA+", "+sScript+", "+IntToString(nSeed)+")");
    while(sReturn == "")
    {
//DoDebug("random_inc line 66");
        string sRandom0, sRandom1, sRandom2, sRandom3,
               sRandom4, sRandom5, sRandom6, sRandom7,
               sRandom8, sRandom9;
        int nRandom0, nRandom1, nRandom2, nRandom3,
            nRandom4, nRandom5, nRandom6, nRandom7,
            nRandom8, nRandom9;
        int nRandom0Weight, nRandom1Weight, nRandom2Weight, nRandom3Weight,
            nRandom4Weight, nRandom5Weight, nRandom6Weight, nRandom7Weight,
            nRandom8Weight, nRandom9Weight;
        int nRandomWeightTotal;
        nRandom0Weight = GetRandomWeight(sScript, s2DA, nRow, 0);
        sRandom0 = Get2DACache(s2DA, "Random0", nRow);
        if(sRandom0 != "")
        {
            nRandom0 = CheckedStringToInt(sRandom0);
            if(nRandom0 == nBadRow1
                || nRandom0 == nBadRow2
                || nRandom0 == nBadRow3
                || nRandom0 == nBadRow4
                || nRandom0 == nBadRow5)
                nRandom1Weight = 0;
            else    
                nRandom1Weight = GetRandomWeight(sScript, s2DA, nRow, 1);
            sRandom1 = Get2DACache(s2DA, "Random1", nRow);
            if(sRandom1 != "")
            {
                nRandom1 = CheckedStringToInt(sRandom1);
                if(nRandom1 == nBadRow1
                    || nRandom1 == nBadRow2
                    || nRandom1 == nBadRow3
                    || nRandom1 == nBadRow4
                    || nRandom1 == nBadRow5)
                    nRandom1Weight = 0;
                else    
                    nRandom1Weight = GetRandomWeight(sScript, s2DA, nRow, 1);
                sRandom2 = Get2DACache(s2DA, "Random2", nRow);
                if(sRandom2 != "")
                {
                    nRandom2 = CheckedStringToInt(sRandom2);
                    if(nRandom2 == nBadRow1
                        || nRandom2 == nBadRow2
                        || nRandom2 == nBadRow3
                        || nRandom2 == nBadRow4
                        || nRandom2 == nBadRow5)
                        nRandom2Weight = 0;
                    else    
                        nRandom2Weight = GetRandomWeight(sScript, s2DA, nRow, 2);
                    sRandom3 = Get2DACache(s2DA, "Random3", nRow);
                    if(sRandom3 != "")
                    {
                        nRandom3 = CheckedStringToInt(sRandom3);
                        if(nRandom3 == nBadRow1
                            || nRandom3 == nBadRow2
                            || nRandom3 == nBadRow3
                            || nRandom3 == nBadRow4
                            || nRandom3 == nBadRow5)
                            nRandom3Weight = 0;
                        else    
                            nRandom3Weight = GetRandomWeight(sScript, s2DA, nRow, 3);
                        sRandom4 = Get2DACache(s2DA, "Random4", nRow);
                        if(sRandom4 != "")
                        {
                            nRandom4 = CheckedStringToInt(sRandom4);
                            if(nRandom4 == nBadRow1
                                || nRandom4 == nBadRow2
                                || nRandom4 == nBadRow3
                                || nRandom4 == nBadRow4
                                || nRandom4 == nBadRow5)
                                nRandom4Weight = 0;
                            else    
                                nRandom4Weight = GetRandomWeight(sScript, s2DA, nRow, 4);
                            sRandom5 = Get2DACache(s2DA, "Random5", nRow);
                            if(sRandom5 != "")
                            {
                                nRandom5 = CheckedStringToInt(sRandom5);
                                if(nRandom5 == nBadRow1
                                    || nRandom5 == nBadRow2
                                    || nRandom5 == nBadRow3
                                    || nRandom5 == nBadRow4
                                    || nRandom5 == nBadRow5)
                                    nRandom5Weight = 0;
                                else    
                                    nRandom5Weight = GetRandomWeight(sScript, s2DA, nRow, 5);
                                sRandom6 = Get2DACache(s2DA, "Random6", nRow);
                                if(sRandom6 != "")
                                {
                                    nRandom6 = CheckedStringToInt(sRandom6);
                                    if(nRandom6 == nBadRow1
                                        || nRandom6 == nBadRow2
                                        || nRandom6 == nBadRow3
                                        || nRandom6 == nBadRow4
                                        || nRandom6 == nBadRow5)
                                        nRandom6Weight = 0;
                                    else    
                                        nRandom6Weight = GetRandomWeight(sScript, s2DA, nRow, 6);
                                    sRandom7 = Get2DACache(s2DA, "Random7", nRow);
                                    if(sRandom7 != "")
                                    {
                                        nRandom7 = CheckedStringToInt(sRandom7);
                                        if(nRandom7 == nBadRow1
                                            || nRandom7 == nBadRow2
                                            || nRandom7 == nBadRow3
                                            || nRandom7 == nBadRow4
                                            || nRandom7 == nBadRow5)
                                            nRandom7Weight = 0;
                                        else    
                                            nRandom7Weight = GetRandomWeight(sScript, s2DA, nRow, 7);
                                        sRandom8 = Get2DACache(s2DA, "Random8", nRow);
                                        if(sRandom8 != "")
                                        {
                                            nRandom8 = CheckedStringToInt(sRandom8);
                                                if(nRandom8 == nBadRow1
                                                    || nRandom8 == nBadRow2
                                                    || nRandom8 == nBadRow3
                                                    || nRandom8 == nBadRow4
                                                    || nRandom8 == nBadRow5)
                                                    nRandom8Weight = 0;
                                                else    
                                                    nRandom8Weight = GetRandomWeight(sScript, s2DA, nRow, 8);
                                            sRandom9 = Get2DACache(s2DA, "Random9", nRow);
                                            if(sRandom8 != "")
                                            {
                                                nRandom9 = CheckedStringToInt(sRandom9);
                                                if(nRandom9 == nBadRow1
                                                    || nRandom9 == nBadRow2
                                                    || nRandom9 == nBadRow3
                                                    || nRandom9 == nBadRow4
                                                    || nRandom9 == nBadRow5)
                                                    nRandom9Weight = 0;
                                                else    
                                                    nRandom9Weight = GetRandomWeight(sScript, s2DA, nRow, 9);                                                
        }   }   }   }   }   }   }   }   }   }
        //sanity check
        if(sRandom0 == ""
            && sRandom1 == ""
            && sRandom2 == ""
            && sRandom3 == ""
            && sRandom4 == ""
            && sRandom5 == ""
            && sRandom6 == ""
            && sRandom7 == ""
            && sRandom8 == ""
            && sRandom9 == "")
        {   
            DoDebug("GetRandomFrom2DA() sanity check, no valid results: "+s2DA+", "+sScript+", "+IntToString(nSeed)+", "+IntToString(nRow)+", "+IntToString(nOrigRow));    
            if(nBadRow1 == -1)
                nBadRow1 = nRow;
            else if(nBadRow2 == -1)
                nBadRow2 = nRow;
            else if(nBadRow3 == -1)
                nBadRow3 = nRow;
            else if(nBadRow4 == -1)
                nBadRow4 = nRow;
            else if(nBadRow5 == -1)
                nBadRow5 = nRow;
            nRow = nOrigRow;
            if(nRow == nSeed)
                return "";
            nOrigRow = nSeed;
        }    
        else if(nRandom0Weight == 0
            && nRandom1Weight == 0
            && nRandom2Weight == 0
            && nRandom3Weight == 0
            && nRandom4Weight == 0
            && nRandom5Weight == 0
            && nRandom6Weight == 0
            && nRandom7Weight == 0
            && nRandom8Weight == 0
            && nRandom9Weight == 0)
        {   
            DoDebug("GetRandomFrom2DA() sanity check, no valid weights: "+s2DA+", "+sScript+", "+IntToString(nSeed)+", "+IntToString(nRow)+", "+IntToString(nOrigRow));       
            if(nBadRow1 == -1)
                nBadRow1 = nRow;
            else if(nBadRow2 == -1)
                nBadRow2 = nRow;
            else if(nBadRow3 == -1)
                nBadRow3 = nRow;
            else if(nBadRow4 == -1)
                nBadRow4 = nRow;
            else if(nBadRow5 == -1)
                nBadRow5 = nRow;
            nRow = nOrigRow;
            if(nRow == nSeed)
                return "";
            nOrigRow = nSeed;    
        } 
        else 
        {
            nOrigRow = nRow;
            
            nRandomWeightTotal += nRandom0Weight;
            nRandomWeightTotal += nRandom1Weight;
            nRandomWeightTotal += nRandom2Weight;
            nRandomWeightTotal += nRandom3Weight;
            nRandomWeightTotal += nRandom4Weight;
            nRandomWeightTotal += nRandom5Weight;
            nRandomWeightTotal += nRandom6Weight;
            nRandomWeightTotal += nRandom7Weight;
            nRandomWeightTotal += nRandom8Weight;
            nRandomWeightTotal += nRandom9Weight;
            //get a random point in that weight
            int nRandomWeight = Random(nRandomWeightTotal);//RandomI(nRandomWeightTotal);
//DoDebug("nRandomWeightTotal="+IntToString(nRandomWeightTotal)+" nRandomWeight"+IntToString(nRandomWeight));        
            //keep adding up untill you reach the point picked
            if(nRandomWeight < nRandom0Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 0);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom0, 1) == "r")
                    sReturn = sRandom0;
                nRow = nRandom0;
            }
            else if(nRandomWeight < nRandom0Weight+nRandom1Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 1);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom1, 1) == "r")
                    sReturn = sRandom1;
                nRow = nRandom1;
            }
            else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 2);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom2, 1) == "r")
                    sReturn = sRandom2;
                nRow = nRandom2;
            }
            else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 3);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom3, 1) == "r")
                    sReturn = sRandom3;
                nRow = nRandom3;
            }
            else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 4);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom4, 1) == "r")
                    sReturn = sRandom4;
                nRow = nRandom4;
            }
            else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight+nRandom5Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 5);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom5, 1) == "r")
                    sReturn = sRandom5;
                nRow = nRandom5;
            }
            else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight+nRandom5Weight+nRandom6Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 6);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom6, 1) == "r")
                    sReturn = sRandom6;
                nRow = nRandom6;
            }
            else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight+nRandom5Weight+nRandom6Weight+nRandom7Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 7);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom7, 1) == "r")
                    sReturn = sRandom7;
                nRow = nRandom7;
            }
            else if(nRandomWeight < nRandom0Weight+nRandom1Weight+nRandom2Weight+nRandom3Weight+nRandom4Weight+nRandom5Weight+nRandom6Weight+nRandom7Weight+nRandom8Weight)
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 8);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom8, 1) == "r")
                    sReturn = sRandom8;
                nRow = nRandom8;
            }
            else
            {
                SetLocalInt(GetModule(), "RandomResultRun", TRUE);
                GetRandomWeight(sScript, s2DA, nRow, 9);
                DeleteLocalInt(GetModule(), "RandomResultRun");
                if(GetStringLeft(sRandom9, 1) == "r")
                    sReturn = sRandom9;
                nRow = nRandom9;
            }
        }
/*        
DoDebug("GetRandomFrom2DA("+s2DA+", "+sScript+", "+IntToString(nSeed)+") nRow is now "+IntToString(nRow)+" from "+IntToString(nOrigRow));
if(nRandom0Weight > 0) DoDebug("0 weight: "+IntToString(nRandom0Weight)+" row: "+IntToString(nRandom0));
if(nRandom1Weight > 0) DoDebug("1 weight: "+IntToString(nRandom1Weight)+" row: "+IntToString(nRandom1));
if(nRandom2Weight > 0) DoDebug("2 weight: "+IntToString(nRandom2Weight)+" row: "+IntToString(nRandom2));
if(nRandom3Weight > 0) DoDebug("3 weight: "+IntToString(nRandom3Weight)+" row: "+IntToString(nRandom3));
if(nRandom4Weight > 0) DoDebug("4 weight: "+IntToString(nRandom4Weight)+" row: "+IntToString(nRandom4));
if(nRandom5Weight > 0) DoDebug("5 weight: "+IntToString(nRandom5Weight)+" row: "+IntToString(nRandom5));
if(nRandom6Weight > 0) DoDebug("6 weight: "+IntToString(nRandom6Weight)+" row: "+IntToString(nRandom6));
if(nRandom7Weight > 0) DoDebug("7 weight: "+IntToString(nRandom7Weight)+" row: "+IntToString(nRandom7));
if(nRandom8Weight > 0) DoDebug("8 weight: "+IntToString(nRandom8Weight)+" row: "+IntToString(nRandom8));
if(nRandom9Weight > 0) DoDebug("9 weight: "+IntToString(nRandom9Weight)+" row: "+IntToString(nRandom9));
*/       


    }
    if(GetStringLeft(sReturn, 1) == "r")
        sReturn = GetStringRight(sReturn, GetStringLength(sReturn)-1);
//DoDebug("returning "+sReturn);
    return sReturn;
}
