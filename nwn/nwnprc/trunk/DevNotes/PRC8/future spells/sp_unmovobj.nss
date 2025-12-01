//:://////////////////////////////////////////////
//:: Name     Unmovable Object
//:: FileName   sp_unmovobj.nss
//:://////////////////////////////////////////////
/** @file Evocation
Level: Paladin 4,
Components: V, S,
Casting Time: 1 action
Range: Personal
Target: You
Duration: 1 round/level

Charging yourself with divine energy, you bond yourself
to the ground beneath your feet and become the epitome
of stability.
The spell ends instantly if you move from your current 
position and does not work unless you are in contact 
with the ground.

You gain a +2 bonus to Strength, a +4 bonus to Constitution,
a +2 resistance bonus on saving throws, and a +4 dodge 
bonus to AC.

You gain a +10 bonus to resist a bull rush (this bonus does
not include the +4 bonus for being "exceptionally stable",
but exceptionally stable creatures do get that bonus in
addition to the bonus from this spell).

You gain a +10 bonus to resist all trip attacks (but not 
to your attempts to trip someone in return).

You gain a +10 resistance bonus on any roll made to resist
an effect that would cause you to move from your current
location.

For example, while you are not immune to enchantment 
effects, you gain a +10 resistance bonus on saving throws
(or Charisma checks, in the case of effects such as charm 
person) to resist commands that would cause you to leave
your current position.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 8/4/22
//:: Updated By: Jaysyn
//:: Updated on: 2024-10-01 09:23:56
//:://////////////////////////////////////////////
#include "prc_sp_func"
#include "prc_add_spell_dc"

void StillCheck(object oPC, float fDur, location lLoc)
{
    if (!GetIsInCombat(oPC) || GetLocation(oPC) != lLoc)
    {
        effect eToDispel = GetFirstEffect(oPC);
        while (GetIsEffectValid(eToDispel))
        {
            if (GetEffectSpellId(eToDispel) == SPELL_UNMOVABLE_OBJECT)
            {
                RemoveEffect(oPC, eToDispel);
            }
            eToDispel = GetNextEffect(oPC);
        }
    }
    else
    {
        DelayCommand(1.0f, StillCheck(oPC, fDur - 1.0f, lLoc));
    }
}

void main()
{
    if (!X2PreSpellCastCode()) return;
    
    PRCSetSchool(SPELL_SCHOOL_EVOCATION); // Set spell school

    object oPC = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    float fDur = RoundsToSeconds(nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();
    
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        fDur += fDur;
    }

    // Delay to check if combat has ended, if so remove the effects
    DelayCommand(1.0f, StillCheck(oPC, fDur - 1.0f, GetLocation(oPC)));
    
    // Apply cutscene immobilization
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, fDur);

    // Apply ability increases: +2 STR, +4 CON
    effect eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 2), 
                                     EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));

    // Apply +2 to all saving throws
    eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));

    // Apply +4 dodge bonus to AC
    eLink = EffectLinkEffects(eLink, EffectACIncrease(4, AC_DODGE_BONUS));

    // Apply +10 resistance vs fear effects (to resist effects that move the target)
    eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 10, SAVING_THROW_TYPE_FEAR));

    // Apply all linked effects to the caster
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
    
    // Apply visual effect for AC bonus
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oPC);

    PRCSetSchool(); // Reset spell school (correctly used)
}