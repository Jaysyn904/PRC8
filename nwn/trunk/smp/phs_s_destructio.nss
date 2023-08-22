/*:://////////////////////////////////////////////
//:: Spell Name Destruction
//:: Spell FileName PHS_S_Destructio
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy [Death]
    Level: Clr 7, Death 7
    Components: V, S, F
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature
    Duration: Instantaneous
    Saving Throw: Fortitude partial
    Spell Resistance: Yes

    This spell instantly slays the subject and consumes its remains (but not its
    equipment and possessions) utterly. If the target’s Fortitude saving throw
    succeeds, it instead takes 10d6 points of damage. The only way to restore
    life to a character who has failed to save against this spell is to use true
    resurrection, a carefully worded wish spell followed by resurrection, or
    miracle.

    Focus: A special holy (or unholy) symbol of silver marked with verses of
    anathema (cost 500 gp).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.

    Resurrection for PC's leave up to the module builder - but NPC's do not
    leave a corpse at all.

    The thing is a focus, not a material component.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DESTRUCTION)) return;

    // Check for the focus, a holy symbol.
    if(!PHS_ComponentFocusItem(PHS_ITEM_HOLY_SYMBOL_500, "Holy Symbol with verses of anathema", "Destruction")) return;

    // Delcare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDamage = PHS_MaximizeOrEmpower(6, 10, nMetaMagic);

    // Delcare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION);
    // - Spectacular death.
    effect eDeath = EffectDeath(TRUE);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DESTRUCTION);

    // PvP Check
    if(!GetIsReactionTypeFriendly(oTarget) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Spell Resistance + Immunity
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Apply visual always (we at least do damage if immune/pass save)
            PHS_ApplyVFX(oTarget, eVis);

            // Fortitude save
            if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_DEATH))
            {
                // - Death on fail
                PHS_ApplyInstant(oTarget, eDeath);
                // If it is an NPC, destroy the body after death
                if(!GetIsPC(oTarget))
                {
                    ExecuteScript("phs_1_npcdestroy", oTarget);
                }
            }
            else
            {
                // - 10d6 damage on pass
                PHS_ApplyDamageToObject(oTarget, nDamage, DAMAGE_TYPE_DIVINE);
            }
        }
    }
}
