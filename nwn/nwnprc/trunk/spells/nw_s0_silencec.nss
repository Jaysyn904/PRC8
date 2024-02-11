//::///////////////////////////////////////////////
//:: Silence: On Enter
//:: NW_S0_SilenceC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    object oCaster = GetAreaOfEffectCreator();
    if(GetIsDead(oCaster) || !GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF, 0.0);
    }

    PRCSetSchool();
}