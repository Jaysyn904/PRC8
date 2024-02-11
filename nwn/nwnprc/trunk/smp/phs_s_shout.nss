/*:://////////////////////////////////////////////
//:: Spell Name Shout
//:: Spell FileName PHS_S_Shout
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Sonic]
    Level: Brd 4, Sor/Wiz 4
    Components: V
    Casting Time: 1 standard action
    Range: 10 M.
    Area: Cone-shaped burst
    Duration: Instantaneous
    Saving Throw: Fortitude partial; see text
    Spell Resistance: Yes

    You emit an ear-splitting yell that deafens and damages creatures in its
    path. Any creature within the area is deafened for 2d6 rounds and takes 5d6
    points of sonic damage. A successful save negates the deafness and reduces
    the damage by half. Any exposed brittle or crystalline object or crystalline
    creature takes 1d6 points of sonic damage per caster level (maximum 15d6).
    An affected creature is allowed a Fortitude save to reduce the damage by
    half.

    A shout spell cannot penetrate a silence spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Cannot be cast if the caster has silence - it will fail otherwise.

    Creatures who cannot hear (It is a [Sonic] type spell) are not affected.

    Saves:
    - Reflex for half damage and no deafness
    - Fort for half damage

    Damage:
    1d6/level to 15d6 for crystalline objects or creatures
    5d6 for everyone else
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
    // Max of 15 dice for damage to crystalline.
    int nDice = PHS_LimitInteger(nCasterLevel, 15);
    float fDelay, fDuration;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDeaf = EffectDeaf();

    effect eLink = EffectLinkEffects(eCessate, eDeaf);

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
        // Reaction type and if they can hear
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

                // Fort save means no deafness, and half damage
                if(PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SONIC, oCaster, fDelay))
                {
                    // Half damage
                    nDamage /= 2;
                }
                else
                {
                    // Else, deafness

                    // 2d6 rounds
                    fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 6, 2, nMetaMagic);

                    // Apply
                    PHS_ApplyDuration(oTarget, eLink, fDuration);
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
