/*
02/03/21 by Stratovarius

Focalor, Prince of Tears
  
Granted Abilities: 
Focalor gives you the ability to breathe water, strike foes down with lightning, blind enemies with a puff of your breath, and cause creatures to be stricken with grief in your presence.

Focalor’s Breath: As a standard action, you can exhale toward a single living target within 30 feet. That target is blinded for 1 round unless it succeeds on a Fortitude save. 
Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    //Declare major variables
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_FOCALOR)) return;
    object oTarget = PRCGetSpellTargetObject();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_FOCALOR);
    int nDC = GetBinderDC(oBinder, VESTIGE_FOCALOR);

    effect eVis   = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    
    if (!PRCGetIsAliveCreature(oTarget)) return;

    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
    {
        // Apply effects to the currently selected target.
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, 6.0);
    }

}
