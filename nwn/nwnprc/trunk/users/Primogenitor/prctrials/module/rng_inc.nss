//::///////////////////////////////////////////////
//:: Name               rng_inc
//:: FileName           Random Name Generator
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A set of functions for randon name generation
    and replacements for biowares random number
    generator in scripts (taken from Syrsnein's
    work @ http://nwvault.ign.com/View.php?view=scripts.Detail&id=2931 )

    The random name generator needs 2 2da files
    rng_data.2da:
        MinLetters        Minimum number of letters
        MaxLetters        Maximum number of letters
        NameList          Name of the column in rng_lists.2da
    rng_names.2da:
        "Natural" column, plus others as in rng_data NameList
        Each column is a list of example names for that race to use
        New names are generated letter by letter, based on the relative
        abundance of the letters in the example weighted by up to 4
        previous letters.
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 23/03/06
//:://////////////////////////////////////////////

const int RNG_LINELIMIT = 50;
const string RNG_DEFAULT_COLUMN = "Natural";

string RNG_GetRandomName(int nRacialType = RACIAL_TYPE_INVALID, int nDepth = 2);
string RNG_GetRandomNameForObject(object oObject = OBJECT_SELF);
string RNG_GetRandomLetter(string sNameType = "Natural", string sLastLetter = "",
    string sLast2Letter = "", string sLast3Letter = "", string sLast4Letter = "");


#include "sy_inc_random"


string RNG_GetRandomNameForObject(object oObject = OBJECT_SELF)
{
    return RNG_GetRandomName(GetRacialType(oObject));
}

string RNG_GetRandomName(int nRacialType = RACIAL_TYPE_INVALID, int nDepth = 2)
{
    //default to a random "normal" race name
    if(nRacialType == RACIAL_TYPE_INVALID)
        nRacialType = RandomI(7);
    //get the number of letters to use
    int nMin = StringToInt(Get2DAString("rng_data", "MinLetters", nRacialType));
    int nMax = StringToInt(Get2DAString("rng_data", "MaxLetters", nRacialType));
    int nCount = (RandomI(nMax-nMin)+nMin)*3;
    //get the column to use
    string sColumn = Get2DAString("rng_data", "NameList", nRacialType);
    if(sColumn == "")
        sColumn = RNG_DEFAULT_COLUMN;
    //sanity checks
    if(nCount < 1)
        nCount = 1;
    if(nCount > 10)
        nCount = 10;
    //add letters
    int i;
    string sNewLetter;
    string sOldLetter;
    string sOldLetter2;
    string sOldLetter3;
    string sOldLetter4;
    string sName;
    for(i=0;i<nCount;i++)
    {
        if(nDepth == 4)
            sNewLetter = RNG_GetRandomLetter(sColumn, sOldLetter, sOldLetter2, sOldLetter3, sOldLetter4);
        else if(nDepth == 3)
            sNewLetter = RNG_GetRandomLetter(sColumn, sOldLetter, sOldLetter2, sOldLetter3);
        else if(nDepth == 2)
            sNewLetter = RNG_GetRandomLetter(sColumn, sOldLetter, sOldLetter2);
        else if(nDepth == 1)
            sNewLetter = RNG_GetRandomLetter(sColumn, sOldLetter);
        else if(nDepth == 0)
            sNewLetter = RNG_GetRandomLetter(sColumn);
        sName += sNewLetter;
        sOldLetter4 = sOldLetter3;
        sOldLetter3 = sOldLetter2;
        sOldLetter2 = sOldLetter;
        sOldLetter = sNewLetter;
    }
    //capitalize first letter
    sName = GetStringLowerCase(sName);
    string sInitial = GetStringLeft(sName,1);
    sInitial = GetStringUpperCase(sInitial);
    sName = sInitial+GetStringRight(sName, GetStringLength(sName)-1);
    return sName;
}


string RNG_GetRandomLetter(string sNameType = RNG_DEFAULT_COLUMN, string sLastLetter = "",
    string sLast2Letter = "", string sLast3Letter = "", string sLast4Letter = "")
{
    //do some WP creation/getting stuff here
    object oWP = GetWaypointByTag("rng_wp");
    if(!GetIsObjectValid(oWP))
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation(), FALSE, "rng_wp");
    if(!GetIsObjectValid(oWP))
        DoDebug("Error creating waypoint rng_wp");

    string sVar = "RNG_"+sNameType;
    if(sLastLetter != "")
        sVar += "_"+sLastLetter;
    if(sLast2Letter != "")
        sVar += "_"+sLast2Letter;
    if(sLast3Letter != "")
        sVar += "_"+sLast3Letter;
    if(sLast4Letter != "")
        sVar += "_"+sLast4Letter;
    int nTotal =GetLocalInt(oWP, sVar+"_total");
    //if none exist, retry with smaller combination
    if(!nTotal)
    {
        if(sLastLetter == "")
            return "";
        else if(sLast2Letter == "")
            return RNG_GetRandomLetter(sNameType);
        else if(sLast3Letter == "")
            return RNG_GetRandomLetter(sNameType, sLastLetter);
        else if(sLast4Letter == "")
            return RNG_GetRandomLetter(sNameType, sLastLetter, sLast2Letter);
        else
            return RNG_GetRandomLetter(sNameType, sLastLetter, sLast2Letter, sLast3Letter);
    }
    int nID= RandomI(nTotal);
    string sLetter= GetLocalString(oWP, sVar+"_"+IntToString(nID));
    return sLetter;
}

