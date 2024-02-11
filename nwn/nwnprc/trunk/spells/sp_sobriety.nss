/*:://////////////////////////////////////////////
//:: Name      Sobriety
//:: FileName  sp_sobriety.nss
//:://////////////////////////////////////////////

Transmutation
Level: Wit 0
Components: V, S
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates (harmless)
Spell Resistance: Yes (harmless)

With a touch you immediately and completely eliminate
the effects of inebriation from one creature, regardless
of the amount of alcohol consumed. The target of the
spell becomes completely sober. All the effects of
alcohol are removed, leaving the subject clear-headed
and lucid. If applied to someone with a hangover from
drinking, this spell completely alleviates it as well.
Sobriety does not affect poisons or drugs other than
alcohol.

//:://////////////////////////////////////////////
//::////////////////////////////////////////////*/


#include "x2_inc_spellhook"
#include "prc_inc_clsfunc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode()) return;
    // End of Spell Cast Hook

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();

    //remove effects of alcohol
    RemoveAlcoholEffects(oTarget);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SOBRIETY, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REMOVE_CONDITION), oTarget);

    PRCSetSchool();
}