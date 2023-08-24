/*
14/03/21 by Stratovarius

Ipos, Prince of Fools
  
Binders call Ipos the Prince of Fools because of the crown he wears and the sad legend of his transformation into a vestige. He grants his summoners cold iron claws with which to rend foes, 
the power to see creatures and objects as they are, and a fraction of his charisma.

Vestige Level: 6th
Binding DC: 26
Special Requirement: Ipos refuses to answer the call of any summoner who, in his judgment, has not taken a serious enough interest in occult studies. Anyone wishing to bind Ipos must 
have at least 5 ranks in Lore and 5 ranks in Spellcraft.

Influence: You think highly of your intellect and show contempt toward those who question your assumptions or conclusions. If you encounter a creature that shows interest in a topic 
about which you have knowledge, Ipos requires that you truthfully edify that individual.

Granted Abilities: 
Ipos grants you his discerning sight and commanding presence, as well as claws of cold iron with which to rend the veil of ignorance.

Cold Iron Claws: Your fingernails harden into cold iron, granting you two claw attacks. The base damage for each claw attack is as given on the following table. These claws overcome damage reduction of +3 or less.
Size Base Damage
Diminutive 1
Fine 1d2
Tiny 1d3
Small 1d4
Medium 1d6
Large 1d8
Huge 2d6
Gargantuan 2d8
Colossal 4d6

Flash of Insight: As a swift action, you gain a true seeing effect (as the spell) for a duration of 1 round. Once you have used this ability, you cannot do so again for 5 rounds.

Ipos’s Influence: Your affiliation with Ipos allows you to draw more power from the vestiges to which you are bound. The saving throw DC (if any) of each special ability granted by your 
vestiges increases by 1. Treat your effective binder level as one higher than normal for the purpose of determining the effects of vestige special abilities.

Rend: When you hit one foe with two or more claw attacks, you automatically deal double the damage of a normal claw attack (including your Strength modifier) in addition to your normal damage.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_natweap"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROTECTION_ENERGY_COLD), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_IPOS_CLAWS))  
    {
        string sResRef = "prc_claw_1d6l_";
        // Gets up to the proper size
        int nSize = PRCGetCreatureSize(oBinder) + 1;
        sResRef += GetAffixForSize(nSize);
        AddNaturalPrimaryWeapon(oBinder, sResRef, 2); 

		DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oBinder), ItemPropertyAttackBonus(3), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
       	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oBinder), ItemPropertyAttackPenalty(3), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
		DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oBinder), ItemPropertyAttackBonus(3), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
       	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oBinder), ItemPropertyAttackPenalty(3), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));       	
    }	
	if (!GetIsVestigeExploited(oBinder, VESTIGE_IPOS_INSIGHT))  IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_IPOS_INSIGHT), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_IPOS_REND))  
	{
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_REND), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
       	DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oBinder), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));
		DelayCommand(3.0, IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oBinder), ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE));		
	}	
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}