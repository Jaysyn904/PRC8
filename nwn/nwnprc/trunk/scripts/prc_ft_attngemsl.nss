//::///////////////////////////////////////////////
//:: Attune Gem
//::
/*
    Tells the maximum spell level the gem can be used for
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 28, 2007
//:://////////////////////////////////////////////

#include "prc_inc_nwscript"

void main()
{
    object oItem = PRCGetSpellTargetObject();
    int nGold = GetGoldPieceValue(oItem);
    int nLevel = nGold / 50;
    if (nLevel > 9) nLevel = 9;
    FloatingTextStringOnCreature("The maximum attunable spell level is " + IntToString(nLevel), OBJECT_SELF, FALSE);
}