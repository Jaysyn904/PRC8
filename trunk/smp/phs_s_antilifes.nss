/*:://////////////////////////////////////////////
//:: Spell Name Antilife Shell
//:: Spell FileName PHS_S_AntilifeS
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    3.2M.- Radius, 10 min/level. Sepll resistance: Yes.

    Hedges out living creatures:
    - The effect hedges out animals, aberrations, dragons, fey, giants, humanoids,
    magical beasts, monstrous humanoids, oozes, plants, and vermin, but not
    constructs, elementals, outsiders, or undead.
    - Any creature already inside the Antilife Shell when cast can remain there.
    This spell may be used only defensively, not aggressively. If anything enters
    while moving, it breaks the spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It is a mobile barrier, with a special AOE.

    Basically, if the caster is doing an ACTION_TYPE_MOVE_TO_POINT and someone
    activates the OnEnter script, that creature makes the barrier collapse.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF.
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration in 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects - only an enter script.
    // - Use scripts defined in the 2da.
    effect eMob = EffectAreaOfEffect(PHS_AOE_MOB_ANTILIFE_SHELL);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ANTILIFE_SHELL, oTarget);

    // Set local integer so that the first ones will not be affected, which
    // is removed after 1.0 seconds.
    string sLocal = PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_ANTILIFE_SHELL);
    SetLocalInt(oCaster, sLocal, TRUE);
    DelayCommand(1.0, DeleteLocalInt(oCaster, sLocal));

    // Apply effects
    PHS_ApplyDuration(oTarget, eMob, fDuration);
}
