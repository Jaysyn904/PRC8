/*:://////////////////////////////////////////////
//:: Spell Name Song of Discord
//:: Spell FileName PHS_S_SongOfDisc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting, Sonic]
    Level: Brd 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: Creatures within a 6.67-M.-radius spread
    Duration: 1 round/level
    Saving Throw: Will negates
    Spell Resistance: Yes

    This spell causes those within the area to turn on each other rather than
    attack their foes, applying a confusion-like effect onto thier minds. Each
    affected creature has a 50% chance to attack the nearest target each round.
    (Roll to determine each creature’s behavior every round at the beginning of
    its turn.) A creature that does not attack its nearest neighbor is free to
    act normally for that round.

    Creatures forced by a song of discord to attack their fellows employ all
    methods at their disposal, choosing their deadliest spells and most
    advantageous combat tactics. They do not, however, harm targets that have
    fallen unconscious.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses EffectConfusion and changes the confusion heartbeat.

    50% chance of them attacking the nearest target - uses another script to
    choose either ranged attacks, melee attacks, or thier best spell to cast
    against the nearest target (dispite if it'll affect them or not)

    Can affect allies!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_SONG_OF_DISCORD)) return;

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

    // Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eDur, eConfuse);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    PHS_ApplyLocationVFX(lTarget, eImpact);

    // Search through target area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(GetIsReactionTypeHostile(oTarget))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SONG_OF_DISCORD);

            // Must be able to hear
            if(PHS_GetCanHear(oTarget))
            {
                // Get a random short delay
                fDelay = PHS_GetRandomDelay(0.1, 0.5);

                // Check spell resistance and immunity
                if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Check mind immunity and confusion immunity
                    if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_CONFUSED, fDelay, oCaster) &&
                       !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS, fDelay, oCaster))
                    {
                        // Make Will Save against Mind spells
                        if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                        {
                            // Apply effecs
                            DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
                            PHS_ApplyDuration(oTarget, eLink, fDuration);
                        }
                    }
                }
            }
        }
        // Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget);
    }
}
