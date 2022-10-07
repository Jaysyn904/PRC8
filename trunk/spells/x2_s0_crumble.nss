//::///////////////////////////////////////////////
//:: Crumble
//:: X2_S0_Crumble
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// This spell inflicts 1d6 points of damage per
// caster level to Constructs to a maximum of 15d6.
// This spell does not affect living creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 2003/
//:://////////////////////////////////////////////
//
// 2/25/2004 - bleedingedge - Removed SR check per bioware 1.62 change.
//
//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"

#include "prc_alterations"
#include "prc_add_spell_dc"


void DoCrumble (int nDam, object oCaster, object oTarget);

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    // End of Spell Cast Hook

    object oCaster  = OBJECT_SELF;
    object oTarget  = PRCGetSpellTargetObject();
    int  nCasterLvl =PRCGetCasterLevel(oCaster);
    int  nType      = GetObjectType(oTarget);
    int  nRacial    = MyPRCGetRacialType(oTarget);
    int  nMetaMagic = PRCGetMetaMagicFeat();

    //Minimum caster level of 1, maximum of 15.
    if(nCasterLvl == 0)
    {
        nCasterLvl = 1;
    }
    else if (nCasterLvl > 15)
    {
        nCasterLvl = 15;
    }

    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
    effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);

    if (nType != OBJECT_TYPE_CREATURE && nType !=  OBJECT_TYPE_PLACEABLE && nType != OBJECT_TYPE_DOOR )
    {
        return;
    }

    if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT  &&  GetLevelByClass(CLASS_TYPE_CONSTRUCT,oTarget) == 0)
    {
        return;
    }

    int nDam = d6(nCasterLvl);

    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
    {
        nDam = 6*nCasterLvl;
    }

    if ((nMetaMagic & METAMAGIC_EMPOWER))
    {
        nDam = nDam + nDam/2;
    }
    nDam += SpellDamagePerDice(oCaster, nCasterLvl);

    if (nDam>0)
    {
        //----------------------------------------------------------------------
        // * Sever the tie between spellId and effect, allowing it to
        // * bypass any magic resistance
        //----------------------------------------------------------------------
        DelayCommand(0.1f,DoCrumble(nDam, oCaster, oTarget));
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

//------------------------------------------------------------------------------
// This part is moved into a delayed function in order to alllow it to bypass
// Golem Spell Immunity. Magic works by rendering all effects applied
// from within a spellscript useless. Delaying the creation and application of
// an effect causes it to loose it's SpellId, making it possible to ignore
// Magic Immunity. Hacktastic!
//------------------------------------------------------------------------------
void DoCrumble (int nDam, object oCaster, object oTarget)
{
    float  fDist = GetDistanceBetween(oCaster, oTarget);
    float  fDelay = fDist/(3.0 * log(fDist) + 2.0);
    effect eDam = PRCEffectDamage(oTarget, nDam, ChangedElementalDamage(oCaster, DAMAGE_TYPE_SONIC));
    effect eMissile = EffectVisualEffect(477);
    effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eVis = EffectVisualEffect(135);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);
    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    DelayCommand(0.5f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
}
