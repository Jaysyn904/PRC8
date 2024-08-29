//::///////////////////////////////////////////////
//:: [Spirit Worm]
//:: [sp_spiritworm.nss]
//:: [Jaysyn - PRC8 2024-08-20 20:42:32]
//:: 
//::
//::///////////////////////////////////////////////
/**@file Spirit Worm
(Spell Compendium, p. 202)

Necromancy
Level: Sorcerer 1, Wizard 1,
Components: V, S, M,
Casting Time: 1 standard action
Range: Touch
Target: Living creature touched
Duration: 1 round/level, up to 5 rounds; see text
Saving Throw: Fortitude negates; see text
Spell Resistance: Yes

You press the bit of blackened bone against your 
foe and intone the spell. The bone vanishes, 
leaving a mottled bruise where it touched.

You create a lingering decay in the spirit and 
body of the target. If the target fails its saving 
throw, it takes 1 point of Constitution damage each 
round while the spell lasts (maximum 5 points). 
The victim can attempt a Fortitude saving throw 
each round, and success negates the Constitution 
damage for that round and ends the spell.

Material Component: A piece of fire-blackened 
ivory or bone carved in the shape of a segmented 
worm. 
*/////////////////////////////////////////////////
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void SpiritWormDamage(object oTarget, object oCaster, int nDuration, int nMetaMagic, int nSpellID)
{
//:: Exit if the target is dead or duration has expired
    if (GetIsDead(oTarget) || nDuration <= 0)
        return;

//:: Calculate caster level and spell penetration
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();

//:: Check for spell resistance
    if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
    {
    //:: Calculate Fortitude Save DC
        int nFortSaveDC = PRCGetSpellSaveDC(nSpellID, -1, oCaster);
        int bSuccess = FortitudeSave(oTarget, nFortSaveDC, SAVING_THROW_TYPE_NEGATIVE, oCaster);

        if (!bSuccess)
        {
        //:: Apply Constitution Damage
            effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

        //:: Reduce duration and apply damage in the next round
            nDuration--;
            DelayCommand(6.0f, SpiritWormDamage(oTarget, oCaster, nDuration, nMetaMagic, nSpellID));
        }
        else
        {
        //:: Indicate successful save
            effect eSuccess = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSuccess, oTarget);
        }
    }
}

void main()
{
//:: Check the Spellhook
    if (!X2PreSpellCastCode()) return;

//:: Set the Spell School
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));

//:: Declare major variables
    int nSpellID 	= PRCGetSpellId();
    object oCaster 	= OBJECT_SELF;
    object oTarget 	= PRCGetSpellTargetObject();

    int nCasterLvl 	= PRCGetCasterLevel(oCaster);
    int nMetaMagic 	= PRCGetMetaMagicFeat();
    int nPenetr 	= nCasterLvl + SPGetPenetr();
    int nDuration 	= nCasterLvl;

//:: Limit the duration to a maximum of 5 rounds
    if (nDuration > 5) nDuration = 5;
    if (nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;

//:: Only affect hostile targets
    if (!GetIsReactionTypeFriendly(oTarget, oCaster))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));

    //:: Calculate Fortitude Save DC
        int nFortSaveDC = PRCGetSpellSaveDC(nSpellID, -1, oCaster);
        int bSuccess = FortitudeSave(oTarget, nFortSaveDC, SAVING_THROW_TYPE_NEGATIVE, oCaster);

        if (bSuccess)
        {
        //:: Indicate successful save
            effect eSuccess = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSuccess, oTarget);
        }
        else
        {
        //:: Check for spell resistance
            if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
            //:: Setup initial visual effect
                effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            //:: Prevent spell stacking
                PRCRemoveEffectsFromSpell(oTarget, PRCGetSpellId());

			//:: Apply Constitution Damage Per Round
                SpiritWormDamage(oTarget, oCaster, nDuration, nMetaMagic, nSpellID);
            }
        }
    }

//:: Unset the Spell School
    PRCSetSchool();
}