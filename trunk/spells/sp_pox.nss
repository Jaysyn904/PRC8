//::///////////////////////////////////////////////
//:: Pox
//:: sp_pox.nss
//:://////////////////////////////////////////////
/*
 1d4 Con damage to up to 1 living creature/level in RADIUS_SIZE_SMALL
 Fort save negates.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: December 24, 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    location locTarget = PRCGetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eDam;
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nPenetr = nCasterLvl + SPGetPenetr(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nMax = GetHitDice(OBJECT_SELF);
    int nCount = 0;
    int nDC, nDamage;
    float fDelay;


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, locTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(oTarget != OBJECT_INVALID && nCount <= nMax)
    {
        // GZ: Not much fun if the caster is always killing himself
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POX));
            //Get a random delay
            fDelay = PRCGetRandomDelay(0.5, 1.0);

            //Only living targets
            if(PRCGetIsAliveCreature(oTarget))
            {
                //We have a valid target, increment counter
                nCount++;

                if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr, fDelay))
                {
                    nDC = PRCGetSaveDC(oTarget, OBJECT_SELF);
                    //Roll damage for each target and resolve metamagic
                    nDamage = PRCGetMetaMagicDamage(-1, 1, 4, 0, 0, nMetaMagic);

                    if(/*Fort Save*/ !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                    {
                        //Set the damage effect
                        //eDam = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage);
                        // Apply effects to the currently selected target.
                        //DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget, 0.0f, FALSE, -1, nCasterLvl));
                        DelayCommand(fDelay, ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDamage, DURATION_TYPE_PERMANENT, TRUE, 0.0f, FALSE));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }// end if - fort save
                }// end if - spell resist
            }// end if - is target living
        }// end if - is target non-self and hostile
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, locTarget);
    }// end while - target getting

// Getting rid of the integer used to hold the spells spell school
PRCSetSchool();
}