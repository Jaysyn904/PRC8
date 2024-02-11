//::///////////////////////////////////////////////
//:: Bigby's Crushing Hand
//:: [x0_s0_bigby5]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Similar to Bigby's Grasping Hand.
    If Grapple succesful then will hold the opponent and do 2d6 + 12 points
    of damage EACH round for 1 round/level


   // Mark B's famous advice:
   // Note:  if the target is dead during one of these second-long heartbeats,
   // the DelayCommand doesn't get run again, and the whole package goes away.
   // Do NOT attempt to put more than two parameters on the delay command.  They
   // may all end up on the stack, and that's all bad.  60 x 2 = 120.

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

int nSpellID = 463;
void RunHandImpact(object oTarget, object oCaster)
{

    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (PRCGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }

    int nDam = PRCMaximizeOrEmpower(6,2,PRCGetMetaMagicFeat(), 12);
    nDam += SpellDamagePerDice(oCaster, 2);
    //nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
    effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    PRCBonusDamage(oTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    DelayCommand(6.0f,RunHandImpact(oTarget,oCaster));
}

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

    object oTarget = PRCGetSpellTargetObject();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(462,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nClassType = PRCGetLastSpellCastClass();
    int nAbilityModifier = (GetAbilityScoreForClass(nClassType, OBJECT_SELF) -10)/2;

    int nMetaMagic = PRCGetMetaMagicFeat();

    //Check for metamagic extend
    if ((nMetaMagic & METAMAGIC_EXTEND)) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BIGBYS_CRUSHING_HAND, TRUE));

        //SR
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl+ SPGetPenetr()))
        {
            int nCasterRoll = d20(1)
                + nAbilityModifier
                + CasterLvl + 12 + -1;
            int nTargetRoll = GetAC(oTarget);

           // Give the caster feedback about the grapple check if he is a PC.
           if (GetIsPC(OBJECT_SELF))
           {
                SendMessageToPC(OBJECT_SELF, nCasterRoll >= nTargetRoll ?
                     "Bigby's Crushing Hand hit" : "Bigby's Grasping Hand missed");
           }

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check
                // * hold target for duration of spell

                nCasterRoll = d20(1) + nAbilityModifier
                    +CasterLvl + 12 + 4;

                int nGrapple = _DoGrappleCheck(OBJECT_INVALID, oTarget, nCasterRoll);

                // Give the caster feedback about the grapple check if he is a PC.
                if (GetIsPC(OBJECT_SELF))
                {
                     string suffix = nCasterRoll >= nTargetRoll ? ", success" : ", failure";
                     SendMessageToPC(OBJECT_SELF, "Grapple check " + IntToString(nCasterRoll) +
                          " vs. " + IntToString(nTargetRoll) + suffix);
                }

                if (nGrapple)
                {
                    effect eKnockdown = EffectParalyze();

                    // creatures immune to paralzation are still prevented from moving
                    if (GetIsImmune(oTarget, EFFECT_TYPE_PARALYZE) == FALSE)
                        eKnockdown = EffectCutsceneImmobilize();

                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
                    effect eLink = EffectLinkEffects(eKnockdown, eHand);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                        eLink, oTarget,
                                        RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);

                    object oSelf = OBJECT_SELF;
                    RunHandImpact(oTarget, oSelf);
                    FloatingTextStrRefOnCreature(2478, OBJECT_SELF);

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


