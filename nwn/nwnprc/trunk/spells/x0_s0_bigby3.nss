//::///////////////////////////////////////////////
//:: Bigby's Grasping Hand
//:: [x0_s0_bigby3]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    make an attack roll. If succesful target is held for 1 round/level


*/

//
// Altered to calculate grapple check correctly per pnp rules.
//

//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_combmove"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

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
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nClassType = PRCGetLastSpellCastClass();
    int nDuration = CasterLvl;
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    //Check for metamagic extend
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 461, TRUE));

        // Check spell resistance
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl+ SPGetPenetr()))
        {
            // Check caster ability vs. target's AC

            int nCasterModifier = (GetAbilityScoreForClass(nClassType, OBJECT_SELF) -10)/2;
            int nCasterRoll = d20(1)
                + nCasterModifier
                + CasterLvl + 10 + -1;

            int nTargetRoll = GetAC(oTarget);

            // Give the caster feedback about the grapple check if he is a PC.
            if (GetIsPC(OBJECT_SELF))
            {
                SendMessageToPC(OBJECT_SELF, nCasterRoll >= nTargetRoll ?
                    "Bigby's Grasping Hand hit" : "Bigby's Grasping Hand missed");
            }

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check to
                // * hold target for duration of spell
                // * check caster ability vs. target's size & strength
                nCasterRoll = d20(1) + nCasterModifier
                    + CasterLvl
                    + 10 + 4;

                int nAttackerGrappleMod = nCasterModifier
                    + CasterLvl
                    + 10 + 4;
                int nGrapple = _DoGrappleCheck(OBJECT_INVALID, oTarget, nAttackerGrappleMod);
                if (nGrapple)
                {
                    // Hold the target paralyzed
                    effect eKnockdown = EffectParalyze();
                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
                    effect eLink = EffectLinkEffects(eKnockdown, eDur);
                    eLink = EffectLinkEffects(eHand, eLink);
                    eLink = EffectLinkEffects(eVis, eLink);
                    if (GetIsImmune(oTarget, EFFECT_TYPE_PARALYZE) == FALSE)
                    {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                            eLink, oTarget,
                                            RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);

    //                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
    //                                        eVis, oTarget,RoundsToSeconds(nDuration));
                        FloatingTextStrRefOnCreature(2478, OBJECT_SELF);
                    }
                }
                else
                {
                    FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
                }
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}


