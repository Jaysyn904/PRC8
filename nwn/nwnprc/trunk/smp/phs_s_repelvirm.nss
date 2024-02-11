/*:://////////////////////////////////////////////
//:: Spell Name Repel Vermin
//:: Spell FileName PHS_S_RepelVirm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 4, Clr 4, Drd 4, Rgr 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: 3.33M. (10 ft.)
    Area: 3.33-M.-radius (10 ft.) emanation, centered on you
    Duration: 10 min./level (D)
    Saving Throw: None or Will negates; see text
    Spell Resistance: Yes

    An invisible barrier holds back vermin. A vermin with Hit Dice of less than
    one-third your level cannot penetrate the barrier.

    A vermin with Hit Dice of one-third your level or more can penetrate the
    barrier if it succeeds on a Will save. Even so, crossing the barrier deals
    the vermin 2d6 points of damage, and pressing against the barrier causes
    pain, which deters most vermin.

    Any creature already inside the barrier at the time of casting can move
    normally, as they have not passed through the edge of the barrier.

    This spell may be used only defensively, not aggressively. If anything
    enters while you are moving, the barrier collapses.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As in Antilife Shell, this will repel vermin.

    They do get a will save (but take damage) and the rules for forcing it
    still apply.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_REPEL_VIRMIN)) return;

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
    effect eMob = EffectAreaOfEffect(PHS_AOE_MOB_REPEL_VIRMIN);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_REPEL_VIRMIN, oTarget);

    // Set local integer so that the first ones will not be affected, which
    // is removed after 1.0 seconds.
    string sLocal = PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_REPEL_VIRMIN);
    SetLocalInt(oCaster, sLocal, TRUE);
    DelayCommand(1.0, DeleteLocalInt(oCaster, sLocal));

    // Apply effects
    PHS_ApplyDuration(oTarget, eMob, fDuration);
}
