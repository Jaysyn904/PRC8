//::///////////////////////////////////////////////
//:: Bigby's Clenched Fist
//:: [x0_s0_bigby4]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does an attack EACH ROUND for 1 round/level.
    If the attack hits does
     1d8 +12 points of damage

    Any creature struck must make a FORT save or
    be stunned for one round.

    GZ, Oct 15 2003:
    Changed how this spell works by adding duration
    tracking based on the VFX added to the character.
    Makes the spell dispellable and solves some other
    issues with wrong spell DCs, checks, etc.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller October 15, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"


#include "prc_add_spell_dc"



int nSpellID = 462;

void RunHandImpact(object oTarget, object oCaster,int CasterLvl, int nAbilityModifier )
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (PRCGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }

    int nCasterModifiers = nAbilityModifier
               + PRCGetCasterLevel(oCaster);
    int nCasterRoll = d20(1) + nCasterModifiers + 11 + -1;
    int nTargetRoll = GetAC(oTarget);
    if (nCasterRoll >= nTargetRoll)
    {
       int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID));

       int nDam  = PRCMaximizeOrEmpower(8, 1, PRCGetMetaMagicFeat(), 11);
       nDam += SpellDamagePerDice(oCaster, 1);
       //nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
       effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING);
       effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

       SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
       PRCBonusDamage(oTarget);
       SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

       if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
       {
           SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(1),TRUE,-1,CasterLvl);
       }

      DelayCommand(6.0f,RunHandImpact(oTarget,oCaster,CasterLvl,nAbilityModifier));

   }
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
    int nClassType = PRCGetLastSpellCastClass();
    int nAbilityModifier = (GetAbilityScoreForClass(nClassType, OBJECT_SELF) -10)/2;

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(463,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;

    int nMetaMagic = PRCGetMetaMagicFeat();
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, TRUE));
        int nResult = PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl +SPGetPenetr());

        if(nResult  == 0)
        {
            effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, oTarget, RoundsToSeconds(nDuration),FALSE);

            //----------------------------------------------------------
            // GZ: 2003-Oct-15
            // Save the current save DC on the character because
            // PRCGetSaveDC won't work when delayed
            //----------------------------------------------------------
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID), PRCGetSaveDC(oTarget, OBJECT_SELF));
            object oSelf = OBJECT_SELF;
            RunHandImpact(oTarget,OBJECT_SELF,CasterLvl, nAbilityModifier);

        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}

