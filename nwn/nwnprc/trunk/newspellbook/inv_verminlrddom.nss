/*  
    Warlock epic feat  
    Verminlord dominating vermin 

	Fixed By: Jaysyn
	Date: 2026-05-27 19:43:38
*/  
#include "prc_inc_racial"  
#include "inv_inc_invfunc"  
#include "prc_inc_spells"  
  
void main()  
{  
    object oTarget = PRCGetSpellTargetObject();  
    int nRacialType = MyPRCGetRacialType(oTarget);  
  
    if(nRacialType != RACIAL_TYPE_VERMIN)  
        return;  
  
    int nCasterLevel = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);  
    int nDuration = nCasterLevel;  
      
    // Spell resistance check  
    if(PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLevel))  
        return;  
  
    // Will save (but not as mind-affecting for vermin)  
    if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_NONE))  
        return;  
  
    // Apply supernatural domination effect that bypasses mind immunity  
    effect eDom = SupernaturalEffect(EffectCutsceneDominated());  
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);  
    effect eLink = EffectLinkEffects(eDom, eVis);  
      
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration), TRUE, -1, nCasterLevel);  
}

/* void main()
{
    object oTarget = PRCGetSpellTargetObject();
    int nRacialType = MyPRCGetRacialType(oTarget);

    if(nRacialType != RACIAL_TYPE_VERMIN)
        return;

	DoRacialSLA(SPELL_DOMINATE_MONSTER, GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK));
}
 */