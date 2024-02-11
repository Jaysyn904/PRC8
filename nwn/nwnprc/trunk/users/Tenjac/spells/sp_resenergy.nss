//:://////////////////////////////////////////////
//:: Name     Resist Energy
//:: FileName   sp_resenergy.nss
//:://////////////////////////////////////////////
/** @file Abjuration
Level: Ranger 1, Duskblade 1, Cleric 2, Death Master 2,
Sha'ir 2, Wu Jen 2 (All), Death Delver 2, Fatemaker 2, 
Knight of the Chalice 2, Knight of the Weave 2, 
Vassal of Bahamut 2, Hoardstealer 2, Adept 2, Wizard 2,
Sorcerer 2, Paladin 2, Druid 2, Urban Druid 2, Dragon 2,
Fire 3
Components: V, S, DF,
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 10 min./level
Saving Throw: Fortitude negates (harmless)
Spell Resistance: Yes (harmless)

This abjuration grants a creature limited protection from 
damage of whichever one of five energy types you select: 
acid, cold, electricity, fire, or sonic. The subject gains 
energy resistance 10 against the energy type chosen, meaning 
that each time the creature is subjected to such damage 
(whether from a natural or magical source), that damage is 
reduced by 10 points before being applied to the creature's
hit points. The value of the energy resistance granted increases
to 20 points at 7th level and to a maximum of 30 points at 11th
level. The spell protects the recipient's equipment as well.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 7/20/22
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur =  600.0f * (nCasterLvl);
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        int nSpell = GetSpellId();
        int nDamType;
        int nVis;
        
        if(nSpell == SPELL_RESIST_ENERGY_ACID)
        {
        	nDamType = DAMAGE_TYPE_ACID;
        	nVis = VFX_DUR_AURA_GREEN;
        }
        
        else if (nSpell == SPELL_RESIST_ENERGY_COLD)
        {
        	nDamType = DAMAGE_TYPE_COLD;
        	nVis = VFX_DUR_AURA_CYAN;
        }
        else if (nSpell == SPELL_RESIST_ENERGY_ELEC)
        {
        	nDamType = DAMAGE_TYPE_ELECTRICAL;
        	nVis = VFX_DUR_AURA_WHITE;
        }
        else if (nSpell == SPELL_RESIST_ENERGY_FIRE)
        {
        	nDamType = DAMAGE_TYPE_FIRE;
        	nVis = VFX_DUR_AURA_RED;
        }
        else if (nSpell == SPELL_RESIST_ENERGY_SONIC)
        {
        	nDamType = DAMAGE_TYPE_SONIC;
        	nVis = VFX_DUR_AURA_BLUE_LIGHT;
        }        
        else
        {
        	SendMessageToPC(oPC, "Invalid spell ID.");
        	break;
        }
        
        int nDamRes = 10;
        if(nCasterLvl > 6) nDamRes +=10;
        if(nCasterLvl > 10) nDamRes +=10; 
        
	effect eLink = EffectLinkEffects(EffectVisualEffect(nVis), EffectDamageResistance(nDamType, nDamRes));
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
        
        PRCSetSchool();
}