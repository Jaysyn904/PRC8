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
//::
//:: Fixed By: Jaysyn
//:: Date: 2026-09-24 10:20:20
//::
//:://////////////////////////////////////////////
#include "prc_inc_spells"

void FinishBlindingGlory(object oPC, effect eAOE, effect eVis, effect eDur, float fDuration, int nCasterLvl)  
{  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);  
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC, fDuration, TRUE, SPELL_BLINDING_GLORY, -1);  
  
    //Create an instance of the AOE Object using the Apply Effect function  
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oPC, fDuration, TRUE, SPELL_BLINDING_GLORY, nCasterLvl);  

}  
  
void BlindingGloryChannel(object oPC, effect eAOE, effect eVis, effect eDur, float fDuration, int nCasterLvl, float fElapsed, float fCastTime)  
{  
    // Concentration check each 3 seconds - lets the player act/flee/fight freely.  
    // Being attacked, disrupted, or afflicted with a mental effect breaks the channel.  
    if (GetBreakConcentrationCheck(oPC))  
    {  
        FloatingTextStringOnCreature("Your casting of Blinding Glory is disrupted!", oPC, FALSE);  
        PRCSetSchool();  
        return; // abort the cast entirely - no effects applied  
    }  
  
    fElapsed += 3.0;  
    if (fElapsed >= fCastTime)  
    {  
        FinishBlindingGlory(oPC, eAOE, eVis, eDur, fDuration, nCasterLvl);  
        PRCSetSchool();  
        return;  
    }  
  
    DelayCommand(3.0, BlindingGloryChannel(oPC, eAOE, eVis, eDur, fDuration, nCasterLvl, fElapsed, fCastTime));  
}  
  
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
        fDuration = fDuration * 2;    //Duration is +100%  
    }  
  
    float fCastTime = HoursToSeconds(1); // 1 hour casting time, channeled via concentration checks  
  
    FloatingTextStringOnCreature("You begin channeling Blinding Glory. It will take 1 hour to complete.", oPC, FALSE);  
  
    BlindingGloryChannel(oPC, eAOE, eVis, eDur, fDuration, nCasterLvl, 0.0, fCastTime);  
}



/* 

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
} */