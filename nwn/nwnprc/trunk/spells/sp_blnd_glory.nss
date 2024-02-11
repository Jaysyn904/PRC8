//::///////////////////////////////////////////////
//:: Name      Blinding Glory
//:: FileName  sp_blnd_glory.nss
//:://////////////////////////////////////////////
/**@file Blinding Glory
Conjuration (Creation) [Good] 
Level: Glory 9, Sor/Wiz 9 
Components: V, S, M/DF 
Casting Time: 1 hour
Range: Close (25 ft. + 5 ft./2 levels) 
Area: 100-ft./level radius spread, centered on you
Duration: 1 hour/level 
Saving Throw: None 
Spell Resistance: No

A brilliant radiance spreads from you, brightly 
illuminating the area. The light is similar to that
created by the daylight spell, but no magical 
darkness counters or dispels it. Furthermore, 
evil-aligned creatures are blinded within this light.

Blinding glory brought into an area of magical 
darkness (or vice versa), including an utterdark 
spell, is temporarily negated, so that the otherwise
prevailing light conditions exist in the overlapping
areas of effect.

Arcane Material Component: A polished rod of pure 
silver.

Author:    Tenjac
Created:   6/13/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    if (!X2PreSpellCastCode()) return;
    
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);
    
    object oPC = OBJECT_SELF;
    int nCasterLvl = PRCGetCasterLevel(oPC);
    effect eAOE = EffectAreaOfEffect(AOE_PER_BLNDGLORY);
    float fDuration = HoursToSeconds(nCasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();
    
    effect eVis = EffectVisualEffect(VFX_FNF_SUNBEAM);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
    
        
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        fDuration = fDuration *2;    //Duration is +100%
    }
    
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC, fDuration, TRUE, SPELL_BLINDING_GLORY, -1);
    
    //Create an instance of the AOE Object using the Apply Effect function
    
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDuration, TRUE, SPELL_BLINDING_GLORY, nCasterLvl);
    
    //SPGoodShift(oPC);
    PRCSetSchool();
}