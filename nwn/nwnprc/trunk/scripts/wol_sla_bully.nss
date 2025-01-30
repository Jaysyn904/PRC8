/**
 * @file
 * Spellscript for Bullybasher's Gauntlets SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Bullybashers");
    
    // You get nothing if you aren't wielding the item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_ARMS, oPC)) return;  

    switch(nSLA){
        case WOL_BULLY_SILLY:
        {
            nUses = 2;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                object oTarget = PRCGetSpellTargetObject();
                PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Knock Silly Hit", "Knock Silly Miss");
                SetLegacyUses(oPC, nSLA);
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                   ActionCastSpell(SPELL_TOUCH_OF_IDIOCY, 5, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oTarget);
            }    
            break;
        } 
        case WOL_BULLY_GIANT:
        {
        	effect eLOS;
			if(GetGender(OBJECT_SELF) == GENDER_FEMALE)
			{
				eLOS = EffectVisualEffect(290);
			}
			else
			{
				eLOS = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
			}
	
			effect eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 2), EffectAbilityDecrease(ABILITY_DEXTERITY, 2));
				   eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_HEAD_SONIC));
				   eLink = EffectLinkEffects(eLink, eLOS);
        	       eLink = EffectLinkEffects(eLink, EffectAttackDecrease(1));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, 600.0);
			nUses = 999;
            break;
        } 
        case WOL_BULLY_STONE:
        {
        	if(!GetHasSpellEffect(WOL_BULLY_GIANT, oPC))
			{
				SendMessageToPC(oPC, "Giant Bearing must be active to use this ability");
				return;
			}
			
			object oTarget = PRCGetSpellTargetObject();
            int nAtk = GetAttackRoll(oTarget, oPC, OBJECT_INVALID);
            if (nAtk)
            {
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, ExtraordinaryEffect(EffectDamage(d6(2*nAtk), DAMAGE_TYPE_BLUDGEONING)), oTarget);
            	FloatingTextStringOnCreature("Stone Throw Hit", oPC, FALSE);
            }
			nUses = 999;
            break;
        }         
        case WOL_BULLY_CHAIN:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                object oTarget = PRCGetSpellTargetObject();
                PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, FALSE, "Lightning Punch Hit", "Lightning Punch Miss");
                if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
                {
                   //ActionCastSpell(SPELL_TOUCH_OF_IDIOCY, 5, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oTarget);
                   DoRacialSLA(SPELL_CHAIN_LIGHTNING, 15, PRCMax(19, 16 + GetAbilityModifier(ABILITY_CHARISMA, oPC)), TRUE);
                   SetLegacyUses(oPC, nSLA);
                }   
            } 
            break;
        }        
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    if (nSpell > 0) 
    {
        DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        