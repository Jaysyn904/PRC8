//::///////////////////////////////////////////////
//:: Name      Crushing Despair
//:: FileName  sp_crsh_despair.nss
//:://////////////////////////////////////////////
/**@file Crushing Despair
Enchantment (Compulsion) [Mind-Affecting]
Level: Brd 3, Wiz 4
Components: V, S, M
Casting Time: 1 standard action
Range: 30 ft.
Area: Cone
Duration: 1 min./level
Saving Throw: Will negates
Spell Resistance: Yes

A cone of despair causes great sadness in the subjects. Each affected creature takes a –2 penalty on attack rolls, saving throws, ability checks, skill checks, and weapon damage rolls. 

Author:    Stratovarius
Created:   5/17/2009
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    object oCaster = OBJECT_SELF;

    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
    if(!X2PreSpellCastCode())
    {
        PRCSetSchool();
        return;
    }

    location lTarget = PRCGetSpellTargetLocation();
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE,
        FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nPenalty = 2;
    float fDuration = MinutesToSeconds(nCasterLevel);

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2.0f;

    effect eVisual = EffectVisualEffect(VFX_DUR_GLOW_BLUE);
    effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
    eLink = EffectLinkEffects(eLink,
        EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty,
            SAVING_THROW_TYPE_ALL));
    eLink = EffectLinkEffects(eLink,
        EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));
    eLink = EffectLinkEffects(eLink,
        EffectDamageDecrease(nPenalty,
            DAMAGE_TYPE_BLUDGEONING | DAMAGE_TYPE_PIERCING |
            DAMAGE_TYPE_SLASHING));
    eLink = EffectLinkEffects(eLink, eVisual);

    while(GetIsObjectValid(oTarget))
    {
        PRCSignalSpellEvent(oTarget, TRUE, SPELL_CRUSHING_DESPAIR,
            oCaster);
        int nDC = PRCGetSaveDC(oTarget, oCaster,
            SPELL_CRUSHING_DESPAIR);

        if(!PRCDoResistSpell(oCaster, oTarget,
            nCasterLevel + SPGetPenetr(oCaster))
            && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS,
                oCaster)
            && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC,
                SAVING_THROW_TYPE_MIND_SPELLS))
        {
            // Preserve stock Crushing Despair behavior, adding only its RAW
            // cancellation of the custom Moon-domain Good Hope spell.
            if(GetHasSpellEffect(SPELL_MOON_GOOD_HOPE, oTarget))
                PRCRemoveEffectsFromSpell(oTarget, SPELL_MOON_GOOD_HOPE);
            else
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink,
                    oTarget, fDuration, TRUE, SPELL_CRUSHING_DESPAIR,
                    nCasterLevel, oCaster);
        }

        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE,
            FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    PRCSetSchool();
}
