//::///////////////////////////////////////////////
//:: Fire Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fire Shield for the Disciple of Mephistopheles
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue
#include "prc_class_const"
#include "x2_inc_spellhook"
#include "prc_inc_core"
void main()
{
    int nLevel = 15;
    int nDC    =  0; 
    DoRacialSLA(SPELL_ELEMENTAL_SHIELD, nLevel, nDC);
}

