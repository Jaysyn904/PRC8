/*
   ----------------
   Salamander Charge, Enter

   tob_dw_salchrga.nss
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
////#include "prc_alterations"

void main()
{
    //Declare major variables
    int nDamage;
    effect eDam;
    object oTarget;
    object oInitiator = GetAreaOfEffectCreator();
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    
    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oInitiator))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
            //Roll damage.
            nDamage = d6(6);
            if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (17 + GetAbilityModifier(ABILITY_WISDOM, oInitiator)), SAVING_THROW_TYPE_FIRE);
            if(nDamage > 0)
            {
                // Apply effects to the currently selected target.
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
    }
}
