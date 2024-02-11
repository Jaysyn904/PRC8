/*:://////////////////////////////////////////////
//:: Spell Name Confusion
//:: Spell FileName PHS_S_Confusion
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Medium (20M) Targets: Enemies in Large Area (5M)
    Duration: 1 round/level. Will negats, SR applies.

    This spell causes the targets to become confused, making them unable to
    independently determine what they will do.

    Roll on the following table at the beginning of each subject’s turn each
    round to see what the subject does in that round.

    d%      Behavior
    01-10   Attack caster with melee or ranged weapons (or close with caster if
            attack is not possible).
    11-20   Act normally.
    21-50   Do nothing but babble incoherently.
    51-70   Flee away from caster at top possible speed.
    71-100  Attack nearest creature (for this purpose, a familiar counts as
            part of the subject’s self).

    A confused character who can’t carry out the indicated action does nothing
    but babble incoherently. Attackers are not at any special advantage when
    attacking a confused character. Any confused character who is attacked
    automatically attacks its attackers on its next turn, as long as it is still
    confused when its turn comes. Note that a confused character will not make
    attacks of opportunity against any creature that it is not already devoted
    to attacking (either because of its most recent action or because it has
    just been attacked).

    Arcane Material Component: A set of three nut shells.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies confusion effect as par spell description. As you cannot choose targets
    well in NwN, it only affects enemies.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_CONFUSION)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;

    // 1 round/level duration.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eDur, eConfuse);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Apply AOE at the location
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Search through target area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        // Must be a hostile target (and take into account PvP!)
        if(GetIsReactionTypeHostile(oTarget))
        {
           // Fire cast spell at event for the specified target
           PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CONFUSION);

           // Get a random short delay
           fDelay = PHS_GetRandomDelay(0.1, 0.5);

           // Check spell resistance and immunity
           if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
           {
                // Make Will Save against Mind spells
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                    // Apply effecs
                    DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration));
                }
            }
        }
        // Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    }
}

