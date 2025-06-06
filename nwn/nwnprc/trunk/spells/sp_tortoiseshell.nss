//::///////////////////////////////////////////////
//:: [Tortoise Shell]
//:: [sp_tortiseshell.nss]
//:: [Jaysyn 2024-08-20 22:12:12]
//::
//::///////////////////////////////////////////////
/**@file Tortoise Shell
(Spell Compendium, p. 221)

Transmutation
Level: Druid 6,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Touch
Target: Living creature touched
Duration: 10 minutes/level
Saving Throw: None
Spell Resistance: Yes (harmless)

In the blink of an eye, the creature you touched
 grows the armor plating of a tortoise across its
 torso and a tough, leathery skin elsewhere.

Tortoise shell grants a +6 enhancement bonus to
 the subject's existing natural armor bonus. This
 enhancement bonus increases by 1 for every three
 caster levels beyond 11th, to a maximum of +9 at
 20th level.

The enhancement bonus provided by tortoise shell
 stacks with the target's natural armor bonus, but
 not with other enhancement bonuses to natural
 armor. A creature without natural armor has an
 effective natural armor of +0, much as a character
 wearing only normal clothing has an armor bonus of
 +0.

Tortoise shell slows a creature's movement as if
it were wearing heavy armor. An elf subject to
tortoise shell, for example, would have a speed
of 20 feet and could run only 60 feet per round.
The spell affects only a creature's speed; tortoise
shell doesn't carry an armor check penalty or an
arcane spell failure chance.
*/////////////////////////////////////////////////
#include "x2_inc_spellhook"

void main() 
{
//:: Check the Spellhook
    if (!X2PreSpellCastCode()) return;

//:: Set the Spell School
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));

//:: Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
//:: Prevent spell stacking
    PRCRemoveEffectsFromSpell(oTarget, PRCGetSpellId());			
    
//:: Get the caster's level and check for Extend Spell feat
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nMetaMagic = PRCGetMetaMagicFeat();
    
//:: Calculate the enhancement bonus
    int nBonus = 6 + (nCasterLevel > 11 ? (nCasterLevel - 11) / 3 : 0);
    nBonus = nBonus > 9 ? 9 : nBonus; // Max bonus is +9

//:: Initialize existing natural armor bonus
    int nExistingNaturalArmor = 0;

//:: Check for items in inventory that provide Natural AC bonus
    object oItem = GetItemInSlot(INVENTORY_SLOT_NECK, oTarget);
    if (GetIsObjectValid(oItem)) 
	{
		//:: Directly get the Armor Class value from the item
        int nItemAC = GetItemACValue(oItem);
        if (nItemAC > nExistingNaturalArmor) 
		{
            nExistingNaturalArmor = nItemAC;
        }
    }

//:: Calculate the final bonus to apply
    int nFinalBonus = nBonus - nExistingNaturalArmor;
    if (nFinalBonus < 0) nFinalBonus = 0; // Ensure no negative bonus

//:: Determine the base duration of the effects (10 minutes per caster level)
    float fBaseDuration = TurnsToSeconds(10 * nCasterLevel);
//:: Check if the caster has the Extend Spell feat
    float fDuration = (nMetaMagic & METAMAGIC_EXTEND) ? fBaseDuration * 2.0 : fBaseDuration;

//:: Setup the natural armor effect
    effect eNaturalArmor = EffectACIncrease(nFinalBonus, AC_NATURAL_BONUS);

//:: Setup the movement speed penalty effect
//:: Normal speed is 30 feet per round, spell reduces to 20 feet per round (1/3 slower)
    int nSpeedDecreasePercent = 33; // Percentage to slow the movement speed
    effect eSlow = EffectMovementSpeedDecrease(nSpeedDecreasePercent);

//:: Create the visual effects
    effect eVFXNaturalArmor = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eVFXMovementSpeed = EffectVisualEffect(VFX_IMP_SLOW);
    effect eVFXACBonus = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eVFXBarkskin = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);

//:: Combine primary effects
    effect eLink = EffectLinkEffects(eNaturalArmor, eSlow);
		eLink = EffectLinkEffects(eLink, eVFXBarkskin);

//:: Apply the primary effects with duration
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

//:: Apply visual effects instantly
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFXNaturalArmor, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFXMovementSpeed, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFXACBonus, oTarget);

//:: Unset the Spell school
    PRCSetSchool();	
}