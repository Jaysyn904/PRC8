/*:://////////////////////////////////////////////
//:: Spell Name Ghoul Touch
//:: Spell FileName PHS_S_GhoulTouc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 2
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Target: Living humanoid touched
    Duration: 1d6+2 rounds
    Saving Throw: Fortitude negates
    Spell Resistance: Yes

    Imbuing you with negative energy, this spell allows you to paralyze a single
    living humanoid for the duration of the spell with a successful melee touch
    attack.

    Additionally, the paralyzed subject exudes a carrion stench that causes all
    living creatures (except you) in a 10-foot-radius spread to become sickened
    (Fortitude negates). A neutralize poison spell removes the effect from a
    sickened creature, and creatures immune to poison are unaffected by the
    stench.

    Material Component: A small scrap of cloth taken from clothing worn by a
    ghoul, or a pinch of earth from a ghoul’s lair.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Cannot decrease ability checks without decreasing the ability!

    But the rest is fine, as is the paralysis :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GHOUL_TOUCH)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Duration of this spell is random, 1d6 + 2 rounds.
    float fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 6, 1, nMetaMagic, 2);

    // Delcare Effects
    effect eAOE = EffectAreaOfEffect(AOE_MOB_TYRANT_FOG, "phs_s_ghoultucha"); // Mobile on the creature. Linked with rest.
    effect eParalyze = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eParalyze, eAOE);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GHOUL_TOUCH);

    // Do visuals for hit/miss
    PHS_ApplyTouchVisual(oTarget, VFX_COM_CHUNK_GREEN_MEDIUM, nTouch);

    // Melee Touch attack
    if(PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Spell resistance and immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Save - fortitude
                if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                {
                    // Apply linked effects (including the AOE)
                    PHS_ApplyDuration(oTarget, eLink, fDuration);
                }
            }
        }
    }
}
