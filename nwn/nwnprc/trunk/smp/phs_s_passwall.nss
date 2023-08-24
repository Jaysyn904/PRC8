/*:://////////////////////////////////////////////
//:: Spell Name Passwall
//:: Spell FileName PHS_S_Passwall
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Sor/Wiz 5
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Effect: 2M. by 6M. opening, 3M. deep plus 1.5M. deep per three additional
            levels
    Duration: 1 hour/level (D)
    Saving Throw: None
    Spell Resistance: No
    DM Spell: Yes

    This is a DM spell only. The description below describes what should happen.
    Only a visual effect applied at the target location and notification of the
    duration will be told to DM's who can then move people through suitable
    walls.

    You create a passage through wooden, plaster, or stone walls, but not through
    metal or other harder materials. The passage is 3 meters deep plus an
    additional 1.5 meters deep per three caster levels above 9th (4.5 meters at
    12th, 6 meters at 15th, and a maximum of 7.5 meters deep at 18th level). If
    the wall’s thickness is more than the depth of the passage created, then a
    single passwall simply makes a niche or short tunnel. Several passwall spells
    can then form a continuing passage to breach very thick walls. When passwall
    ends, creatures within the passage are ejected out the nearest exit. If
    someone dispels the passwall or you dismiss it, creatures in the passage are
    ejected out the far exit, if there is one, or out the sole exit if there is
    only one.

    Material Component: A pinch of sesame seeds.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    DM spell only.

    Will report to a DM, and play some VFX.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PASSWALL)) return;

    // Declare Major Variables
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PASSWALL, FALSE);

    // Create the VFX
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

    // Apply the effect.
    PHS_ApplyVFX(oTarget, eVis);


    // Send DM's the message on the amount of wall to pass through

    // The passage is 3 meters deep plus an additional 1.5 meters deep per
    // three caster levels above 9th (4.5 meters at 12th, 6 meters at 15th,
    // and a maximum of 7.5 meters deep at 18th level).
    float fMeters = 3.0;
    if(nCasterLevel >= 18)
    {
        fMeters = 7.5;
    }
    else if(nCasterLevel >= 15)
    {
        fMeters = 6.0;
    }
    else if(nCasterLevel >= 12)
    {
        fMeters = 4.5;
    }
    else // if(nCasterLevel >= 0)
    {
        fMeters = 3.0;
    }

    // Signal the spell cast to DM's.
    PHS_AlertDMsOfSpell("Passwall", FALSE, nCasterLevel);

    // Report size of tunnel
    SendMessageToAllDMs("Passwall size: " + FloatToString(fMeters));
}
