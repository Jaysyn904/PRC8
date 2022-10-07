#include "prc_inc_switch"

const int PHENOTYPE_KENSAI      = 5;
const int PHENOTYPE_ASSASSIN    = 6;
const int PHENOTYPE_BARBARIAN   = 7;
const int PHENOTYPE_FENCING     = 8;

string sLock = "acp_fightingstyle_lock";

/* This creates a LocalInt - a "lock" - ..we check further down if it exists...
 * if it does, we don't allow phenotype changing. To prevent lag spam. */
void LockThisFeat()
{
    SetLocalInt(OBJECT_SELF, sLock, TRUE);
    float fDelay = IntToFloat(GetPRCSwitch(PRC_ACP_DELAY))*60.0;
    if(fDelay == 0.0)
        fDelay = 90.0;
    if(fDelay == -60.0)
        fDelay = 0.0;
    DelayCommand(fDelay, DeleteLocalInt(OBJECT_SELF, sLock)); //Lock persists 1 min times switchval
}

void ResetFightingStyle() //Resets the character phenotype to 0
{
    int nCurrentPheno = GetPhenoType(OBJECT_SELF);

    //If we are at phenotype 0 or 2, we do nothing. Tell the player that.
    if(nCurrentPheno == PHENOTYPE_NORMAL
    || nCurrentPheno == PHENOTYPE_BIG)
        SendMessageToPC(OBJECT_SELF, "Your fighting style is already neutral.");

    //else if we are at phenotype 5,6,7 or 8 we want to reset it to neutral.
    else if(nCurrentPheno == PHENOTYPE_KENSAI
    || nCurrentPheno == PHENOTYPE_ASSASSIN
    || nCurrentPheno == PHENOTYPE_BARBARIAN
    || nCurrentPheno == PHENOTYPE_FENCING)
    {
        SetPhenoType(PHENOTYPE_NORMAL);
        LockThisFeat(); // Lock use!
    }

    //else, warn that the player doesn't have a phenotype which can be reset right now
    else
        SendMessageToPC(OBJECT_SELF, "Your phenotype is non-standard and cannot be reset this way.");
}

void SetCustomFightingStyle(int iStyle) //Sets character phenotype to 5,6,7 or 8
{
    int nCurrentPheno = GetPhenoType(OBJECT_SELF);

    //Maybe we're already using this fighting style? Just warn the player.
    if(nCurrentPheno == iStyle)
        SendMessageToPC(OBJECT_SELF, "You're already using this fighting style!");

    //If we are at phenotype 0 or one of the styles themselves, we go ahead
    //and set the creature's phenotype accordingly! (safe thanks to previous 'if')
    else if(nCurrentPheno == PHENOTYPE_NORMAL
    || nCurrentPheno == PHENOTYPE_KENSAI
    || nCurrentPheno == PHENOTYPE_ASSASSIN
    || nCurrentPheno == PHENOTYPE_BARBARIAN
    || nCurrentPheno == PHENOTYPE_FENCING)
    {
        SetPhenoType(iStyle);
        LockThisFeat(); // Lock use!
    }

    //At phenotype 2? Tell the player they're too fat!
    else if (nCurrentPheno == PHENOTYPE_BIG)
        SendMessageToPC(OBJECT_SELF, "You're too fat to use a different fighting style!");

    //...we didn't fulfil the above conditions? Warn the player.
    else
        SendMessageToPC(OBJECT_SELF, "Your phenotype is non-standard / Unable to change style");
}

// Test main
//void main(){}
