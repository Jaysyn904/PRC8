/*:://////////////////////////////////////////////
//:: Spell Name Prismatic Spray
//:: Spell FileName PHS_S_PrisSpray
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation
    Level: Sor/Wiz 7
    Components: V, S
    Casting Time: 1 standard action
    Range: 20M (60 ft.)
    Area: Cone-shaped burst
    Duration: Instantaneous
    Saving Throw: See text
    Spell Resistance: Yes

    This spell causes seven shimmering, intertwined, multicolored beams of
    light to spray from your hand. Each beam has a different power. Creatures
    in the area of the spell with 8 HD or less are automatically blinded for
    2d4 rounds. Every creature in the area is randomly struck by one or more
    beams, which have additional effects.

    1d8 Color of Beam   Effect
    1   Red     20 points fire damage (Reflex half)
    2   Orange  40 points acid damage (Reflex half)
    3   Yellow  80 points electricity damage (Reflex half)
    4   Green   Poison (Kills; Fortitude partial, take 1d6 points of Con damage instead)
    5   Blue    Turned to stone (Fortitude negates)
    6   Indigo  Insane, as insanity spell (Will negates)
    7   Violet  Sent to another plane (Will negates)
    8   Struck by two colors; roll twice more, ignoring any “8” results.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is definatly to the spells effects.

    20M cone thingy :-)

    Uses special function to apply the effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Applies the effect determined by nDiceRoll, onto oTarget with nSpellSaveDC,
// using oCaster as the caster of the spell. Used in all Prismatic spells.
// * nDiceRoll 1-7 (8 is ignored as par description).
// * Use fDelay to state a delay for the effects to be applied.
// Make sure SR checks are done before this is called.
void ApplyPrismaticEffect(int nDiceRoll, object oTarget, float fDelay, int nMetaMagic, int nSpellSaveDC, object oCaster = OBJECT_SELF);

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PRISMATIC_SPRAY)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay, fBlindness;
    int nRandom;

    // Delcare blindness (8HD or under)
    effect eBlind = EffectBlindness();

    // Loop targets in cone
    // Not sure if correct range. Currently this is Bioware's Prismatic Sprays range.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Check reaction type
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_COLOR_SPRAY);

            // Get delay
            fDelay = GetDistanceToObject(oTarget)/20;

            // Check spell resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Blind the target if they are less than 9 HD
                if(GetHitDice(oTarget) <= 8)
                {
                    fBlindness = PHS_GetRandomDuration(PHS_ROUNDS, 4, 2, nMetaMagic);
                    DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eBlind, fBlindness));
                }
                // Determine if 1 or 2 effects are going to be applied
                nRandom = d8();
                if(nRandom == 8)
                {
                    // Apply 2 different colors
                    ApplyPrismaticEffect(d8(), oTarget, fDelay, nMetaMagic, nSpellSaveDC, oCaster);
                    ApplyPrismaticEffect(d8(), oTarget, fDelay, nMetaMagic, nSpellSaveDC, oCaster);
                }
                else
                {
                    // Apply 1 color
                    ApplyPrismaticEffect(nRandom, oTarget, fDelay, nMetaMagic, nSpellSaveDC, oCaster);
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE);
    }
}

// Applies the effect determined by nDiceRoll, onto oTarget with nSpellSaveDC,
// using oCaster as the caster of the spell. Used in all Prismatic spells.
// * nDiceRoll 1-7 (8 is ignored as par description).
// * Use fDelay to state a delay for the effects to be applied.
// Make sure SR checks are done before this is called.
void ApplyPrismaticEffect(int nDiceRoll, object oTarget, float fDelay, int nMetaMagic, int nSpellSaveDC, object oCaster = OBJECT_SELF)
{
    int nRoll;
    effect eVis;
    switch(nDiceRoll)
    {
//    1   Red     20 points fire damage (Reflex half)
        case 1:
        {
            // Get damage via. save.
            nRoll = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, 20, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster);

            // Do damage
            if(nRoll > 0)
            {
                eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nRoll, DAMAGE_TYPE_FIRE));
            }
        }
        break;
//    2   Orange  40 points acid damage (Reflex half)
        case 2:
        {
            // Get damage via. save.
            nRoll = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, 40, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster);

            // Do damage
            if(nRoll > 0)
            {
                eVis = EffectVisualEffect(VFX_IMP_ACID_S);
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nRoll, DAMAGE_TYPE_ACID));
            }
        }
        break;
//    3   Yellow  80 points electricity damage (Reflex half)
        case 3:
        {
            // Get damage via. save.
            nRoll = PHS_GetAdjustedDamage(SAVING_THROW_REFLEX, 80, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster);

            // Do damage
            if(nRoll > 0)
            {
                eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nRoll, DAMAGE_TYPE_ELECTRICAL));
            }
        }
        break;
//    4   Green   Poison (Kills; Fortitude partial, take 1d6 points of Con damage instead)
        case 4:
        {
            // Posion immunity
            if(PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_POISON, fDelay, oCaster))
            {
                eVis = EffectVisualEffect(VFX_IMP_POISON_S);
                // Fortitude save
                if(PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_POISON, oCaster))
                {
                    // Apply some con damage
                    nRoll = PHS_MaximizeOrEmpower(6, 1, nMetaMagic);
                    effect ePoison = EffectAbilityDecrease(ABILITY_CONSTITUTION, nRoll);
                    PHS_ApplyPermanentAndVFX(oTarget, eVis, ePoison);
                }
                else
                {
                    // Death via. damage
                    DelayCommand(fDelay, PHS_ApplyDeathByDamageAndVFX(oTarget, eVis));
                }
            }
        }
        break;
//    5   Blue    Turned to stone (Fortitude negates)
        case 5:
        {
            // Turned to stone via. the function in PHS_INC_SPELL
            // * Take caster level as 20, this is meant to be pretty harsh anyway.
            PHS_SpellFortitudePetrify(oTarget, 20, nSpellSaveDC);
        }
        break;
//    6   Indigo  Insane, as insanity spell (Will negates)
        case 6:
        {
            // Will negates
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
            {
                // Insanity, eh? Supernatural, permament, Confusion
                // Declare effects - Confusion
                eVis = EffectVisualEffect(PHS_VFX_IMP_INSANITY);
                effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                effect eConfusion = EffectConfused();
                effect eLink = EffectLinkEffects(eConfusion, eDur);
                eLink = EffectLinkEffects(eLink, eCessate);

                // Make it a supernatural effect
                // - Cannot be dispelled
                // - Cannot be removed VIA sleep
                eLink = SupernaturalEffect(eLink);

                // Apply the effect
                PHS_ApplyPermanentAndVFX(oTarget, eVis, eLink);
            }
        }
        break;
//    7   Violet  Sent to another plane (Will negates)
        case 7:
        {
            // Send to another plane, eh?

            // The location will be set as the tagged waypoint "PHS_PRISMATIC_PLANE"
            object oWP = GetWaypointByTag("PHS_PRISMATIC_PLANE");

            if(GetIsObjectValid(oWP))
            {
                location lTarget = GetLocation(oWP);

                // We must force them to move. We remove all movement stoppers and
                // thusly move them.
                eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
                // Move them
                if(fDelay > 0.1)
                {
                    // Use special function for the "teleporting"
                    // Some delay
                    DelayCommand(fDelay - 0.1, AssignCommand(oTarget, PHS_ForceMovementToLocation(lTarget, VFX_IMP_UNSUMMON, VFX_FNF_SUMMON_MONSTER_3)));
                }
                else
                {
                    // No delay
                    AssignCommand(oTarget, PHS_ForceMovementToLocation(lTarget, VFX_IMP_UNSUMMON, VFX_FNF_SUMMON_MONSTER_3));
                }
            }
        }
        break;
//    8   Struck by two colors; roll twice more, ignoring any “8” results.
        case 8:
        {
            return;
        }
        break;
    }
}
