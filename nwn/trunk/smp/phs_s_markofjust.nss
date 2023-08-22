/*:://////////////////////////////////////////////
//:: Spell Name Mark of Justice
//:: Spell FileName PHS_S_MarkofJust
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Clr 5, Pal 4
    Components: V, S, DF
    Casting Time: 10 minutes
    Range: Touch
    Target: Creature touched
    Duration: Permanent; see text
    Saving Throw: None
    Spell Resistance: Yes

    You draw an indelible mark on the subject and state some behavior on the part
    of the subject that will activate the mark. When activated, the mark curses
    the subject. Typically, you designate some sort of criminal behavior that
    activates the mark, but you can pick any act you please. The effect of the
    mark is identical with the effect of bestow curse.

    Since this spell takes 10 minutes to cast and involves writing on the target,
    you can cast it only on a creature that is willing or restrained.

    Like the effect of bestow curse, a mark of justice cannot be dispelled, but
    it can be removed with a break enchantment, limited wish, miracle, remove
    curse, or wish spell. Remove curse works only if its caster level is equal
    to or higher than your mark of justice caster level. These restrictions
    apply regardless of whether the mark has activated.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Target must be within 5 meters, as to be restrained or willing, as they
    can start casting and then the target move out of range in NwN.

    Not sure how to do this really, not fully anyway...

    I will, however, just do the whole casting on them to start with.

    Oh, and if it is cast on the caster itself, then it activates the mark
    with a local object as the target of the curse (-2 in all stats).

    Effects are supernatural.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget= GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    effect eVis, eCurse, eDur, eLink;

    // Check if oTarget == oCaster
    if(oTarget == oCaster)
    {
        // Check if we have a valid object
        object oCurse = GetLocalObject(oCaster, "PHS_MARK_JUSTICE_CURSETARGET");

        if(GetIsObjectValid(oCurse))
        {
            // Apply curse to oCurse
            eVis = EffectVisualEffect(PHS_VFX_IMP_MARK_OF_JUSTICE_CURSE);

            // Apply curse
            eCurse = EffectCurse(2, 2, 2, 2, 2, 2);
            eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

            // Link effects
            eLink = EffectLinkEffects(eCurse, eDur);
            eLink = SupernaturalEffect(eLink);

            // Apply it to the target. Can be broken as normal.
            PHS_ApplyPermanentAndVFX(oTarget, eVis, eDur);

            // Stop rest of the script.
            return;
        }
        // If not valid, we can activate such a mark on ourselves.
    }

    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MARK_OF_JUSTICE)) return;

    // Declare effects
    eVis = EffectVisualEffect(PHS_VFX_IMP_MARK_OF_JUSTICE);
    eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);

    // Make it a supernatural effect
    // - Cannot be dispelled
    eDur = SupernaturalEffect(eDur);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // they need to be in range
        if(GetDistanceToObject(oTarget) < 5.0)
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MARK_OF_JUSTICE);

            // Check spell reistance and immunity
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply the duration effect
                PHS_ApplyPermanentAndVFX(oTarget, eVis, eDur);
            }
        }
        else
        {
            FloatingTextStringOnCreature("You must be within range of the target to mark at the end of conjuring Mark of Justice.", oCaster, FALSE);
        }
    }
}
