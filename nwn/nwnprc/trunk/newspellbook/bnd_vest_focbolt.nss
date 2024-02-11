/*
02/03/21 by Stratovarius

Focalor, Prince of Tears
  
Granted Abilities: 
Focalor gives you the ability to breathe water, strike foes down with lightning, blind enemies with a puff of your breath, and cause creatures to be stricken with grief in your presence.

Lightning Strike: Once per round as a standard action, you can call down a bolt of lightning that strikes any target you designate, as long as it is within 10 feet per effective 
binder level of your position. The lightning bolt deals 3d6 points of electricity damage, plus an additional 1d6 points of electricity damage for every three effective binder 
levels you possess above 5th. A successful Reflex save halves this damage. 
*/

#include "bnd_inc_bndfunc"

void main()
{
    //Declare major variables
    object oBinder = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_FOCALOR);
    int nDC = GetBinderDC(oBinder, VESTIGE_FOCALOR);
    int nDamage = d6(3 + ((nBinderLevel-5)/3));

    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY);
    if(nDamage > 0)
    {
        // Apply effects to the currently selected target.
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL), oTarget);
    }

}
