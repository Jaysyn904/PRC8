//::///////////////////////////////////////////////
//:: Wail of the Banshee
//:: NW_S0_WailBansh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  You emit a terrible scream that kills enemy creatures who hear it
  The spell affects up to one creature per caster level. Creatures
  closest to the point of origin are affected first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"




void main()
{
 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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


    //Declare major variables
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);

    int nToAffect = nCasterLevel;

    object oTarget;
    float fTargetDistance;
    float fDelay;
    location lTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eWail = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
    int nCnt = 1;

    nCasterLevel +=SPGetPenetr();

    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWail, PRCGetSpellTargetLocation());
    //Get the closet target from the spell target location
    oTarget = PRCGetSpellTargetObject(); // direct target
    if (!GetIsObjectValid(oTarget) || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
      oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, PRCGetSpellTargetLocation(), nCnt);
    while (nCnt < nToAffect)
    {
        lTarget = GetLocation(oTarget);
        //Get the distance of the target from the center of the effect
        fDelay = PRCGetRandomDelay(3.0, 4.0);//
        fTargetDistance = GetDistanceBetweenLocations(PRCGetSpellTargetLocation(), lTarget);
        //Check that the current target is valid and closer than 10.0m
        if(GetIsObjectValid(oTarget) && fTargetDistance <= 10.0)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE));
                //Make SR check
                if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLevel)) //, 0.1))
                {
                    int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                    //Make a fortitude save to avoid death
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (nDC), SAVING_THROW_TYPE_DEATH)) //, OBJECT_SELF, 3.0))
                    {
                        DeathlessFrenzyCheck(oTarget);

                        //Apply the delay VFX impact and death effect
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        effect eDeath = EffectDeath();
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget)); // no delay
                    }
                }
            }
        }
        else
        {
            //Kick out of the loop
            nCnt = nToAffect;
        }
        //Increment the count of creatures targeted
        nCnt++;
        //Get the next closest target in the spell target location.
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, PRCGetSpellTargetLocation(), nCnt);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
