//::///////////////////////////////////////////////
//:: [Dominate Animal]
//:: [NW_S0_DomAn.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"



void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    effect eDom = EffectCutsceneDominated();    // Allows multiple dominated creatures
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eMind, eDom);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nCasterLevel = CasterLvl;
    int nDuration = 3 + nCasterLevel;
    nCasterLevel +=SPGetPenetr();

    int nRacial = MyPRCGetRacialType(oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_ANIMAL, FALSE));
    //Make sure the target is an animal
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        if  ((nRacial == RACIAL_TYPE_ANIMAL))
        {
           //Make SR check
           if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLevel))
           {
                //Will Save for spell negation
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Check for Metamagic extension
                    if ((nMetaMagic & METAMAGIC_EXTEND))
                    {
                        nDuration = nDuration * 2;
                    }
                    // Extra domination immunity check - using EffectCutsceneDominated(), which normally bypasses
                    if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DOMINATE) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                    {
                        //Apply linked effect and VFX impact
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                    }
                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
