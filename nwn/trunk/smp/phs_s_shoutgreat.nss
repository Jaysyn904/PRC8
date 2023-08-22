/*:://////////////////////////////////////////////
//:: Spell Name Shout, Greater
//:: Spell FileName PHS_S_ShoutGreat
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Sonic]
    Level: Brd 6, Sor/Wiz 8
    Components: V, S, F
    Casting Time: 1 standard action
    Range: 20.0 M.
    Area: Cone-shaped burst
    Duration: Instantaneous
    Saving Throw: Fortitude partial; see text
    Spell Resistance: Yes

    This spell functions like shout, except that the cone deals 10d6 points of
    sonic damage (or 1d6 points of sonic damage per caster level, maximum 20d6,
    against crystalline creatures). It also causes creatures to be stunned for
    1 round and deafened for 4d6 rounds. A creature in the area of the cone can
    negate the stunning and halve both the damage and the duration of the
    deafness with a successful Fortitude save. A creature holding vulnerable
    objects can attempt a Reflex save to negate the damage to those objects.

    A shout, greater spell cannot penetrate a silence spell.

    Arcane Focus: A small metal or ivory horn.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Cannot be cast if the caster has silence - it will fail otherwise.

    Creatures who cannot hear (It is a [Sonic] type spell) are not affected.

    Saves:
    - Reflex for half damage and no stun, half deafness
    - Fort for half damage

    Damage:
    1d6/level to 20d6 for crystalline objects or creatures
    10d6 for everyone else
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SHOUT)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nDamage, nRelfexDamage;
    // Max of 20 dice for damage to crystalline.
    int nDice = PHS_LimitInteger(nCasterLevel, 20);
    float fDelay, fDuration;

    float f1Round = PHS_GetDuration(PHS_ROUNDS, 1, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDeaf = EffectDeaf();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eStun = EffectStunned();

    effect eDeafLink = EffectLinkEffects(eCessate, eDeaf);
    effect eStunLink = EffectLinkEffects(eCessate, eStun);
    eStunLink = EffectLinkEffects(eStunLink, eDur);

    // If the caster is under the effects of Silence, they cannot shout.
    // There is no cone effect, so this doesn't matter if the check is here.
    if(PHS_GetHasEffect(EFFECT_TYPE_SILENCE, oCaster))
    {
        FloatingTextStringOnCreature("You cannot shout if you cannot speak.", oCaster, FALSE);
        return;
    }

    // Get all in a 5M cone
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 5.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Reaction type and immunity to spells check and if they can hear
        if(!GetIsReactionTypeFriendly(oTarget) &&
            PHS_GetCanHear(oTarget) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Signal Spell cast at event.
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SHOUT);

            // Get delay
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Spell Resistance and immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Damage deterimined by the type of target
                if(PHS_GetIsCrystalline(oTarget))
                {
                    // 1d6/level.
                    nDamage = PHS_MaximizeOrEmpower(6, nDice, nMetaMagic);
                }
                else
                {
                    // 5d6 for non-crystalline
                    nDamage = PHS_MaximizeOrEmpower(6, 5, nMetaMagic);
                }

                // Deafness duration - 4d6 rounds
                fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 6, 2, nMetaMagic);

                // Fort save means half deafness, and half damage and no stun
                if(PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SONIC, oCaster, fDelay))
                {
                    // Half damage and duration
                    nDamage /= 2;
                    fDuration /= 2;
                }
                else
                {
                    // Else, definatly stun
                    // Apply
                    PHS_ApplyDuration(oTarget, eStunLink, f1Round);
                }

                // Apply deafness
                if(fDuration >= 6.0)
                {
                    PHS_ApplyDuration(oTarget, eDeafLink, fDuration);
                }

                // Check if any damage
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_SONIC));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 5.0, lTarget, TRUE);
    }
}
