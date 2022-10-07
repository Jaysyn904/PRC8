//:://////////////////////////////////////////////
//:: Name     Angelskin
//:: FileName   sp_angelskin.nss
//:://////////////////////////////////////////////
/** @file
Abjuration [Good]
Level: Paladin 2
Components: V, S, DF,
Casting Time: 1 standard action
Range: Touch
Target: Lawful good creature touched
Duration: 1 round/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You touch your ally with the holy symbol and invoke the blessed words. An opalescent 
glow spreads across her skin, imbuing it with a pearl-like sheen.

The subject gains damage reduction 5/evil.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/22/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        float fDur = RoundsToSeconds(nCasterLvl);
        
        if(nMetaMagic & METAMAGIC_EXTEND)
        {
        	fDur += fDur;
        }        
        //Alignment check
        if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) && (GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL)
        {
        	effect eDR = EffectDamageReduction(5,DAMAGE_POWER_PLUS_THREE,0);
        	effect eVFX = EffectVisualEffect(VFX_DUR_AURA_WHITE);
        	effect eSpell = EffectLinkEffects(eDR, eVFX);
        	
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpell, oTarget, fDur);
        }
        //Invalid target alignment
        else
        {
        	SendMessageToPC(oPC, "This spell must target a lawful good creature.");
        }	
	PRCSetSchool();
}

