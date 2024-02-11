/*:://////////////////////////////////////////////
//:: Spell Name Enervation
//:: Spell FileName PHS_S_Enervation
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray of negative energy
    Duration: 1 hour/level
    Saving Throw: None
    Spell Resistance: Yes

    You point your finger and utter the incantation, releasing a black ray of
    crackling negative energy that suppresses the life force of any living
    creature it strikes. You must make a ranged touch attack to hit. If the
    attack succeeds, the subject gains 1d4 negative levels (not modified by a
    critical on any touch attack rolls).

    If the subject has at least as many negative levels as HD, it dies. Each
    negative level gives a creature a -1 penalty on attack rolls, saving throws,
    skill checks, ability checks, and effective level (for determining the power,
    duration, DC, and other details of spells or special abilities).

    Additionally, a spellcaster loses one spell or spell slot from his or her
    highest available level. Negative levels stack.

    Assuming the subject survives, it regains lost levels after a number of
    hours equal to your caster level (maximum 15 hours). Usually, negative
    levels have a chance of permanently draining the victim’s levels, but the
    negative levels from enervation don’t last long enough to do so.

    An undead creature struck by the ray gains 1d4x5 temporary hit points for
    1 hour.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Delayed application of the effect, so it stacks.

    Can be cast if they have the effect.

    The temp HP also stacks!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ENERVATION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // 1d4 negative levels
    int nNegativeLevels = PHS_MaximizeOrEmpower(4, 1, nMetaMagic);

    // Duration in hours (max 15)
    float fDuration = PHS_GetDuration(PHS_HOURS, PHS_LimitInteger(nCasterLevel, 15), nMetaMagic);
    // 1 hour
    float fDurationHP = PHS_GetDuration(PHS_HOURS, 1, nMetaMagic);
    // Delay is Range based
    float fDelay = GetDistanceToObject(oTarget)/10;

    // Declare effects
    effect eNegativeLevels = EffectNegativeLevel(nNegativeLevels);
    effect eNegativeVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eNegativeBeam;
    // Good effects
    effect eTempHP = EffectTemporaryHitpoints(nNegativeLevels * 5);
    effect eTempHPCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eTempHPVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    // Link good
    effect eLinkHP = EffectLinkEffects(eTempHP, eTempHPCessate);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ENERVATION);

    // Touch beam effect
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_EVIL, nTouch);

    // Ray ranged Touch attack
    if(PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Undead check (if undead, we always apply temp HP)
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            // Temp HP
            DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eTempHPVis, eLinkHP, fDurationHP));
        }
        // Reaction type check
        else if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Else we will check spell resistance and immunty, then apply
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Apply
                DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eNegativeVis, eNegativeLevels, fDuration));
            }
        }
    }
}
