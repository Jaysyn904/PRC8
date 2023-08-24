/*:://////////////////////////////////////////////
//:: Spell Name Dimensional Anchor
//:: Spell FileName PHS_S_dimenanchr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Dimensional Anchor
    Abjuration
    Level: Clr 4, Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Ray
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: Yes

    A ray springs from your outstretched hand. You must make a ranged
    touch attack to hit the target. Any creature or object struck by the ray is
    covered with a shimmering emerald field that completely blocks
    extradimensional travel. Forms of movement barred by a dimensional anchor
    include astral projection, blink, dimension door, ethereal jaunt,
    etherealness, gate, maze, plane shift, shadow walk, teleport, and similar
    spell-like or psionic abilities. The spell also prevents the use of a gate
    or teleportation circle for the duration of the spell.

    A dimensional anchor does not interfere with the movement of creatures
    already in ethereal or astral form when the spell is cast, nor does it
    block extradimensional perception or attack forms. Also, dimensional anchor
    does not prevent summoned creatures from disappearing at the end of a
    summoning spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Checked for in PHS_CannotTeleport.

    It stops some forms of teleport and so on.

    Also can be checked with GetHasSpellEffect.

    Visual effect only.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_DIMENSIONAL_ANCHOR)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // 1 min/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eDur = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DIMENSIONAL_ANCHOR);

    // Beam hit/miss. Green ray.
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_DISINTEGRATE, nTouch);

    // Touch attack - Ray ranged
    if(PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE))
    {
        // Spell resistance and immunity
        if(!PHS_SpellResistanceCheck(oCaster, oTarget))
        {
            // Remove previous castings of it
            PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_DIMENSIONAL_ANCHOR, oTarget);

            // Apply new effects
            PHS_ApplyDuration(oTarget, eDur, fDuration);
        }
    }
}
