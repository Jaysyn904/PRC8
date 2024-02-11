//::///////////////////////////////////////////////
//:: Elemental Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 50% cold and fire immunity.  Also anyone
    who strikes the caster with melee attacks takes
    1d6 + 1 per caster level in damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"  
//:: left the immunities as 50% cold and fire,  not variable.



void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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
    effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMetaMagic = PRCGetMetaMagicFeat();
    object oTarget = OBJECT_SELF;
    effect eShield = EffectDamageShield(nDuration, DAMAGE_BONUS_1d6, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE));
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCold = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
    effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eCold);
    eLink = EffectLinkEffects(eLink, eFire);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));

    //  *GZ: No longer stack this spell
    if (GetHasSpellEffect(GetSpellId(),oTarget))
    {
         PRCRemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
    }

    //Enter Metamagic conditions
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

