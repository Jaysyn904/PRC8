/*:://////////////////////////////////////////////
//:: Spell Name Invisibility Sphere
//:: Spell FileName PHS_S_InvisSph
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Glamer)
    Level: Brd 3, Sor/Wiz 3
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Personal or touch
    Area: 3.33-M.-radius emanation around the creature or object touched
    Duration: 1 min./level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell functions like invisibility, except that this spell confers
    invisibility upon all creatures within 3.33-M of the recipient. The center
    of the effect is mobile with the recipient.

    Any affected creature moving out of the area becomes visible, but creatures
    moving into the area after the spell is cast do not become invisible. Affected
    creatures (other than the recipient) who attack negate the invisibility only
    for themselves. If the spell recipient attacks, the invisibility sphere ends.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This will apply the invisiblity and AOE as one link - so that when the
    person attacks, the entire AOE gets removed :-)

    Also note that the effects for invsibility are only applied for the first
    1.0 seconds, and only applied OnEnter if this is set.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_INVISIBILITY_SPHERE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Determine duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eInvisibility = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_INVISIBILITY_SPHERE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eInvisibility, eAOE);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove pervious castings of it
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_INVISIBILITY_SPHERE, oTarget);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_INVISIBILITY_SPHERE, FALSE);

    // Set local on the CASTER (IE: Creator of the AOE)
    SetLocalInt(oCaster, "PHS_SPELL_INVISIBILITY_SPHERE_CAST", TRUE);
    DelayCommand(0.5, DeleteLocalInt(oCaster, "PHS_SPELL_INVISIBILITY_SPHERE_CAST"));

    // Apply VNF and effect.
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
