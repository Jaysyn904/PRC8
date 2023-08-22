/*:://////////////////////////////////////////////
//:: Spell Name Antiplant Shell
//:: Spell FileName PHS_S_AntiPlntS
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Casting Time: 1 standard action
    Range: 3.3 M.
    Area: 3.3-M.-radius emanation, centered on you
    Duration: 10 min./level (D)
    Saving Throw: None
    Spell Resistance: Yes

    The antiplant shell spell creates an invisible, mobile barrier that keeps
    all creatures within the shell protected from attacks by plant creatures or
    animated plants. As with many abjuration spells, forcing the barrier against
    creatures that the spell keeps at bay strains and collapses the field.
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
    effect eMob = EffectAreaOfEffect(PHS_AOE_MOB_ANTIPLANT_SHELL);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ANTIPLANT_SHELL, oTarget);

    // Set local integer so that the first ones will not be affected, which
    // is removed after 1.0 seconds.
    SetLocalInt(oTarget, PHS_MOVING_BARRIER_START, TRUE);
    DelayCommand(1.0, DeleteLocalInt(oTarget, PHS_MOVING_BARRIER_START));

    // Apply effects
    PHS_ApplyDuration(oTarget, eMob, fDuration);
}
