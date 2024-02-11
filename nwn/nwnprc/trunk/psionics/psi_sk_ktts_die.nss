//::///////////////////////////////////////////////
//:: Soulknife: Knife To The Soul - dice used
//:: psi_sk_ktts_die
//::///////////////////////////////////////////////
/*
    Sets the number of dice from next Psychic Strike
    enabled hit will be converted to ability damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "prc_alterations"


//////////////////////////////////////////////////
/* Local constants                              */
//////////////////////////////////////////////////

const int FIRST_RADIAL_START  = 2416;
const int SECOND_RADIAL_START = 2422;
const int STRREF_START        = 16824478;

void main()
{
    object oPC = OBJECT_SELF;
    int nID = GetSpellId();
    int nDice;
    //SendMessageToPC(oPC, "psi_sk_ktts_die running");

    if(nID > SECOND_RADIAL_START)
        nDice = 5 + nID - SECOND_RADIAL_START;
    else
        nDice = nID - FIRST_RADIAL_START;

    if(DEBUG) if(nDice < 1 || nDice > 10)
        DoDebug("Invalid SpellId in psi_sk_ktts_die", oPC);


    SetLocalInt(oPC, KTTS,
                GetLocalInt(oPC, KTTS) & KTTS_TYPE_MASK // Use the mask to remove the old die selection
                | (nDice << 2) // Shift the dice number right by 2 and OR it in
               );

    SendMessageToPC(oPC, GetStringByStrRef(16824515) + " " + GetStringByStrRef(STRREF_START + nDice - 1));
}