void RNG_SetupNameListAddLetter(string sCurrLetter, string sVar, object oWP)
{
    //get the letter total
    int nLetterTotal = GetLocalInt(oWP, sVar+"_total");
    //add the letter to the array
    SetLocalString(oWP, sVar+"_"+IntToString(nLetterTotal), sCurrLetter);
    //increase the letter total
    nLetterTotal++;
    SetLocalInt(oWP, sVar+"_total", nLetterTotal);
}


void RNG_SetupNameList(string sNameType = RNG_DEFAULT_COLUMN, int nPos = 0)
{
    //if calling with no name type
    //then loop over the rng_data races
    if(sNameType == "")
    {
        int i;
        for(i=0;i<255;i++)
        {
            string sColumn = Get2DAString("rng_data", "NameList", i);
            if(sColumn == "")
                sColumn = RNG_DEFAULT_COLUMN;
            //make sure you only start it once
            if(!GetLocalInt(GetModule(), sColumn+"_started"))
            {
                SetLocalInt(GetModule(), sColumn+"_started", TRUE);
                DelayCommand(100.0, DeleteLocalInt(GetModule(), sColumn+"_started"));
                DelayCommand(1.0, RNG_SetupNameList(sColumn, 0));
            }
        }
        //dont do anything else
        return;
    }
    //do some WP creation/getting stuff here
    object oWP = GetWaypointByTag("rng_wp");
    if(!GetIsObjectValid(oWP))
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation(), FALSE, "rng_wp");
    if(!GetIsObjectValid(oWP))
        DoDebug("Error creating waypoint rng_wp");
    //dont re-cache stuff accidentaly
    if(GetLocalInt(oWP, "RNG_"+sNameType+"_total")
        && nPos == 0)
        return;
    //loop over the rows
    //keep this low to allow other things to happen as well
    int nRow;
    for(nRow = nPos; nRow < nPos+10; nRow++)
    {
        string sName = Get2DAString("rng_names", sNameType, nRow);
//DoDebug("Looking up line "+sNameType+" : "+IntToString(nRow)+" = "+sName);
        //end of list, abort
        if(sName == "")
            return;
        //to stop this going forever
        if(nRow > RNG_LINELIMIT)
            return;
        string sLast4Letter;
        string sLast3Letter;
        string sLast2Letter;
        string sLastLetter;
        string sCurrLetter;
        int nLetterID;
        //loop over all letters
        for(nLetterID = 0; nLetterID < GetStringLength(sName); nLetterID++)
        {
            string sVar;
            int nLetterTotal;
            //get the letter
            sCurrLetter = GetSubString(sName, nLetterID, 1);

            //do 0-letter lag
            //work out what the var name is
            sVar = "RNG_"+sNameType;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //do 1-letter lag
            //work out what the var name is
            sVar += "_"+sLastLetter;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //do 2-letter lag
            //work out what the var name is
            sVar += "_"+sLast2Letter;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //do 3-letter lag
            //work out what the var name is
            sVar += "_"+sLast3Letter;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //do 4-letter lag
            //work out what the var name is
            sVar += "_"+sLast4Letter;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //move to next letter
            sLast4Letter = sLast3Letter;
            sLast3Letter = sLast2Letter;
            sLast2Letter = sLastLetter;
            sLastLetter = sCurrLetter;
        }
    }
    DelayCommand(1.0, RNG_SetupNameList(sNameType, nRow));
}
