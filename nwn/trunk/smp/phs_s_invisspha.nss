/*:://////////////////////////////////////////////
//:: Spell Name Invisibility Sphere: On Enter
//:: Spell FileName PHS_S_InvisSphA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This will apply the invisiblity and AOE as one link - so that when the
    person attacks, the entire AOE gets removed :-)

    Also note that the effects for invsibility are only applied for the first
    1.0 seconds, and only applied OnEnter if this is set.

    On Enter:
    - If the creator has the integer PHS_SPELL_INVISIBILITY_SPHERE_CAST then
      we apply invisibility to all those who enter.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    // We need the local for invisibility sphere.
    if(!GetLocalInt(oCaster, "PHS_SPELL_INVISIBILITY_SPHERE_CAST")) return;

    // Declare effects
    effect eInvisibility = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eInvisibility, eCessate);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INVISIBILITY_SPHERE, FALSE);

    // Apply the On Enter effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_INVISIBILITY_SPHERE);
}
