/*
18/03/21 by Stratovarius

Zceryll, the Star Spawn
  
Zceryll was a mortal sorceress who communed with alien powers from the far realm. She became obsessed with immortality, seeking out the alien beings in the hopes of 
learning their eternal secrets. When she died, she became a hideously twisted vestige, forever seeking to re-enter the Realms via numerous artifacts she dispersed 
across the world. Zceryll grants you the ability to transform your body and mind into an alien form, granting you telepathy, resistance to effects related to insanity,
the ability to summon pseudonatural creatures, and the power to unleash bolts of pure madness.

Vestige Level: 6th
Binding DC: 25
Special Requirement: No

Influence: Never admit that you need help or that you are weaker than anyone else. Treat those that are weaker than you with scorn and contempt, especially young women and spontaneous spellcasters.

Granted Abilities: 
While bound to Zceryll, your body and mind become alien, allowing you to channel the power of the star spawn in a variety of ways.

Bolts of Madness: You can fire a ray that dazes an opponent for 1d3 rounds. You must succeed on a ranged touch attack with a range of 100 ft. + 10 ft./binder level. A successful 
Will save negates the effect. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_sp_tch"

void main()
{
	object oBinder = OBJECT_SELF;
	if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ZCERYLL)) return;
    object oTarget     = PRCGetSpellTargetObject(); 
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ZCERYLL);
    int nDC = GetBinderDC(oBinder, VESTIGE_ZCERYLL);

    effect eVis = EffectVisualEffect(PSI_FNF_PSYCHIC_CHIRURGY);
    effect eRay = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND);
    
    if(PRCDoRangedTouchAttack(oTarget))
    {
        if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        {
        	int nDur = d3();
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectDazed()), oTarget, RoundsToSeconds(nDur));
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE)), oTarget, RoundsToSeconds(nDur));
         	//Apply the VFX impact and damage effect
        	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    	} 	
    }
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7, FALSE);    
}