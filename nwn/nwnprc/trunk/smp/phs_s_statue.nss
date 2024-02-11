/*:://////////////////////////////////////////////
//:: Spell Name Statue
//:: Spell FileName PHS_S_Statue
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Statue
    Transmutation
    Level: Sor/Wiz 7
    Components: V, S, M
    Casting Time: 1 round
    Range: Touch
    Target: Willing Creature touched
    Duration: 1 hour/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    A statue spell turns the subject to solid stone, along with any garments and
    equipment worn or carried. In statue form, the subject gains hardness 8. The
    subject retains its own hit points.

    The subject can see, hear, and smell normally, but it does not need to eat
    or breathe. Feeling is limited to those sensations that can affect the
    granite-hard substance of the individual’s body. Chipping is equal to a mere
    scratch, but breaking off one of the statue’s arms constitutes serious
    damage.

    The subject of a statue spell can return to its normal state, act, and then
    return instantly to the statue state (a free action) if it so desires, as
    long as the spell duration is in effect.

    This spell only works on player character allies. It will not operate on
    non-players, or non-allies.

    Material Component: Lime, sand, and a drop of water stirred by an iron bar,
    such as a nail or spike.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies a magical effect (for dispelling) which is cessate.

    Also creates a monster (with a heartbeat) to check for the spell (and remove
    the Granite effects if so) and also check if they wish to remove the
    spells effects.

    It will relay the instructions: "Whisper "move" to move again and "statue" to
    turn back into a statue"

    The creature will apply the first effects, too. It'll use the effects
    creator to determine which are the granite effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_STATUE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Must be a willing, PC character
    if(!GetFactionEqual(oCaster, oTarget) || !GetIsPC(oTarget))
    {
        // Must be a PC, in the party
        FloatingTextStringOnCreature("*You must cast Statue on a PC party member*", oCaster, FALSE);
        return;
    }

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Duration - 1 hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // These ones are to be used (not here) to provide the statue effect, and
    // will be supernatural
    /*
    // Hardness 8
    effect eHardness1 = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 8);
    effect eHardness2 = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 8);
    effect eHardness3 = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 8);
    // Visual and stopping effect
    // * Also adds all the things a statue would be immune to (criticals ETC)
    effect eStatue = PHS_CreateProperPetrifyEffectLink();

    // Link these effects
    effect eLink = EffectLinkEffects(eStatue, eHardness1);
    effect eLink = EffectLinkEffects(eLink, eHardness2);
    effect eLink = EffectLinkEffects(eLink, eHardness3);
    */

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_STATUE, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STATUE, FALSE);

    // Increment how many times this spell has been cast (for the following
    // creatures to measure)
    int nTimesCast = PHS_IncreaseStoredInteger(oTarget, "PHS_SPELL_STATUE_CAST_TIMES");

    // Create the creature to follow them.
    object oStatueMaker = CreateObject(OBJECT_TYPE_CREATURE, "phs_statuemaker", GetLocation(oTarget));

    // Set the integer of times cast, and the master of the creature
    SetLocalObject(oStatueMaker, "PHS_SPELL_STATUE_MASTER", oTarget);
    SetLocalInt(oStatueMaker, "PHS_SPELL_STATUE_CAST_TIMES", nTimesCast);

    // Tell the PC how to make themselves into a statue ETC.
    FloatingTextStringOnCreature("*To let yourself move again, whisper 'move'. Say 'statue' to become granite again*", oTarget, FALSE);

    // Apply effects to the target
    PHS_ApplyDuration(oTarget, eCessate, fDuration);
}
