//::///////////////////////////////////////////////
//:: Name      Fire in the Blood
//:: FileName  sp_fire_blood.nss
//:://////////////////////////////////////////////
/**@file Fire in the Blood
Necromancy
Level: Clr 5
Components: V, S, M
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 Minute/level

You deal 4d6 damage to any enemy who strikes you in melee.

**/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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
    object oTarget = PRCGetSpellTargetObject();

    int nDuration = PRCGetCasterLevel(oTarget);
    int nMetaMagic = PRCGetMetaMagicFeat();

    effect eShield = EffectDamageShield(0, DAMAGE_BONUS_2d12, DAMAGE_TYPE_MAGICAL);
    effect eDur = EffectVisualEffect(463);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Stacking Spellpass, 2003-07-07, Georg
    PRCRemoveEffectsFromSpell(oTarget, GetSpellId());

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, nDuration * 60.0);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

