/*:://////////////////////////////////////////////
//:: Spell Name Energy Drain
//:: Spell FileName PHS_S_EnergyDrai
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Clr 9, Sor/Wiz 9
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
    attack succeeds, the subject gains 2d4 negative levels (not modified by a
    critical on any touch attack rolls).

    If the subject has at least as many negative levels as HD, it dies. Each
    negative level gives a creature a -1 penalty on attack rolls, saving throws,
    skill checks, ability checks, and effective level (for determining the
    power, duration, DC, and other details of spells or special abilities).

    Additionally, a spellcaster loses one spell or spell slot from his or her
    highest available level. Negative levels stack.

    Assuming the subject survives, it never regains the negative levels unless
    they are magically removed. Usually, negative levels have a chance of
    permanently draining the victim’s levels, but the negative levels from
    Energy Drain don’t last long enough to do so.

    An undead creature struck by the ray gains 2d4x5 temporary hit points for
    1 hour.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Ok, we remove the "24 hours until save again" in place of "no save, but
    doesn't remove XP".

    Might change later.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ENERGY_DRAIN)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // 2d4 negative levels
    int nNegativeLevels = PHS_MaximizeOrEmpower(4, 2, nMetaMagic);

    // Touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_RAY, oTarget, TRUE);

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
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ENERGY_DRAIN);

    // Touch beam effect
    PHS_ApplyTouchBeam(oTarget, VFX_BEAM_EVIL, nTouch);

    // Touch attack
    if(nTouch &&
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
                DelayCommand(fDelay, PHS_ApplyPermanentAndVFX(oTarget, eNegativeVis, eNegativeLevels));
            }
        }
    }
}
