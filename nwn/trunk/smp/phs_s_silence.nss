/*:://////////////////////////////////////////////
//:: Spell Name Silence
//:: Spell FileName PHS_S_Silence
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion (Glamer)
    Level: Brd 2, Clr 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: 6.67-M.-radius emanation centered on a creature, object, or point in space
    Duration: 1 min./level (D)
    Saving Throw: Will negates; see text
    Spell Resistance: Yes; see text

    Upon the casting of this spell, complete silence prevails in the affected
    area. All sound is stopped: Conversation is impossible, spells with verbal
    components cannot be cast, and no noise whatsoever issues from, enters, or
    passes through the area. The spell can be cast on a point in space, but the
    effect is stationary unless cast on a mobile object. The spell can be
    centered on a creature, and the effect then radiates from the creature and
    moves as it moves. An unwilling creature (a hostile or neutral target, or
    any placeable object) can attempt a Will save to negate the spell and can
    use spell resistance, if any, to stop the spell being cast upon them. Once
    a creature enters into the spells area, they are silenced, and cannot save
    against its effects (Spell resistance and immunity still applied). This
    spell provides a defense against sonic or language-based attacks.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Silence:

    - When cast on a non-friend, has a will and resistance check
    -


//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_SILENCE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get duration in minues
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_MOB_SILENCE);

    // If the target is valid, they might be able to save
    if(GetIsObjectValid(oTarget))
    {
        // PvP check and spell immunity check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Rep check.
            if(!GetIsFriend(oTarget))
            {
                // Signal Spell cast at
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SILENCE, TRUE);

                // Spell resistance check
                if(!PHS_SpellResistanceCheck(oCaster, oTarget))
                {
                    // Will saving throw check
                    if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                    {
                        // Apply the AOE
                        PHS_ApplyDuration(oTarget, eAOE, fDuration);
                    }
                }
            }
            else
            {
                // Signal Spell cast at
                PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SILENCE, FALSE);

                // Apply the AOE
                PHS_ApplyDuration(oTarget, eAOE, fDuration);
            }
        }
    }
    else
    {
        // Apply at location
        PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
    }
}
