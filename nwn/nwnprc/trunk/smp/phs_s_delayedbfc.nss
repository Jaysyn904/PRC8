/*:://////////////////////////////////////////////
//:: Spell Name Delayed Blast Fireball: On Heartbeat
//:: Spell FileName PHS_S_DelayedBFC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses the Bioware AOE.

    This, if moved nearby to, will auto-explode.

    The caster can of course choose the duration - be it 1 heartbeat (or instant)
    to 5 heartbeats (or 5 rounds).

    The heartbeat script and OnEnter scripts do the stuff.

    OnHearbeat:
    - Run blast if entered
    - Run blast if the hearbeats == number set on caster.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    // We declare these here for, really, bug reasons.
    int nCasterLevel = PHS_GetAOECasterLevel();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();
    // TRUE if we have been triggered anyway.
    int bEntered = GetLocalInt(OBJECT_SELF, "PHS_DELAYED_BLAST_FIREBALL_ENTERED");
    // The amount of heartbeats until we blow - this increases the amount fired by 1.
    int nAmountofHBs = PHS_IncreaseStoredInteger(oTarget, "PHS_DELAYED_BLAST_FIREBALL_HBS");

    // User defined amount of HB's.
    int nUserHBs = PHS_LimitInteger(GetLocalInt(oCaster, "PHS_DELAYED_BLAST_FIREBALL_USER_HBS"));

    // Check if we are going to do the blast...
    if(bEntered == TRUE ||
       nAmountofHBs >= nUserHBs)
    {
        // Get dice based on caster level
        int nDice = PHS_LimitInteger(nCasterLevel, 20);
        // Get location to apply effects to etc.
        location lTarget = GetLocation(OBJECT_SELF);
        float fDelay;
        int nDam;

        // Declare Effects
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

        // Apply AOE visual
        effect eImpact = EffectVisualEffect(VFX_FNF_FIREBALL);
        PHS_ApplyLocationVFX(lTarget, eImpact);

        // Get all targets in a sphere, 6.67M radius, objects/placeables/doors.
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        // Loop targets
        while(GetIsObjectValid(oTarget))
        {
            // PvP Check
            if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
            // Make sure they are not immune to spells
               !PHS_TotalSpellImmunity(oTarget))
            {
                //Fire cast spell at event for the specified target
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DELAYED_BLAST_FIREBALL);

                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                // For this, it shouldn't be over 1.5 seconds. If it is, we limit it
                if(fDelay > 1.5) fDelay = 1.5;

                // Spell resistance And immunity checking.
                if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Roll damage for each target. No metamagic.
                    nDam = d6(nDice);

                    // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay);

                    // Need to do damage to apply visuals
                    if(nDam > 0)
                    {
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_FIRE));
                    }
                }
            }
            // Get Next Target
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
        // Finally, destroy ourselves after 2.0 seconds before next HB
        DestroyObject(OBJECT_SELF, 2.0);
    }
}
