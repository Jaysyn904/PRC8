/*
   ----------------
   Salamander Charge, Heartbeat

   tob_dw_salchrgb.nss
   ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Salamander Charge

    Desert Wind (Strike) [Fire]
    Level: Swordsage 7
    Prerequisite: Three Desert Wind maneuvers
    Initiation Action: 1 Full-round action
    Range: Personal
    Target: You
    Duration: Instantaneous, see text

    You spin and tumble about the battlefield, a wall of raging flame marking your steps.
    
    You charge your foe. In the space across which you charge, a wall of fire appears, dealing 6d6 damage to all who enter.
    This wall lasts for 5 rounds.
    This is a supernatural maneuver.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_add_spell_dc"

void main()
{
    //Declare major variables
    int nDamage;
    effect eDam;
    object oTarget;
    object oInitiator = GetAreaOfEffectCreator();
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    if (!GetIsObjectValid(oInitiator))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oInitiator))
        {
                //Roll damage.
                nDamage = d6(6);
                if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();

                    // Apply effects to the currently selected target.
                    eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    PRCBonusDamage(oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0,FALSE);
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
