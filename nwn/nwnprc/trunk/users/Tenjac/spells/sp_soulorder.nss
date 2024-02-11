//:://////////////////////////////////////////////
//:: Name     Soul of Order
//:: FileName   sp_soulorder.nss
//:://////////////////////////////////////////////
/** @file Transmutation [Lawful]
Level: Paladin 1, Sorcerer 2, Wizard 2,
Components: V, S,
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour

A shimmering field of silver energy flows up your 
body from your feet to your head, giving your skin a 
metallic sheen.

This spell infuses your body with energy drawn from 
the primal forces of law. You gain a +2 morale bonus
on Will saves made to resist enchantment effects.

Your natural weapons are treated as lawful-aligned for 
the purpose of overcoming damage reduction.

Regardless of your normal alignment, you are considered
lawful-aligned for the purpose of effects that rely on 
alignment (such as protection from law or order's wrath).

If soul of order and soul of light are active on you at 
the same time, you gain damage reduction 3/+3.

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 8/8/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"
#include " x2_inc_itemprop"

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  HoursToSeconds(1);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS));
        object oNatural = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
        
        IPSafeAddItemProperty(oNatural, ItemPropertyEnhancementBonus(3), fDur);
        IPSafeAddItemProperty(oNAtural, ItemPropertyDamagePenalty(3), fDur);
        IPSafeAddItemProperty(oNAtural, ItemPropertyAttackPenalty(3), fDur);        
        
        if(GetHasSpellEffect(SPELL_SOUL_OF_LIGHT, oPC))
        {
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageReduction(3, DAMAGE_POWER_PLUS_THREE, 0), oPC, fDur);
        }        
        
        PRCSetSchool();
}