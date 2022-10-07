/*:://////////////////////////////////////////////
//:: Spell Name Cone of Cold
//:: Spell FileName PHS_S_ConeofCold
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Cold]
    Level: Sor/Wiz 5, Water 6
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: 10M.
    Area: Cone-shaped burst
    Duration: Instantaneous
    Saving Throw: Reflex half
    Spell Resistance: Yes

    Cone of cold creates an area of extreme cold, originating at your hand and
    extending outward in a cone. It drains heat, dealing 1d6 points of cold damage
    per caster level (maximum 15d6).

    Arcane Material Component: A very small crystal or glass cone.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_CONE_OF_COLD)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;
    int nDam;

    // Maximum of 15d6 damage
    int nDice = PHS_LimitInteger(nCasterLevel, 15);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);

    // Cycle through all objects in the 20M cone.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CONE_OF_COLD);

            // Get delay
            fDelay = GetDistanceToObject(oTarget)/20;

            // Spell resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Damage in d6's
                nDam = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);

                // Saving throw (Reflex) VS cold for changes to nDam
                nDam = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_COLD, oCaster, fDelay);

                // Any damamge? Apply with VFX
                if(nDam > 0)
                {
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_COLD));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
