/*:://////////////////////////////////////////////
//:: Spell Name Fight Theme
//:: Spell FileName XXX_S_FightTheme
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Illusion [Phantasm] [Mind-Effecting]
    Level: Brd 2
    Components: V ("Hit it!")
    Casting Time: 1 standard action
    Range: 10M (30ft)
    Area: All allies and foes within a 10M-radius (30ft) burst centered on you
    Saving Throw: Will negate or Will negates (harmless)
    Spell Resistance: Yes or Yes (harmless)
    Source: Various (BlaineTog)

    Casting this spell causes an up-beat, frenetic music to fill the area.
    Essentially, its the music that they play to let you know when the battle
    has turned to the hero's.

    The tangible benefits are that the caster and all his or her allies in the
    area gain a +1 morale bonus to attack rolls and saves against fear, and all
    the caster's enemies take a -1 morale penalty to attack rolls and saves
    against fear if they fail their will save.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Will add some new .wav files for the casting/conjuring of these "music"
    spells.

    This is very prayerish, but still fun, and the music, I don't know what
    really...

    However, it'll just be a short extract, ideas:

    - Eye of the tiger
    - Something from gladiator
    - A big roll of drums

    How is "one fight" determined? Well, to be exact, it is until an AOE
    placed on each person decides the person it is on is dead, or not in
    combat (!GetIsInCombat()) for whatever reason (might be moved, away, killed
    everyone ETC).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(SMP_SpellHookCheck(SMP_SPELL_FIGHT_THEME)) return;

    // Define ourselves.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lSelf = GetLocation(oCaster);
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    float fDelay;
    // Duration - "permanent" until removed by AOE

    // Effect - attack +1, +1 saves, +1 damage, +1 skills
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eAttack = EffectAttackIncrease(1);
    effect eMorale = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    // Link effects
    effect eLink = EffectLinkEffects(eAttack, eMorale);
    eLink = EffectLinkEffects(eLink, eDur);

    // Bad effects - minus the above.
    effect eBadVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eBadAttack = EffectAttackDecrease(1);
    effect eBadMorale = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eBadDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    // Link effects
    effect eBadLink = EffectLinkEffects(eBadAttack, eBadMorale);
    eBadLink = EffectLinkEffects(eBadLink, eBadDur);

    // Same AOE each time. Previous ones are removed on any application of
    // new effects
    effect eAOE = EffectAreaOfEffect(SMP_AOE_MOB_FIGHT_THEME);

    // Link AOE
    eBadLink = EffectLinkEffects(eBadLink, eAOE);
    eLink = EffectLinkEffects(eLink, eAOE);

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    SMP_ApplyLocationVFX(lSelf, eImpact);

    // Loop allies - and apply the effects.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_30, lSelf);
    while(GetIsObjectValid(oTarget))
    {
        // Make sure they are not immune to spells
        if(!SMP_TotalSpellImmunity(oTarget))
        {
            // Check if ally or enemy
            if(GetIsFriend(oTarget) || GetFactionEqual(oTarget) || oTarget == oCaster)
            {
                // Fire cast spell at event for the specified target
                SMP_SignalSpellCastAt(oTarget, SMP_SPELL_FIGHT_THEME, FALSE);

                // Delay for visuals and effects.
                if(oTarget == oCaster)
                {
                    fDelay = 0.0;
                }
                else
                {
                    fDelay = GetDistanceBetween(oCaster, oTarget)/20;
                }
                // Remove previous effects of any type form this spell
                // - Won't overlap, and any bad effects are just ruined by new music
                SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_FIGHT_THEME, oTarget);

                // Apply the VFX impact and effects
                DelayCommand(fDelay, SMP_ApplyVFX(oTarget, eVis));
                SMP_ApplyPermanent(oTarget, eLink);
            }
            else
            {
                // Enemy/Non-friend

                // Fire cast spell at event for the specified target
                SMP_SignalSpellCastAt(oTarget, SMP_SPELL_FIGHT_THEME, TRUE);

                // Delay for visuals and effects.
                if(oTarget == oCaster)
                {
                    fDelay = 0.0;
                }
                else
                {
                    fDelay = GetDistanceBetween(oCaster, oTarget)/20;
                }

                // Spell resistance
                if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // Will saving throw
                    if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                    {
                        // Remove previous effects of any type form this spell
                        // - Won't overlap, and any bad effects are just ruined by new music
                        SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_FIGHT_THEME, oTarget);

                        // Apply the VFX impact and effects
                        DelayCommand(fDelay, SMP_ApplyVFX(oTarget, eBadVis));
                        SMP_ApplyPermanent(oTarget, eBadLink);
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_30, lSelf);
    }
}
