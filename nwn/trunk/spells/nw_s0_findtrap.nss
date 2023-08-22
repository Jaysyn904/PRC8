//::///////////////////////////////////////////////
//:: Find Traps
//:: NW_S0_FindTrap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Divination
Level:        Clr 2
Components:   V, S
Casting Time: 1 standard action
Range:        Personal
Target        You
Duration:     1 min./level

You gain intuitive insight into the workings of
traps. You can use the Search skill to detect
traps just as a rogue can. In addition, you gain
an insight bonus equal to one-half your caster
level (maximum +10) on Search checks made to find
traps while the spell is in effect.

Note that find traps grants no ability to disable
the traps that you may find.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_DIVINATION);

    object oCaster = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
    int nCnt = 1;
    object oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, oCaster, nCnt);
    while(GetIsObjectValid(oTrap) && GetDistanceToObject(oTrap) <= 30.0)
    {
        if(GetIsTrapped(oTrap))
        {
            SetTrapDetectedBy(oTrap, oCaster);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTrap));
            if(!GetPRCSwitch(PRC_PNP_FIND_TRAPS))
                DelayCommand(2.0, SetTrapDisabled(oTrap));
        }
        nCnt++;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, oCaster, nCnt);
    }

    PRCSetSchool();
}