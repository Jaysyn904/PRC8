//::///////////////////////////////////////////////
//:: Greater Cat's Grace
//:: NW_S0_GrCatGr
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Raises targets Dex by 2d4+1
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"



void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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
    effect eRaise;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nMetaMagic = PRCGetMetaMagicFeat();
    int nRaise = d4(2) + 1;
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_CATS_GRACE, FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic & METAMAGIC_MAXIMIZE)
    {
        nRaise = 9;//Damage is at max
    }
    if (nMetaMagic & METAMAGIC_EMPOWER)
    {
        nRaise = nRaise + (nRaise/2); //Damage/Healing is +50%
    }
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Set Adjust Ability Score effect
    eRaise = EffectAbilityIncrease(ABILITY_DEXTERITY, nRaise);
    effect eLink = EffectLinkEffects(eRaise, eDur);
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
