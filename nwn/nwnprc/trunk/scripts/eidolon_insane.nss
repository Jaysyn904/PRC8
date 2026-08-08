//;:
//::	eidolon_insane.nss
//::
#include "inc_debug"

void main()
{
	object oNPC = OBJECT_SELF;
	
	//if(DEBUG) DoDebug("eidolon_insane >> Firing script");
	
 //:: Insanity Aura (Su): AOE confusion  
    effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR, "eidolon_insan_a", "eidolon_insan_b", "");
	effect eVis  = EffectVisualEffect(VFX_DUR_AURA_BLUE_DARK);
	effect eLink = EffectLinkEffects(eAOE, eVis);
	eLink = TagEffect(eLink, "Eidolon_Insanity");
    eLink = UnyieldingEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oNPC, HoursToSeconds(900));
}