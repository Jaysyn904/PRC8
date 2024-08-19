    /**@file Chasing Perfection
[sp_chasperfect.nss]
(Player's Handbook II, p. 106)

Transmutation
Level: Cleric 6, Druid 6, Sorcerer 6, Wizard 6,
Components: V, S, M,
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 minute/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

Energy courses through the creature touched.
Its muscles grow and become more defined, it starts 
to move with greater alacrity and grace, and its 
bearing increases.

The subject improves in all ways.  It gains a +4 
enhancement bonus to each of its ability scores.

Material Component: A statuette of a celestial or 
fiend worth 50 gp.

**/

////////////////////////////////////////////////////
// Author:  Tenjac & Jaysyn
// Date:    2024/08/07
////////////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nMetaMagic 	= PRCGetMetaMagicFeat();
    float fDur 		= (60.0f * nCasterLevel);
	
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDur += fDur;

    PRCSignalSpellEvent(oTarget, FALSE, SPELL_CHASING_PERFECTION, oCaster);
	
	// Check for existing ability enhancing spells
    effect eExistingSpellEffect = GetFirstEffect(oTarget);
	
    int nBoostSTR 	= 4;
	int nBoostDEX 	= 4;
	int nBoostCON 	= 4;
	int nBoostWIS 	= 4;
	int nBoostINT 	= 4;
	int nBoostCHA 	= 4;
    
    while (GetIsEffectValid(eExistingSpellEffect))
    {
		if (GetEffectSpellId(eExistingSpellEffect) == SPELL_CROWN_OF_MIGHT || GetEffectSpellId(eExistingSpellEffect) == SPELL_TOWERING_OAK)
        {
            nBoostSTR = 2;
		} 
		if (GetEffectSpellId(eExistingSpellEffect) == SPELL_ANIMALISTIC_POWER)
        {
            nBoostSTR = 2;
			nBoostDEX = 2;
			nBoostCON = 2;			
		}
		if (GetEffectSpellId(eExistingSpellEffect) == SPELL_AWAKEN)
        {
            nBoostSTR = 0;
			nBoostWIS = 0;
			nBoostCON = 0;			
		} 
		if (GetEffectSpellId(eExistingSpellEffect) == SPELL_BULLS_STRENGTH ||
			GetEffectSpellId(eExistingSpellEffect) == SPELL_MASS_BULLS_STRENGTH ||
			GetEffectSpellId(eExistingSpellEffect) == SPELL_GREATER_BULLS_STRENGTH)
        {
            nBoostSTR = 0;
		}
        if (GetEffectSpellId(eExistingSpellEffect) == SPELL_CATS_GRACE ||
			GetEffectSpellId(eExistingSpellEffect) == SPELL_MASS_CATS_GRACE ||
            GetEffectSpellId(eExistingSpellEffect) == SPELL_GREATER_CATS_GRACE)
        {
            nBoostDEX = 0;
		}		
        if (GetEffectSpellId(eExistingSpellEffect) == SPELL_ENDURANCE ||
			GetEffectSpellId(eExistingSpellEffect) == SPELL_MASS_ENDURANCE ||
            GetEffectSpellId(eExistingSpellEffect) == SPELL_GREATER_ENDURANCE)
        {
            nBoostCON = 0;
		}	
        if (GetEffectSpellId(eExistingSpellEffect) == SPELL_OWLS_WISDOM ||
			GetEffectSpellId(eExistingSpellEffect) == SPELL_MASS_OWLS_WISDOM ||
			GetEffectSpellId(eExistingSpellEffect) == SPELL_OWLS_INSIGHT ||
            GetEffectSpellId(eExistingSpellEffect) == SPELL_GREATER_OWLS_WISDOM)
        {
            nBoostWIS = 0;
		}
        if (GetEffectSpellId(eExistingSpellEffect) == SPELL_FOXS_CUNNING ||
			GetEffectSpellId(eExistingSpellEffect) == SPELL_MASS_FOXS_CUNNING ||
            GetEffectSpellId(eExistingSpellEffect) == SPELL_GREATER_FOXS_CUNNING)
        {
            nBoostINT = 0;
		}		
        if (GetEffectSpellId(eExistingSpellEffect) == SPELL_EAGLE_SPLEDOR ||
			GetEffectSpellId(eExistingSpellEffect) == SPELL_MASS_EAGLES_SPLENDOR ||
            GetEffectSpellId(eExistingSpellEffect) == SPELL_GREATER_EAGLE_SPLENDOR)
        {
            nBoostCHA = 0;
		}			
        eExistingSpellEffect = GetNextEffect(oTarget);
    }

    //:: Build effect: Increase all ability scores
    effect eBuff = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, nBoostSTR), EffectAbilityIncrease(ABILITY_DEXTERITY, nBoostDEX));
           eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION, nBoostCON));
           eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nBoostINT));
           eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_WISDOM, nBoostWIS));
           eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_CHARISMA, nBoostCHA));
           eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_SANCTUARY));

    //:: Apply the linked effects to the target
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur, TRUE, SPELL_CHASING_PERFECTION, nCasterLevel);

    return TRUE;
}

void main()
{
//:: Check the Spellhook
    if (!X2PreSpellCastCode()) return;

//:: Set the Spell School
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
	
    object oCaster 		= OBJECT_SELF;
    object oTarget 		= PRCGetSpellTargetObject();
    int nCasterLevel 	= PRCGetCasterLevel(oCaster);
	
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {
            // holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
//:: Unset the Spell school
    PRCSetSchool();
}