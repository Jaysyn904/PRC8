/*:://////////////////////////////////////////////
//:: Spell Name Prestidigitation
//:: Spell FileName PHS_S_Prestidigi
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Universal
    Level: Brd 0, Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: See Text
    Effect: See text
    Duration: 1 hour
    Saving Throw: See text
    Spell Resistance: No

    Prestidigitations are minor tricks that novice spellcasters use for
    practice. Once cast, a prestidigitation spell enables you to perform simple
    magical effects for 1 hour. The magical tricks performed are visual and
    consist of a varying amount of small visual effects. Once cast, you may
    conjure these small effects for the duration, including finger fire, card
    throwing, spinning balls of colour and so on.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Not complete.

    This will allow the use of the spell to conjure small visual effects for
    the duration.

    So simple. It uses the master kinda thing, for up to 5 set visuals. Either
    this can be changed in the menus (maybe) or not.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_PRESTIDIGITATION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // If the item being used is not the ability item, we will apply the
    // duration effects for 1 hour.
    if(GetTag(GetSpellCastItem()) != "PHS_CLASS_ITEM")
    {
        // Declare effect
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        // Get duration (one hour)
        float fDuration = PHS_GetDuration(PHS_HOURS, 1, nMetaMagic);

        // Remove previous castings
        PHS_RemoveMultipleSpellEffectsFromTarget(oTarget, PHS_SPELL_PRESTIDIGITATION,
                                                          PHS_SPELL_PRESTIDIGITATION_VFX1,
                                                          PHS_SPELL_PRESTIDIGITATION_VFX2,
                                                          PHS_SPELL_PRESTIDIGITATION_VFX3,
                                                          PHS_SPELL_PRESTIDIGITATION_VFX4,
                                                          PHS_SPELL_PRESTIDIGITATION_VFX5);

        // Apply it for duration
        PHS_ApplyDuration(oTarget, eDur, fDuration);
    }
    else
    {
        // Else it is, check if they do have the spell's effects, else fail.
        if(!GetHasSpellEffect(PHS_SPELL_PRESTIDIGITATION, oCaster) &&
           !GetHasSpellEffect(PHS_SPELL_PRESTIDIGITATION_VFX1, oCaster) &&
           !GetHasSpellEffect(PHS_SPELL_PRESTIDIGITATION_VFX2, oCaster) &&
           !GetHasSpellEffect(PHS_SPELL_PRESTIDIGITATION_VFX3, oCaster) &&
           !GetHasSpellEffect(PHS_SPELL_PRESTIDIGITATION_VFX4, oCaster) &&
           !GetHasSpellEffect(PHS_SPELL_PRESTIDIGITATION_VFX5, oCaster))
        {
            // Stop
            return;
        }
    //const int PHS_SPELL_PRESTIDIGITATION_VFX1           = 101;
    //const int PHS_SPELL_PRESTIDIGITATION_VFX2           = 102;
    //const int PHS_SPELL_PRESTIDIGITATION_VFX3           = 103;
    //const int PHS_SPELL_PRESTIDIGITATION_VFX4           = 104;
    //const int PHS_SPELL_PRESTIDIGITATION_VFX5           = 105;
    }
}
