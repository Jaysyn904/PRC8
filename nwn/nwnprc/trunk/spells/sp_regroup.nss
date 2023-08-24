//::///////////////////////////////////////////////
//:: Name      Regroup
//:: FileName  sp_regroup.nss
//:://////////////////////////////////////////////
/**@file Regroup
Conjuration (Teleportation)
Level: Duskblade 3, sorcerer/wizard 3
Components: V,S
Casting Time: 1 standard action
Range: Close
Targets: One willing creature/level
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

Each subject of this spell teleports to a square
adjacent to you.  If those squares are occupied or
cannot support the teleported creatures, the creatures
appear as close to you as possible, on a surface that 
can support them, in an unoccupied square.

**/
////////////////////////////////////////////////////
// Author: Tenjac
// Date:   26.9.06
////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    int nCounter = PRCGetCasterLevel(oPC);
    float fVar = IntToFloat(nCounter/2);
    fVar += 25.0;
    float fSize = FeetToMeters(fVar);
    location lLoc = GetLocation(oPC);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fSize, lLoc, FALSE, OBJECT_TYPE_CREATURE);

    while(nCounter > 0 && GetIsObjectValid(oTarget))
    {
        if(GetIsFriend(oTarget, oPC) && !GetPlotFlag(oTarget) && oTarget != oPC)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oTarget);
            DelayCommand(0.2f, AssignCommand(oTarget, ClearAllActions(TRUE)));
            DelayCommand(0.3f, AssignCommand(oTarget, JumpToObject(oPC)));
            nCounter--;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fSize, lLoc, FALSE, OBJECT_TYPE_CREATURE);
    }
    PRCSetSchool();
}