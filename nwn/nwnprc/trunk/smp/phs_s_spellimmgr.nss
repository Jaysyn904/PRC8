/*:://////////////////////////////////////////////
//:: Spell Name Spell Immunity, Greater
//:: Spell FileName PHS_S_SpellImmGr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 8
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 10 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The warded creature is immune to the effects of one specified spell for
    every four levels you have. The spells must be of 8th level or lower. The
    warded creature effectively has unbeatable spell resistance regarding the
    specified spell or spells. Naturally, that immunity doesn’t protect a
    creature from spells for which spell resistance doesn’t apply. Spell
    immunity protects against spells, spell-like effects of magic items, and
    innate spell-like abilities of creatures. It does not protect against
    supernatural or extraordinary abilities, such as breath weapons or gaze
    attacks.

    Only a particular spell can be protected against, not a certain domain or
    school of spells or a group of spells that are similar in effect.

    A creature can have only one spell immunity or greater spell immunity spell
    in effect on it at a time.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Will remove the previous spells (might as well, rather then saying "cannot
    cast").

    The spells to do are stored upon the PC's item, noting of course that the
    PC will also be notified of these.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SPELL_IMMUNITY_GREATER)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCnt, nSpell;
    float fDelay;
    string sName;

    // Get the amount of spells to resist
    int nResist = PHS_LimitInteger(nCasterLevel/4);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration - 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Start a link.
    effect eLink = eCessate;

    // We will add all the set spells into a effect
    effect eResist;

    // We loop (and may not do any if none are found)
    for(nCnt = 1; nCnt <= nResist; nCnt++)
    {
        // Get the spell Id to be immune to
        nSpell = GetLocalInt(oCaster, "PHS_SPELL_IMMUNITY_GREATER_SPELL" + IntToString(nCnt));

        // Error if the first spell is invalid!
        if(nSpell <= FALSE && nCnt == 1)
        {
            // Stop and report
            FloatingTextStringOnCreature("*You have not got any preference to what spells are made immune to*", oCaster, FALSE);
            return;
        }
        // If its valid, we add it to the link
        eResist = EffectSpellImmunity(nSpell);
        eLink = EffectLinkEffects(eLink, eResist);

        // We also report message
        fDelay += 0.2;
        sName = PHS_ArrayGetSpellName(nSpell);
        DelayCommand(fDelay, FloatingTextStringOnCreature("*You have been made immune to " + sName + "*", oTarget, FALSE));
    }

    // Remove the aid from previous castings.
    PHS_RemoveMultipleSpellEffectsFromTarget(oTarget, PHS_SPELL_SPELL_IMMUNITY, PHS_SPELL_SPELL_IMMUNITY_GREATER);

    // Signal event for the specified creature
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SPELL_IMMUNITY_GREATER, FALSE);

    // Apply the VFX and duration effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
