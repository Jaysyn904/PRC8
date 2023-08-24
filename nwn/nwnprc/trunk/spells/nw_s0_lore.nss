//::///////////////////////////////////////////////
//:: Legend Lore
//:: NW_S0_Lore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster a boost to Lore skill of 10
    plus 1 / 2 caster levels.  Lasts for 1 Turn per
    caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: 2003-10-29: GZ: Corrected spell target object
//::             so potions work wit henchmen now

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"



void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
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
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nLevel = CasterLvl;
    int nBonus = 10 + (nLevel / 2);
    effect eLore = EffectSkillIncrease(SKILL_LORE, nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eLore, eDur);

    int nMetaMagic = PRCGetMetaMagicFeat();
    //Meta-Magic checks
    if(CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nLevel *= 2;
    }
    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_IDENTIFY, oTarget) || !GetHasSpellEffect(SPELL_LEGEND_LORE, oTarget))
    {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LEGEND_LORE, FALSE));
         //Apply linked and VFX effects
         SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nLevel),TRUE,-1,CasterLvl);
         SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

