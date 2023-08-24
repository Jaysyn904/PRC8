/*:://////////////////////////////////////////////
//:: Spell Name Knock
//:: Spell FileName PHS_S_Knock
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Knock
    Transmutation
    Level: Sor/Wiz 2
    Components: V
    Casting Time: 1 standard action
    Range: Medium (20M)
    Target: One door, box, or chest with an area of up to 3.33 sq. M./level
    Duration: Instantaneous; see text
    Saving Throw: None
    Spell Resistance: No

    The knock spell opens stuck, barred, locked, held, or arcane locked doors.
    It opens secret doors, as well as locked boxes or chests. It also loosens
    welds, shackles, or chains (provided they serve to hold closures shut). If
    used to open a arcane locked door, the spell does not remove the arcane
    lock but simply suspends its functioning for 10 minutes. In all other cases,
    the door does not relock itself or become stuck again on its own. Knock does
    not raise barred gates or similar impediments (such as a portcullis), nor
    does it affect ropes, vines, and the like. The effect is limited by the area.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell, mainly.

    I need to sort out doors - maybe add OnUnlocked events to make sure that
    Arcane Locked doors stay shut, for instance.

    It is easy to get a resref from the target door and check to see if it is
    a proper door.

    Maybe tag support and changed default blueprints for all placeables and doors
    for "knockable" and so on things...not sure...

    Anyway, the UMD check and declarations is here...
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_KNOCK)) return;

    // Delcare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    // Limit to 10 sq ft of door/level
    int nCasterLevel = PHS_GetCasterLevel();
    float fDelay = GetDistanceToObject(oTarget)/20;

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);

    // Signal spell cast at event.
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_KNOCK);

    // If the target is locked, unlock it
    // - No plot doors/placeables
    // - If it needs a key, and the key needed is "", IE cannot ever be opened, then
    //   ignore
    // - Ignore DC's of 100 or over
    if(GetLocked(oTarget) && !GetPlotFlag(oTarget) && GetLockLockDC(oTarget) < 100 &&
     (!GetLockKeyRequired(oTarget) || (GetLockKeyRequired(oTarget) && GetLockKeyTag(oTarget) != "")))
    {
        // Delay unlocking.
        DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
        DelayCommand(fDelay, SetLocked(oTarget, FALSE));
    }
}
