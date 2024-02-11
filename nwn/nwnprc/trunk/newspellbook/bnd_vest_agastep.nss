/*
03/03/21 by Stratovarius

Agares, Truth Betrayed
  
Agares died at the hands of his allies for a wrong he did not commit. As a vestige, not only does he give binders the ability to weaken foes and knock them prone, but he also makes his summoner fearless.

Vestige Level: 4th
Binding DC: 22
Special Requirement: You must draw Agares’s seal upon either the earth or an expanse of unworked stone.

Influence: Agares’s loyalty in life and his anger at the betrayal perpetrated by his lieutenants has become a hatred of falsehood. When influenced
by Agares, you speak forthrightly and with confidence. You cannot use the Bluff skill, and when asked a direct question, you must answer truthfully and directly.

Granted Abilities: 
Agares gives you the power to exalt yourself and your allies, to make the earth tremble beneath your feet, and to render foes weak.

Earthshaking Step: As a standard action, you can stomp on the ground, causing every creature within 10 feet of you to make a Reflex save or fall prone. 
Once you have used this ability, you cannot do so again for 5 rounds. You and your summoned earth elemental (see below) are never knocked prone by the use of this ability.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_AGARES)) return;
    int nDC        = GetBinderDC(oBinder, VESTIGE_AGARES);
    effect eLink   = EffectLinkEffects(EffectKnockdown(), EffectVisualEffect(VFX_IMP_SONIC));
    float fRange   = FeetToMeters(10.0f);
    float fDelay;
    object oTarget;
    location lTarget  = PRCGetSpellTargetLocation();

    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oBinder                                             &&      // Avoid the cone targeting bug
           GetMaster(oTarget) != oBinder &&                                      // No hitting your summons
           GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE      && // Incorporeal creatures are not affected
           !GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN)                        // And the creature is not just generally immune to knockdown
           )
        {
            // Save - Reflex negates
            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
                // Apply effects
                fDelay = GetDistanceBetween(oBinder, oTarget) / 20.0f;
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0));
            }// end if - Save
        }// end if - Targeting check

        // Get next target
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }// end while - Target loop
}
