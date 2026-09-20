//::///////////////////////////////////////////////  
//:: Name      Anticold Sphere  
//:: FileName  sp_anticold.nss  
//::///////////////////////////////////////////////  
/**@file Abjuration [Cold]  
Level: Cleric 5, Sorcerer 5, Wizard 5  
Components: V, S  
Casting Time: 1 standard action  
Range: 10 ft.  
Area: 10-ft.-radius emanation centered on you  
Duration: 10 minutes/level (D)  
Saving Throw: None  
Spell Resistance: Yes  
  
All creatures within the area gain immunity to cold damage.  
The emanation hedges out any creature with the cold subtype.  
*/  
//:://////////////////////////////////////////////  
  
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
  
void main()  
{  
    if(!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_ABJURATION);  
  
    object oPC = OBJECT_SELF;    
    int nCasterLvl = PRCGetCasterLevel(oPC);  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    float fDur = TurnsToSeconds(nCasterLvl);  
  
    if(nMetaMagic & METAMAGIC_EXTEND)  
    {  
        fDur += fDur;  
    }  

	effect eAoE = EffectAreaOfEffect(VFX_PER_10_FT_INVIS, "sp_anticolda", "", "sp_anticoldb");  
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oPC, fDur);  
	  
	object oAoE = GetAreaOfEffectObject(GetLocation(oPC), "VFX_PER_10_FT_INVIS");  
	SetAllAoEInts(99999/* SPELL_ANTICOLD_SPHERE */, oAoE, 0, 0, nCasterLvl);  
  
    PRCSetSchool();  
}