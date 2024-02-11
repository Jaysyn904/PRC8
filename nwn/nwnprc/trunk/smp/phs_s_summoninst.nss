/*:://////////////////////////////////////////////
//:: Spell Name Summon Instrument
//:: Spell FileName PHS_S_SummonInst
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Summon Instrument
    Conjuration (Summoning)
    Level: Brd 0
    Components: V, S
    Casting Time: 1 round
    Range: 0M.
    Effect: One summoned handheld musical instrument
    Duration: 1 min./level (D)
    Saving Throw: None
    Spell Resistance: No

    This spell summons one handheld musical instrument of your choice, a lyre,
    pipes, lute, guitar or tambourine. This instrument appears in your inventory.
    The instrument is typical for its type. Only one instrument appears per
    casting, and it will play only for you - you cannot drop it.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Basically, creates a magical instrument. More then one can be chosen, but
    are chosen in the spell menu.

    Could add in the bard song thing an optional part for instruments being
    needed (as D&D) - but that might mean to force them to continue singing
    or something...or perhaps just keeping the instrument equipped.

    Oh, and the desciption has been simplified and whatnot.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SUMMON_INSTRUMENT)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCnt;

    // Can be 0-4
    string sResRef = "phs_suminst_";

    // Destroy all other instruments
    for(nCnt = 0; nCnt <= 4; nCnt++)
    {
        PHS_ComponentItemRemove(sResRef + IntToString(nCnt));
    }
    // Get what we want to create
    int nInstrument;

    switch(GetSpellId())
    {
        case PHS_SPELL_SUMMON_INSTRUMENT_LUTE: nInstrument = 0; break;
        case PHS_SPELL_SUMMON_INSTRUMENT_PIPES: nInstrument = 1; break;
        case PHS_SPELL_SUMMON_INSTRUMENT_LYRE: nInstrument = 2; break;
        case PHS_SPELL_SUMMON_INSTRUMENT_GUITAR: nInstrument = 3; break;
        case PHS_SPELL_SUMMON_INSTRUMENT_TAMBOURINE: nInstrument = 4; break;
        default: nInstrument = 0; break;
    }
    // Finnish resref
    sResRef += IntToString(nInstrument);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SUMMON_INSTRUMENT, FALSE);

    // It is already plot and cursed (cannot be dropped) so create
    CreateItemOnObject(sResRef, oTarget);
}
