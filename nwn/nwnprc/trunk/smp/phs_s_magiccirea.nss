/*:://////////////////////////////////////////////
//:: Spell Name Magic Circle against Evil - On Enter
//:: Spell FileName PHS_S_MagicCirEA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    AOE placed on the target.

    The On Enter will do pushback and apply effects. It applies it to ALL creatures.

    Only outsiders and summoned creatures will be affected by the pushback.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check area of effect creator
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    // oSelf is who we are on.
    object oSelf = OBJECT_SELF;
    object oTarget = GetEnteringObject();

    // Stop if they are not an alive thing, or is plot, or is a DM
    if(GetIsDM(oTarget) || GetPlotFlag(oTarget) || oTarget == oCaster) return;

    // 2 things.
    // - If they are summoned, do a SR check and if pass, let them in.
    // - Can be outsider
    if((GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER ||
        PHS_GetIsSummonedCreature(oTarget)) &&
        GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
    {
        // If we are starting still, do not hedge back
        if(!GetLocalInt(oCaster, PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL)))
        {
            // Because it was valid, we do a "pushback" check.

            // Check if we are moving, and therefore cannot force it agsint soemthing
            // that would be affected!
            vector vVector = GetPosition(oSelf);
            object oArea = GetArea(oSelf);
            DelayCommand(0.1, PHS_MobileAOECheck(oCaster, PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL, vVector, oArea));

            // VALID. Check SR now.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // We can push back

                // Therefore, this is 4 - Current Distance.
                float fDistance =  4.0 - GetDistanceBetween(oCaster, oTarget);

                // Debug stuff, obviously we'll need to move them at least 1 meter away.
                if(fDistance < 1.0)
                {
                    fDistance = 1.0;
                }

                // Move the enterer back from the caster.
                PHS_PerformMoveBack(oCaster, oTarget, fDistance, GetCommandable(oTarget));
            }
            // We do not push back. They are in fine now.
        }
    }

    // If they didn't move back, or not a summon, or whatever, we always
    // apply the bonuses!

    // Delcare effects
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);
    effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
    effect eImmunities = PHS_CreateCompulsionImmunityLink();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eAC);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eImmunities);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Make the link Versus Evil creatures only
    eLink = VersusAlignmentEffect(eLink, ALIGNMENT_ALL, ALIGNMENT_EVIL);

    // Remove previous castings
    if(PHS_RemoveProtectionFromAlignment(oTarget, ALIGNMENT_EVIL, 2)) return;

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL, FALSE);

    // Do AOE "add subtract" thing
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_MAGIC_CIRCLE_AGAINST_EVIL);
}
