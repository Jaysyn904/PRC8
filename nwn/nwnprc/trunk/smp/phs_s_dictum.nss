/*:://////////////////////////////////////////////
//:: Spell Name Dictum
//:: Spell FileName PHS_S_Dictum
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Lawful, Sonic]
    Level: Clr 7, Law 7
    Components: V
    Casting Time: 1 standard action
    Range: 13.33M.
    Area: Nonlawful creatures in a 13.33-M.-radius spread centered on you
    Duration: Instantaneous
    Saving Throw: None or Will negates; see text
    Spell Resistance: Yes

    Any nonlawful creature within the area of a dictum spell suffers the following
    ill effects.
    HD                      Effect
    Equal to caster level   Deafened
    Up to caster level -1   Slowed, deafened
    Up to caster level -5   Paralyzed, slowed, deafened
    Up to caster level -10  Killed, paralyzed, slowed, deafened

    The effects are cumulative and concurrent. No saving throw is allowed against
    these effects.

    Deafened: The creature is deafened for 1d4 rounds.
    Slowed: The creature is slowed, as by the slow spell, for 2d4 rounds.
    Paralyzed: The creature is paralyzed and helpless for 1d10 minutes.
    Killed: Living creatures die. Undead creatures are destroyed.

    Furthermore, if you are on your home plane when you cast this spell, nonlawful
    extraplanar creatures within the area are instantly banished back to their
    home planes. Creatures so banished cannot return for at least 24 hours. This
    effect takes place regardless of whether the creatures hear the dictum. The
    banishment effect allows a Will save (at a -4 penalty) to negate.

    Creatures whose HD exceed your caster level are unaffected by dictum.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    No saving throw - nice!

    Anyway, HD limits, all effects can be applied as above. SR applies, and
    they need to hear the word for it to work - apart from the home plane
    part.

    Blasphemy (Evil), Dictum (Lawful), Holy Word (Good), Word of Chaos (Chaos)
    sets of spells.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(PHS_SpellHookCheck(PHS_SPELL_DICTUM)) return;

    // Define major variables
    object oCaster = OBJECT_SELF;
    location lSelf = GetLocation(oCaster);
    object oTarget;
    int nCasterLevel = PHS_GetCasterLevel(oCaster);
    int nCasterLevelM1 = nCasterLevel - 1;
    int nCasterLevelM5 = nCasterLevel - 5;
    int nCasterLevelM10 = nCasterLevel - 10;
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nHitDice, nRace, nStrength;
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    // We add 4 to the DC, as it says "effect allows a Will save (at a -4 penalty)"
    nSpellSaveDC += 4;
    // Delay = distance / 20
    float fDelay;
    // Duration is different for all parts.
    float fDuration;// = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects.
    effect eBanishment = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    // Paralysis (1d10 minutes)
    effect eParalysis = EffectParalyze();
    effect eParaDur1 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eParaDur2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    // Deafness (1d4 round of deafness)
    effect eDeaf = EffectDeaf();
    effect eDeafVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    // Slowed for 2d4 rounds
    effect eSlow = EffectSlow();
    // Death
    effect eDeathVis = EffectVisualEffect(VFX_IMP_DEATH_L);

    // Link effects
    // Paralysis
    effect eParaLink = EffectLinkEffects(eParalysis, eParaDur1);
    eParaLink = EffectLinkEffects(eParaLink, eParaDur1);
    eParaLink = EffectLinkEffects(eParaLink, eCessate);
    // Deafness
    effect eDeafLink = EffectLinkEffects(eDeaf, eCessate);
    // Slow link
    effect eSlowLink = EffectLinkEffects(eSlow, eCessate);

    // AOE visual applied.
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_DICTUM);
    PHS_ApplyLocationVFX(lSelf, eImpact);

    // Loop enemies - and apply the effects.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 13.33, lSelf);
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check - affects hostiles more often then not.
        if(GetIsReactionTypeHostile(oTarget) &&
        // Make sure they are not immune to spells
          !PHS_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DICTUM);

            // Delay for visuals and effects.
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Hit dice and alignment check
            nHitDice = GetHitDice(oTarget);
            if(nHitDice <= nCasterLevel &&
               GetAlignmentLawChaos(oTarget) != ALIGNMENT_LAWFUL)
            {
                // Spell resistance check
                if(PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
                {
                    // They must be able to hear the words of the spell to
                    // be affected (As noted in the Banishment part, and the top).
                    if(PHS_GetCanHear(oTarget))
                    {
                        // What do we apply?

                        // Deafnened - 1d4 rounds
                        fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic);

                        // Apply it
                        PHS_ApplyDuration(oTarget, eDeafLink, fDuration);

                        // Need to be anywhere under nCasterLevel, or equal or under
                        // nCasterLevel - 1 to be slowed.
                        if(nHitDice <= nCasterLevelM1)
                        {
                            // Slowed - 2d4 rounds
                            fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 2, nMetaMagic);

                            // Apply it
                            PHS_ApplyDuration(oTarget, eSlowLink, fDuration);

                            // Need to be equal or under nCasterLevel - 5 for Paralysis
                            if(nHitDice <= nCasterLevelM5)
                            {
                                // Paralysis is for 1d10 rounds
                                fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 10, 1, nMetaMagic);

                                // Apply it
                                PHS_ApplyDuration(oTarget, eParaLink, fDuration);

                                // Need to be equal or under nCasterLevel - 10 for death
                                if(nHitDice <= nCasterLevelM10)
                                {
                                    // Death is instant
                                    PHS_ApplyDeathByDamageAndVFX(oTarget, eDeathVis);
                                }
                            }
                        }
                    }
                    // Now, are they going home?
/*
    Furthermore, if you are on your home plane when you cast this spell, nonlawful
    extraplanar creatures within the area are instantly banished back to their
    home planes. Creatures so banished cannot return for at least 24 hours. This
    effect takes place regardless of whether the creatures hear the dictum.
    The banishment effect allows a Will save (at a -4 penalty) to negate.
*/
                    // If they are outsiders (we've done the alignment check)
                    // we push them back to thier planes.

                    // VERY BASIC AT THE MOMENT, IT DOESN'T EVEN CHECK TO SEE IF
                    // THIS IS THEIR PLANE!

                    // Will-based saving throw
                    if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_EVIL, oCaster, fDelay))
                    {
                        if(PHS_CanCreatureBeDestroyed(oTarget))
                        {
                            // Destroy them with VFX
                            DestroyObject(oTarget);
                            PHS_ApplyLocationVFX(GetLocation(oTarget), eBanishment);
                        }
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 13.33, lSelf);
    }
}
