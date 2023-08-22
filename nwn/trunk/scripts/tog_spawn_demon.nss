//::///////////////////////////////////////////////
/*
   Special Spawn in script for Thrall of Graz'zt
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "X0_INC_HENAI"
#include "X2_INC_SUMMSCALE"


int ScaleSummonedDemon(object oDemon)
{ 
    // no master? no levelup!
    if (!GetIsObjectValid(GetMaster(oDemon)))
    {
        SSMSetSummonFailedLevelUp(oDemon, -1);
        return FALSE;
    }

    // chane level to make the demon
    int nLevelTo = GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, GetMaster(oDemon)) + GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, GetMaster(oDemon)); 
    
    if(nLevelTo >= 4  && nLevelTo < 9)       nLevelTo = 5;
    else if(nLevelTo >= 9  && nLevelTo < 15) nLevelTo = 10;
    else if(nLevelTo >= 15 && nLevelTo < 20) nLevelTo = 15;
    else if(nLevelTo >= 20 && nLevelTo < 25) nLevelTo = 20;
    else if(nLevelTo >= 25 && nLevelTo < 30) nLevelTo = 25;
    else if(nLevelTo >= 30 )                 nLevelTo = 30;
    
    int nRet = SSMLevelUpCreature(oDemon, nLevelTo, CLASS_TYPE_INVALID);
    if (nRet == FALSE)
    {
        SSMSetSummonFailedLevelUp(oDemon, nLevelTo);
    }
    
    string sResRef = GetResRef(oDemon);
    if(sResRef == "TOG_GLABREZU") ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectModifyAttacks(2) ), oDemon);
    if(sResRef == "TOG_MARILITH") ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectModifyAttacks(4) ), oDemon);

    return nRet;
}

void DoScaleESL(object oSelf)
{
        // put any summons in here with if/then based on creature tags
        ScaleSummonedDemon(oSelf);
}
void main()
{
    //Sets up the special henchmen listening patterns
    SetAssociateListenPatterns();

    // Set additional henchman listening patterns
    bkSetListeningPatterns();

    // Default behavior for henchmen at start
    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
    SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    SetAssociateState(NW_ASC_DISARM_TRAPS);
    SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);

    //Use melee weapons by default
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // Distance: make henchmen stick closer
    SetAssociateState(NW_ASC_DISTANCE_4_METERS);
    if (GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetMaster()) == OBJECT_SELF) {
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);
    }

    // Set starting location
    SetAssociateStartLocation();

    // GZ 2003-07-25:
    // There is a timing issue with the GetMaster() function not returning the master of a creature
    // immediately after spawn. Some code which might appear to make no sense has been added
    // to the nw_ch_ac1 and x2_inc_summon files to work around this
    // it is also the reason for the delaycommand below:
    object oSelf = OBJECT_SELF;
    DelayCommand(1.0f,DoScaleESL(oSelf));
}


