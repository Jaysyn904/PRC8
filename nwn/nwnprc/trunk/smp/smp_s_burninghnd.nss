/*:://////////////////////////////////////////////
//:: Spell Name Burning Hands
//:: Spell FileName SMP_S_BurningHnd
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Fire]
    Level: Fire 1, Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: 5M.
    Area: Cone-shaped burst
    Duration: Instantaneous
    Saving Throw: Reflex half
    Spell Resistance: Yes

    A cone of searing flame shoots from your fingertips. Any creature in the
    area of the flames takes 1d4 points of fire damage per caster level
    (maximum 5d4).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Minus flammable materials things.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    SpeakString("Burning hands start");

    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    SpeakString("Burning hands after hook");

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nDamage;
    int nDice = SMP_LimitInteger(nCasterLevel, 5);
    float fDelay;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    // Get all in a 5M (at the widest radius) cone
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 5.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        SpeakString("Burning hands loop: " + GetName(oTarget));

        // Reaction type PvP check.
        if(!GetIsReactionTypeFriendly(oTarget) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Signal Spell cast at event.
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BURNING_HANDS);

            // Get delay
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Spell Resistance and immunity check
            if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Damage
                nDamage = SMP_MaximizeOrEmpower(4, nDice, nMetaMagic);

                // Reflex save
                nDamage = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDamage, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster);

                // Check if any damage
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_FIRE));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 5.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    SpeakString("Burning hands end");
}
