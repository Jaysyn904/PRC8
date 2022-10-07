//::///////////////////////////////////////////////////
//:: X0_S1_PETRGAZE
//:: Petrification touch attack monster ability.
//:: Fortitude save (DC 15) or be turned to stone permanently.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    int nHitDice = GetHitDice(oTarget);

    PRCDoPetrification(nHitDice, OBJECT_SELF, oTarget, GetSpellId(), 15);
}

