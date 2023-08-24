/*
1/03/21 by Stratovarius

Dahlver Nar, the Tortured One
  
Once a human binder, Dahlver-Nar now grants powers just as other vestiges do. He gives his summoners tough skin, a frightening moan, protections against madness, 
and the ability to share injuries with allies.
  
Maddening Moan: You can emit a frightful moan as a standard action. Every creature within a 30-foot spread must succeed on a Will save or be dazed for 1 round. 
Once you have used this ability, you cannot do so again for 5 rounds. Maddening moan is a mind-affecting sonic ability.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    int nDC = GetBinderDC(oBinder, VESTIGE_DAHLVERNAR);
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_DAHLVERNAR)) return;

    location lTarget = GetLocation(oBinder);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_ODD), oBinder);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_INSANITY), oBinder);
    // Use the function to get the closest creature as a target
    object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oAreaTarget))
    {
        if(oAreaTarget != oBinder) // Everyone
        {
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oAreaTarget, nDC, SAVING_THROW_TYPE_SONIC))
			{
	        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectDazed()), oAreaTarget, 6.0);
	        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE)), oAreaTarget, 6.0);
	        }	
        }
    //Select the next target within the spell shape.
    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}