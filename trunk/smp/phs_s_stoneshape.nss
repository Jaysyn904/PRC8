/*:://////////////////////////////////////////////
//:: Spell Name Stone Shape
//:: Spell FileName PHS_S_StoneShape
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation [Earth]
    Level: Clr 3, Drd 3, Earth 3, Sor/Wiz 4
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Stone or stone object touched
    Duration: Instantaneous
    Saving Throw: Fortitude
    Spell Resistance: No

    You can form an existing piece of stone into any shape that suits your
    purpose. You can damage stone-based creatures and people affected by
    Stoneskin by touching them, whereupon you shape thier stone into odd shapes
    inflicting 1d10 points of damage per caster levels (Maximum 10d10). If the
    target makes a sucessful fortitude saving throw, the damage is halved.

    Arcane Material Component: Soft clay, which must be worked into roughly the
    desired shape of the stone object and then touched to the stone while the
    verbal component is uttered.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Stone monsters, or those with the Stoneskin spell upon them, are damaged
    if touched, and do get a fortitude save to half the highish damage.

    Ok, its not how it is meant to be - but its fair enough, and easily changed
    or removed later.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_STONE_SHAPE)) return;

    // Delcare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    // Damage is a maximum of 10d10
    int nDice = PHS_LimitInteger(nCasterLevel, 10);
    // Get damage - 1d10 per caster level
    int nDamage = PHS_MaximizeOrEmpower(nDice, 10, nMetaMagic);

    // Delcare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_ROCKEXPLODE);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DESTRUCTION);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Melee Touch attack
        if(PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget))
        {
            // Must be a stone creature or stoneskinned person.
            if(PHS_GetIsCrystalline(oTarget) ||
               GetHasSpellEffect(PHS_SPELL_STONESKIN, oTarget))
            {
                // Apply visual always (we at least do damage if immune/pass save)
                PHS_ApplyVFX(oTarget, eVis);

                // Saving throw for half damage
                nDamage = PHS_GetAdjustedDamage(SAVING_THROW_FORT, nDamage, oTarget, nSpellSaveDC);

                // Apply damage
                PHS_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_BLUDGEONING);
            }
        }
    }
}
