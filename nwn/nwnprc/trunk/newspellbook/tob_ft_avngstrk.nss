//::///////////////////////////////////////////////
//:: Name      Avenging Strike
//:: FileName  tob_ft_avngstrk.nss
//:://////////////////////////////////////////////
/** Benefit: As a swift action, you can channel the
power of your faith and energy to enhance a single
attack you make. You gain a bonus equal to your CHA
bonus (if any) on the attack roll and damage roll
for the next melee attack you make against an evil
outsider. You can use this ability a number of times
per day equal to your charisma bonus (minimum 1).

Author:    Tenjac & Stratovarius
Created:   20.3.2007
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oPC = OBJECT_SELF;
        int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        
        //Set the bonus int on the weapons
        
        effect eBonus = EffectLinkEffects(EffectAttackIncrease(nBonus, ATTACK_BONUS_MISC), EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(nBonus), DAMAGE_TYPE_BASE_WEAPON));
               eBonus = VersusAlignmentEffect(eBonus, ALIGNMENT_EVIL);
               eBonus = VersusRacialTypeEffect(eBonus, RACIAL_TYPE_OUTSIDER);
        
        //Apply
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oPC, 0.0f, FALSE, SPELL_AVENGING_STRIKE, -1, OBJECT_SELF); 
        
        //Set up onhit prop
        IPSafeAddItemProperty(oWeap, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        
        //Add event hook
        AddEventScript(oWeap, EVENT_ONHIT, "tob_evnt_avgstr", FALSE, FALSE);
        
        //Do left hand too if valid
        if(GetIsObjectValid(oWeap2))
        {
              IPSafeAddItemProperty(oWeap2, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
              AddEventScript(oWeap2, EVENT_ONHIT, "tob_evnt_avgstr", FALSE, FALSE);
        }
}