//::///////////////////////////////////////////////
//:: Name      Bestow Wound
//:: FileName  sp_bestow_wnd.nss
//:://////////////////////////////////////////////
/**@file Bestow Wound
Transmutation
Level: Sor/Wiz 1
Components: V, S, M
Casting Time: 1 action
Range: Touch
Target: Living creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

If the caster is wounded, she can cast this spell and
touch a living creature. The creature takes the caster's
wounds as damage, either 1 point of damage per caster
level or the amount needed to bring the caster up to her
maximum hit points, whichever is less. The caster heals
that much damage, as if a cure spell had been cast on her.

Material Component: A small eye agate worth at least 10 gp.

Author:    Tenjac
Created:   02/05/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    //define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nCasterMaxHP = GetMaxHitPoints(oPC);
    int nCasterCurrentHP = GetCurrentHitPoints(oPC);
    int nDam = PRCMin((nCasterMaxHP - nCasterCurrentHP), nCasterLvl);
    int nDC = PRCGetSaveDC(oTarget, oPC);

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_BESTOW_WOUND, oPC);

    //Check Spell Resistance
    if (PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        return;
    }

    //Resolve Spell if failed save
    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL) && PRCGetIsAliveCreature(oTarget))
    {
        //Target effects
        effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);
        effect eVisDam = EffectVisualEffect(VFX_IMP_HARM);
        effect eLink = EffectLinkEffects(eDam, eVisDam);

        //Caster effects
        effect eHeal = PRCEffectHeal(nDam, oPC);
        effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
        effect eHealLink = EffectLinkEffects(eHeal, eVisHeal);

        //Apply to Target
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

        //Apply to Caster
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealLink, oPC);
    }

    PRCSetSchool();
}