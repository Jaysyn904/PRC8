//::///////////////////////////////////////////////
//:: One with the Land
//:: x0_s0_oneland.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 bonus +3: animal empathy, move silently, search, hide
 Duration: 1 hour/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 19, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"



#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nMetaMagic = PRCGetMetaMagicFeat();

    effect eSkillAnimal = EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, 4);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, 4);
    effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4);
    effect eSearch = EffectSkillIncrease(SKILL_SET_TRAP, 4);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eSkillAnimal, eMove);
    eLink = EffectLinkEffects(eLink, eHide);
    eLink = EffectLinkEffects(eLink, eSearch);

    eLink = EffectLinkEffects(eLink, eDur);

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl; 
     if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 420, FALSE));
    //Apply VFX impact and bonus effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}





