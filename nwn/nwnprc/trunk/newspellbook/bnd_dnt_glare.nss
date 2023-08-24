/*
Scion of Dantalion - Dantalion's Glare

From 4th level on, you can use
a standard action to intensify Dantalion’s sign and glare
through its eyes. The starry voids in the eyes of Dantalion’s
sign blaze forth with the brightness of an exploding star,
affecting all creatures in a 30-foot cone. Every creature within
this area must succeed on a Fortitude save (DC 10 + 1/2 your
effective binder level + your Cha modifi er) or be blinded for
1d4 rounds. Once you have used this ability, you cannot do so again
for 5 rounds.

Strat 10/03/21
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    float fRange = FeetToMeters(30.0);    
    int nDC = 10 + GetBinderLevel(oBinder, VESTIGE_DANTALION)/2 + GetAbilityModifier(ABILITY_CHARISMA, oBinder);
    
    if(!BindAbilCooldown(oBinder, GetSpellId(), -1)) return;

    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oBinder && !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(d4()));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }   
}

