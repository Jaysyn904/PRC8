/*:://////////////////////////////////////////////
//:: Spell Name Call Chaos
//:: Spell FileName XXX_S_CallChaos
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Chaos]
    Level: Clr 5, Sor/Wiz 5
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Personal
    Effect: 20.0M-radius burst (60-ft.)
    Duration: Instantaneous; see text
    Saving Throw: Special; see text
    Spell Resistance: Yes; see text
    Source: Various (Arilou_skiff)

    This spell calls pure chaos to wreak havoc upon the battlefield, roll a d20
    for every creature (including the caster!) within the burst range, and look
    up the effect on the following list of possible effects. Generally, hope for
    a higher roll on the list.

    1. Creature must make a fortitude save, or be petrified for 10 minutes/level.
    2. An attempt to dispel all magic is done on the target, at a base 1d20 +
       1/caster level (Maximum +10) roll, as if Dispel Magic had been cast on them.
    3. Creature must make a will save, or be polymorphed into a penguin for 10
       minutes/level.
    4. Creature pulses red for 1 minute/level.
    5. Creature must make a will save or is slowed for 1 round/level.
    6. Creature loses 1d6 gold coins/caster level, unless the gold makes a will
       save using the creatures own will save.
    7. Gems explode around the caster, dealing 2d6 damage, but real minor gems
       appear around the creatures feet.
    8. Creature bursts into flames, taking 2d6 + 1/caster level, (Max 2d6 + 20)
       damage, reflex save for half.
    9. A loud noise affects the Creature (if they can hear) and must make a will
       save, or is stunned for 1 round/level.
    10. Creature suffers 3d6 points of electircal damage, but is also hasted for
        1d10 minutes.
    11. Creature must make a will save, or be deafened for 1 minute/level.
    12. Creature becomes agile and fast, gaining +4 dexterity for 1 minute/level.
    13. Creature is entangled, for 1d6 rounds.
    14. Creature is made invisible (as the spell) for 1 round/level.
    15. Creature, if living, is healed for 5d6 + 1/caster level damage, undead
        must make a will save or take the same in damage.
    16. Creature is silenced (as the spell), unless they make a sucessful will
        save, for 1 round/level.
    17. Creature is surrounded by a Fire Shield, which mearly does 1d6 damage
        to melee attackers, for 1 minute/level.
    18. Creature is made more combat aware, and gains +2 damage and +2 to hit,
        for 1 round/level.
    19. Creature is healed of all mental effects (Confusion, Domination,
        Charming, Insanity).
    20. Creature has a small Globe of Invunrability on them for 1 minute/level,
        making them immune to all 1 and 0 level spells.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is lowered in its effects (well, some of them) then the "original",
    beucause some were much too silly or stupid for a mear level 5 spell with
    a huge range.

    Of course, the caster can resist things (thus resisting themselves, as if
    they cast fireball on themselves, heh).

    Effects were made with NwN in mind!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

// Do chaos effects to oTarget.
// * Easier to code like this.
// * SR and PvP are in the loop. This will not work (even if good) on people who resist.
// * Uses fDelay to apply the effects, and do saves ETC.
void DoChaosEffects(object oTarget, object oCaster, float fDelay, int nSpellSaveDC, int nCasterLevel, int nMetaMagic);

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_CALL_CHAOS)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();// Should be OBJECT_SELF's location
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    float fDelay;

    // Apply AOE visual
    effect eImpact = EffectVisualEffect(SMP_VFX_FNF_CALL_CHAOS);
    SMP_ApplyLocationVFX(lTarget, eImpact);

    // Get all targets in a sphere, around the caster, 20.0M
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CALL_CHAOS, GetIsEnemy(oTarget));

            // Get a random delay.
            fDelay = SMP_GetRandomDelay(0.1, 1.0);

            // GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Chaos effects
                DoChaosEffects(oTarget, oCaster, fDelay, nSpellSaveDC, nCasterLevel, nMetaMagic);
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

// Do chaos effects to oTarget.
// * Easier to code like this.
// SR is done in the loop, as are PvP checks.
// * Uses fDelay to apply the effects, and do saves ETC.
void DoChaosEffects(object oTarget, object oCaster, float fDelay, int nSpellSaveDC, int nCasterLevel, int nMetaMagic)
{
    // Randomise it
    int nRand = d20();
    float fDuration;

    switch(nRand)
    {
//    1. Creature must make a fortitude save, or be petrified for 10 minutes/level.
        case 1:
        {
            // * Exit if creature is immune to petrification
            if(SMP_SpellsIsImmuneToPetrification(oTarget)) return;

            // Fortitude save
            if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay))
            {
                // Declare effects
                effect ePetrify = SMP_CreateProperPetrifyEffectLink();
                // Get duration
                fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel * 10, nMetaMagic);

                // Apply it for the duration
                DelayCommand(fDelay, SMP_ApplyDuration(oTarget, ePetrify, fDuration));
            }
        }
        break;
//    2. An attempt to dispel all magic is done on the target, at a base 1d20 +
//       1/caster level (Maximum +10) roll, as if Dispel Magic had been cast on them.
        case 2:
        {
            // Apply dispel magic to them, no special checks - just basic
            // dispel magic all.
            effect eDispel = EffectDispelMagicAll(SMP_LimitInteger(nCasterLevel, 10));
            effect eDispelVis = EffectVisualEffect(VFX_IMP_DISPEL);

            // Apply it with VFX
            DelayCommand(fDelay, SMP_ApplyInstantAndVFX(oTarget, eDispelVis, eDispel));
        }
        break;
//    3. Creature must make a will save, or be polymorphed into a penguin for 10
//       minutes/level.
        case 3:
        {
            // Will save
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay))
            {
                // Apply the polymorph
                effect ePenguin = EffectPolymorph(POLYMORPH_TYPE_PENGUIN, TRUE);
                effect ePenguinVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

                // Get duration
                fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel * 10, nMetaMagic);

                // Apply the visual and effect
                DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, ePenguinVis, ePenguin, fDuration));
            }
        }
        break;
//    4. Creature glows red for 1 minute/level, emmiting light like a torch would.
        case 4:
        {
            // Just glow.
            effect eGlow = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

            // Get duration
            fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

            // Apply the glow.
            DelayCommand(fDelay, SMP_ApplyDuration(oTarget, eGlow, fDuration));
        }
        break;
//    5. Creature must make a will save or is slowed for 1 round/level.
        case 5:
        {
            // Will save
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay))
            {
                // Apply the slowing
                effect eSlow = EffectSlow();
                effect eSlowCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eSlowLink = EffectLinkEffects(eSlow, eSlowCessate);
                effect eSlowVis = EffectVisualEffect(VFX_IMP_SLOW);

                // Get duration
                fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

                // Apply the visual and effect
                DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eSlowVis, eSlow, fDuration));
            }
        }
        break;
//    6. Creature loses 1d6 gold coins/caster level, unless the gold makes a will
//       save using the creatures own will save.
        case 6:
        {
            // Will save
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay))
            {
                // Get gold to lose
                int nGold = SMP_MaximizeOrEmpower(6, nCasterLevel, nMetaMagic);
                // Lose some gold
                TakeGoldFromCreature(nGold, oTarget, TRUE);
            }
        }
        break;
//    7. Gems explode around the caster, dealing 2d6 damage, but real minor gems
//       appear around the creatures feet.
        case 7:
        {
            // Get damage, and gems to create
            int nGems = SMP_MaximizeOrEmpower(6, 2, nMetaMagic);

            // Declare effects
            effect eGemVis = EffectVisualEffect(SMP_VFX_IMP_GEM_EXPLODE);

            // Do damage
            DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eGemVis, nGems));

            // Create some gems around the caster
            location lTarget = GetLocation(oTarget);
            int nCnt;
            for(nCnt = 1; nCnt <= nGems; nCnt++)
            {
                // Choose a random position around the caster
                SMP_GetRandomLocation(lTarget, 1);

                // Create a gem there
                CreateObject(OBJECT_TYPE_ITEM, "SMP_callchaosgem", lTarget);
            }
        }
        break;
//    8. Creature bursts into flames, taking 2d6 + 1/caster level, (Max 2d6 + 20)
//       damage, reflex save for half.
        case 8:
        {
            // 2d6 + 1/level damage, reflex for half.
            int nFlameDam = SMP_MaximizeOrEmpower(6, 2, nMetaMagic, SMP_LimitInteger(nCasterLevel, 20));

            // Change damage on a reflex save
            nFlameDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nFlameDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay);

            // Do damage, if any
            if(nFlameDam > 0)
            {
                effect eFlameVis = EffectVisualEffect(VFX_IMP_FLAME_M);

                // Delay damage
                DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eFlameVis, nFlameDam, DAMAGE_TYPE_FIRE));
            }
        }
        break;
//    9. A loud noise affects the Creature (if they can hear) and must make a will
//       save, or is stunned for 1 round/level.
        case 9:
        {
            // Do the visual always
            effect eLoudImpact = EffectVisualEffect(VFX_FNF_SOUND_BURST);
            location lTarget = GetLocation(oTarget);
            float fNewDelay = fDelay;
            if(fNewDelay > 0.2) fNewDelay -= 0.1;
            DelayCommand(fNewDelay, SMP_ApplyLocationVFX(lTarget, eLoudImpact));

            // Must be able to hear
            if(SMP_GetCanHear(oTarget))
            {
                // Will save negates
                if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay))
                {
                    // Do stunning
                    effect eStun = EffectStunned();
                    effect eStunImp = EffectVisualEffect(VFX_IMP_STUN);
                    effect eStunDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                    effect eStunCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    effect eStunLink = EffectLinkEffects(eStun, eStunCessate);
                    eStunLink = EffectLinkEffects(eStunLink, eStunDur);

                    // Get duration
                    SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

                    // Apply it
                    DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eStunImp, eStunLink, fDuration));
                }
            }
        }
        break;
//    10. Creature suffers 3d6 points of electircal damage, but is also hasted for
//        1d10 minutes.
        case 10:
        {
            // 3d6 damage
            int nHasteDam = SMP_MaximizeOrEmpower(6, 3, nMetaMagic);

            // Delay damage
            DelayCommand(fDelay, SMP_ApplyDamageToObject(oTarget, nHasteDam, DAMAGE_TYPE_ELECTRICAL));

            // Apply haste too
            fDuration = SMP_GetRandomDuration(SMP_ROUNDS, 10, 1, nMetaMagic);

            // Apply it
            effect eHaste = SMP_CreateHasteEffect();
            effect eHasteCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eHasteVis = EffectVisualEffect(VFX_IMP_HASTE);
            effect eHasteLink = EffectLinkEffects(eHaste, eHasteCessate);

            // Apply it for the duration
            DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eHasteVis, eHasteLink, fDuration));
        }
        break;
//    11. Creature must make a will save, or be deafened for 1 minute/level.
        case 11:
        {
            // Will save
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay))
            {
                effect eDeaf = EffectDeaf();
                effect eDeafCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eDeafLink = EffectLinkEffects(eDeaf, eDeafCessate);
                effect eDeafImp = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

                // Get duration
                fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

                // Apply the deafness
                DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eDeafImp, eDeafLink, fDuration));
            }
        }
        break;
//    12. Creature becomes agile and fast, gaining +4 dexterity for 1 minute/level.
        case 12:
        {
            // Create dexterity bonus
            effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
            effect eDexCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eDexLink = EffectLinkEffects(eDex, eDexCessate);
            effect eDexImp = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

            // Get duration
            fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

            // Apply the dexterity
            DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eDexImp, eDexLink, fDuration));
        }
        break;
//    13. Creature is entangled, for 1d6 rounds.
        case 13:
        {
            // Create dexterity bonus
            effect eEntangle = EffectEntangle();
            effect eEntangleCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
            effect eEntangleDur = EffectVisualEffect(VFX_DUR_ENTANGLE);
            effect eEntangleLink = EffectLinkEffects(eEntangle, eEntangleCessate);
            eEntangleLink = EffectLinkEffects(eEntangleLink, eEntangleDur);

            // Get duration
            fDuration = SMP_GetRandomDuration(SMP_ROUNDS, 6, 1, nMetaMagic);

            // Apply the dexterity
            DelayCommand(fDelay, SMP_ApplyDuration(oTarget, eEntangleLink, fDuration));
        }
        break;
//    14. Creature is made invisible (as the spell) for 1 round/level.
        case 14:
        {
            // Determine duration in minutes
            fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

            // Declare effects
            effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
            effect eInvisCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eInvisLink = EffectLinkEffects(eInvis, eInvisCessate);

            // Apply VNF and effect.
            DelayCommand(fDelay, SMP_ApplyDuration(oTarget, eInvisLink, fDuration));
        }
        break;
//    15. Creature, if living, is healed for 5d6 + 1/caster level damage, undead
//        must make a will save or take the same in damage.
        case 15:
        {
            // Get what to heal/damage
            int nToHeal = SMP_MaximizeOrEmpower(6, 5, nMetaMagic, nCasterLevel);
            effect eHealVis;

            // Check if alive
            if(SMP_GetIsAliveCreature(oTarget))
            {
                // Heal for the damage
                effect eHeal = EffectHeal(nToHeal);
                eHealVis = EffectVisualEffect(VFX_IMP_HEALING_G);

                // Do the healing and visual
                DelayCommand(fDelay, SMP_ApplyInstantAndVFX(oTarget, eHealVis, eHeal));
            }
            else if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                // Will save for half damage
                nToHeal = SMP_GetAdjustedDamage(SAVING_THROW_WILL, nToHeal, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay);

                // Do damage
                if(nToHeal > 0)
                {
                    // Visual effect
                    eHealVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
                    // Do damage and visual
                    DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eHealVis, nToHeal, DAMAGE_TYPE_DIVINE));
                }
            }
        }
        break;
//    16. Creature is silenced (as the spell), unless they make a sucessful will
//        save, for 1 round/level.
        case 16:
        {
            // Will save
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS, oCaster, fDelay))
            {
                effect eSilence = EffectSilence();
                effect eSilenceCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eSilenceVis = EffectVisualEffect(VFX_IMP_SILENCE);
                effect eSilenceImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);
                effect eSilenceLink = EffectLinkEffects(eSilenceCessate, eSilence);
                eSilenceLink = EffectLinkEffects(eSilenceLink, eSilenceImmune);

                // Get duration
                fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

                // Apply the silence
                DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eSilenceVis, eSilenceLink, fDuration));
            }
        }
        break;
//    17. Creature is surrounded by a Fire Shield, which mearly does 1d6 damage
//        to melee attackers, for 1 minute/level.
        case 17:
        {
            // Fire shield
            effect eFireShield = EffectDamageShield(0, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
            effect eFireShieldDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
            effect eFireShieldCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eFireShieldLink = EffectLinkEffects(eFireShield, eFireShieldDur);
            eFireShieldLink = EffectLinkEffects(eFireShieldLink, eFireShieldCessate);

            // Get duration
            fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

            // Apply the shield
            DelayCommand(fDelay, SMP_ApplyDuration(oTarget, eFireShieldLink, fDuration));
        }
        break;
//    18. Creature is made more combat aware, and gains +2 damage and +2 to hit,
//        for 1 round/level.
        case 18:
        {
            // +2 to damage and to hit.
            effect eDHDam = EffectDamageIncrease(2, DAMAGE_TYPE_MAGICAL);
            effect eDHHit = EffectAttackIncrease(2);
            effect eDHCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eDHLink = EffectLinkEffects(eDHDam, eDHHit);
            eDHLink = EffectLinkEffects(eDHLink, eDHCessate);

            // Get rounds
            fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

            // Apply the shield
            DelayCommand(fDelay, SMP_ApplyDuration(oTarget, eDHLink, fDuration));
        }
        break;
//    19. Creature is healed of all mental effects (Confusion, Domination,
//        Charming, Insanity).
        case 19:
        {
            // Apply visual
            effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
            DelayCommand(fDelay, SMP_ApplyVFX(oTarget, eVis));

            // Remove all things as above.
            // * Only thing to be done instantly.
            effect eCheck = GetFirstEffect(oTarget);
            while(GetIsEffectValid(eCheck))
            {
                // Remove it if it is the right type
                switch(GetEffectType(eCheck))
                {
                    case EFFECT_TYPE_CHARMED:
                    case EFFECT_TYPE_CONFUSED:
                    case EFFECT_TYPE_DAZED:
                    case EFFECT_TYPE_DOMINATED:
                    case EFFECT_TYPE_FRIGHTENED:
                    {
                        RemoveEffect(oTarget, eCheck);
                    }
                }
                eCheck = GetNextEffect(oTarget);
            }
        }
        break;
//    20. Creature has a small Globe of Invunrability on them for 1 minute/level,
//        making them immune to all 1 and 0 level spells.
        case 20:
        {
            // Declare effects
            effect eGlobe = EffectSpellLevelAbsorption(1, 0, SPELL_SCHOOL_GENERAL);
            effect eGlobeCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eGlobeDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
            // Link Effects
            effect eGlobeLink = EffectLinkEffects(eGlobe, eGlobeCessate);
            eGlobeLink = EffectLinkEffects(eGlobeLink, eGlobeDur);

            // Get duration
            fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

            // Apply the glove
            DelayCommand(fDelay, SMP_ApplyDuration(oTarget, eGlobeLink, fDuration));
        }
        break;
// End
    }
}
