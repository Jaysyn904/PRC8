//::///////////////////////////////////////////////
//:: Soulknife: Knife To The Soul - damage type
//:: psi_sk_ktts_main
//::///////////////////////////////////////////////
/*
    Sets Knife To The Soul either off, or selects
    the type of ability damage dealt.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


//////////////////////////////////////////////////
/* Local constants                              */
//////////////////////////////////////////////////

const int OFF = 2412;
const int INT = 2413;
const int WIS = 2414;
const int CHA = 2415;

void main()
{   
    object oPC = OBJECT_SELF;
    int nSet;
    int nStrRef;
    //SendMessageToPC(oPC, "psi_sk_ktts_main running");
    
    switch(GetSpellId())
    {
        case OFF:
            nSet = KTTS_TYPE_OFF;
            nStrRef = 62495;
            break;
        case INT:
            nSet = KTTS_TYPE_INT;
            nStrRef = 134;
            break;
        case WIS:
            nSet = KTTS_TYPE_WIS;
            nStrRef = 136;
            break;
        case CHA:
            nSet = KTTS_TYPE_CHA;
            nStrRef = 131;
            break;
        
        default:
            WriteTimestampedLogEntry("Wrong SpellId in psi_sk_ktts_main");
    }
    
    
    SetLocalInt(oPC, KTTS, 
                GetLocalInt(oPC, KTTS) & ~KTTS_TYPE_MASK // Invert the mask and use it to remove the old type selection
                | nSet // OR the new selection in
               );

    SendMessageToPC(oPC, GetStringByStrRef(16824514) + " " + GetStringByStrRef(nStrRef));
}