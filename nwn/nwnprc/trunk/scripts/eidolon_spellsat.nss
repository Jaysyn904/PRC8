//::///////////////////////////////////////////////  
//:: eidolon_spellsat.nss  [OnSpellCastAt]  
//:: Handles special eidolon interactions per template rules  
//:://////////////////////////////////////////////  
#include "prc_inc_spells"  

void RestoreEidolonDRAndSR(object oCreature)  
{  
    DeleteLocalInt(oCreature, "TEMPLATE_EIDOLON_STONEFLESH");  
  
    object oSkin    = GetPCSkin(oCreature);  
    int nBaseHD     = GetLocalInt(oCreature, "TEMPLATE_EIDOLON_BASEHD");  
  
    itemproperty ipDR;  
    if(nBaseHD >= 16)      ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_10_HP);  
    else if(nBaseHD >= 11) ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_7_HP);  
    else if(nBaseHD >= 7)  ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_5_HP);  
    else if(nBaseHD >= 4)  ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_3_HP);  
    else                   ipDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5, IP_CONST_DAMAGESOAK_1_HP);  
    ipDR = TagItemProperty(ipDR, "Eidolon_DR");  
    IPSafeAddItemProperty(oSkin, ipDR, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);  
  
    effect eSR = EffectSpellResistanceIncrease(100);  
    eSR = TagEffect(eSR, "Eidolon_SR");  
    eSR = UnyieldingEffect(eSR);  
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oCreature);  
}
  
void main()  
{  
    object oCreature = OBJECT_SELF;  
    object oCaster   = GetLastSpellCaster();  
    int nSpell       = GetLastSpell();  
    int nCasterLevel = GetCasterLevel(oCaster);  
	
	ExecuteScript("prc_npc_spellat", OBJECT_SELF);
	ExecuteScript("nw_c2_defaultb", OBJECT_SELF);
  
    if (!GetLocalInt(oCreature, "TEMPLATE_EIDOLON"))  
        return;  
  
    switch (nSpell)  
    {  
        //:: Etherealness: heal damage equal to caster level  
        case SPELL_ETHEREALNESS:  
        {  
            effect eHeal = EffectHeal(nCasterLevel);  
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCreature);  
            break;  
        }  
  
		//:: Dimensional Anchor: dazed for 1 round (bypass mind immunity)  
		case SPELL_DIMENSIONAL_ANCHOR:  
		{  
			effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);  
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCreature, RoundsToSeconds(1));  
		  
			AssignCommand(oCreature, ClearAllActions(TRUE));  
			AssignCommand(oCreature, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE, 1.0, 6.0));  
			DelayCommand(0.2, SetCommandable(FALSE, oCreature));  
			DelayCommand(6.2, SetCommandable(TRUE, oCreature));  
			break;  
		}
  
        //:: Dimensional Lock: strip otherworldly-geometry/insanity aura for as long as in the field  
        case SPELL_DIMENSIONAL_LOCK:  
        {  
            // This is handled in eidolon_hb. 
            break;  
        }  
  
/*         //:: Transmute Rock to Mud: slow 2d6 rounds, no save  
        case SPELL_TRANSMUTE_ROCK_TO_MUD:  
        {  
            effect eSlow = EffectSlow();  
            int nRounds = d6(2);  
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oCreature, RoundsToSeconds(nRounds));  
            break;  
        }  
  
        //:: Transmute Mud to Rock: full heal  
        case SPELL_TRANSMUTE_MUD_TO_ROCK:  
        {  
            effect eHeal = EffectHeal(GetMaxHitPoints(oCreature));  
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCreature);  
            break;  
        }   */
  
		//:: Stone to Flesh: negate DR & magic immunity for 1 round  
		case SPELL_STONE_TO_FLESH:  
		{  
			object oSkin = GetPCSkin(oCreature);  
		  
			//:: Remove Eidolon_DR itemproperty  
			itemproperty ipCheck = GetFirstItemProperty(oSkin);  
			while (GetIsItemPropertyValid(ipCheck))  
			{  
				if (GetItemPropertyTag(ipCheck) == "Eidolon_DR")  
					RemoveItemProperty(oSkin, ipCheck);  
				ipCheck = GetNextItemProperty(oSkin);  
			}  
		  
			//:: Remove Eidolon_SR effect  
			effect eCheck = GetFirstEffect(oCreature);  
			while (GetIsEffectValid(eCheck))  
			{  
				if (GetEffectTag(eCheck) == "Eidolon_SR")  
					RemoveEffect(oCreature, eCheck);  
				eCheck = GetNextEffect(oCreature);  
			}  
		  
			SetLocalInt(oCreature, "TEMPLATE_EIDOLON_STONEFLESH", TRUE);  
		  
			//:: Restore both 1 round later  
			DelayCommand(RoundsToSeconds(2), RestoreEidolonDRAndSR(oCreature));  
			break;  
		}
    }  
  
    // Continue event chain, matching prc_npc_spellat.nss convention  
    ExecuteAllScriptsHookedToEvent(oCreature, EVENT_NPC_ONSPELLCASTAT);  
}