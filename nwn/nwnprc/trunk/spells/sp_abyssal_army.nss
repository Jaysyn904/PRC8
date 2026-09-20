#include "prc_alterations"  
#include "prc_inc_spells"  
  
void DoBabauStage(object oPC, int nCasterLvl);  
void DoVrockStage(object oPC, int nCasterLvl);  
  
void main()  
{  
    if(!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);  
  
    object oPC = OBJECT_SELF;  
    int nCasterLvl = PRCGetCasterLevel(oPC);  
    location lLoc = PRCGetSpellTargetLocation();  
  
    // Stage 1: 2d4 dretches, immediately  
    effect eDretch = SupernaturalEffect(EffectSummonCreature("prc_sum_dretch"));  
    int i; int nCount = d4(2);  
    for(i = 0; i < nCount; i++)  
    {  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDretch, oPC, RoundsToSeconds(nCasterLvl)); // 10 min/level  
    }  
  
    // Stage 2: 1d4 babaus, 10 minutes later  
    DelayCommand(600.0f, DoBabauStage(oPC, nCasterLvl));  
  
    // Stage 3: 1 vrock, 10 minutes after that  
    DelayCommand(1200.0f, DoVrockStage(oPC, nCasterLvl));  
  
    PRCSetSchool();  
}  
  
void DoBabauStage(object oPC, int nCasterLvl)  
{  
    effect eBabau = SupernaturalEffect(EffectSummonCreature("prc_sum_babau"));  
    int i; int nCount = d4(1);  
    for(i = 0; i < nCount; i++)  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBabau, oPC, RoundsToSeconds(nCasterLvl) - 600.0f);  
}  
  
void DoVrockStage(object oPC, int nCasterLvl)  
{  
    effect eVrock = SupernaturalEffect(EffectSummonCreature("prc_sum_vrock"));  
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVrock, oPC, RoundsToSeconds(nCasterLvl) - 1200.0f);  
}