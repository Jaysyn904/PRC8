//::
//::	eidolon_insan_a.nss	[onEnter]
//::
//::
/*
	Insanity Aura (Su): The elemental forces that power an
	elder eidolon warp rime and space and cause horrible 
	hallucinations in those nearby. Any living creature 
	within 10 feet of an eidolon must make a successful 
	Will saving throw (DC 10 + 1/2 the eidolon's Hit Dice 
	+ Wis modifier) each round or become confused for 1 
	round.
*/

#include "prc_inc_spells"  
  
void main()  
{  
    object oNPC    = GetAreaOfEffectCreator();  
    object oTarget = GetEnteringObject();  
  
    int nHD    = GetHitDice(oNPC);  
    int nDC    = 10 + (nHD / 2) + GetAbilityModifier(ABILITY_WISDOM, oNPC);  
  
    effect eVis   = EffectVisualEffect(VFX_IMP_CONFUSION_S);  
    effect eMind  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);  
    effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);  
    effect eConf  = PRCEffectConfused();  
    effect eLink  = EffectLinkEffects(eMind, eConf);  
           eLink  = EffectLinkEffects(eLink, eDur);  
           eLink  = SupernaturalEffect(eLink);  
  
    if(GetIsEnemy(oTarget, oNPC) && PRCGetIsAliveCreature(oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))  
    {  
        //if(DEBUG) DoDebug("eidolon_insan_a >> Entering aura.");
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))  
        {  
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));  
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  
        }  
    }  
}