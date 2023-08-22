/*:://////////////////////////////////////////////
//:: Spell Name Gust of Wind
//:: Spell FileName PHS_GustofWind
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Air]
    Level: Drd 2, Sor/Wiz 2
    Components: V, S
    Casting Time: 1 standard action
    Range: 20M.
    Effect: Line-shaped gust of severe wind emanating out from you to the extreme
            of the range
    Duration: 1 round
    Saving Throw: Fortitude negates
    Spell Resistance: Yes

    This spell creates a severe blast of air (approximately 50 mph) that
    originates from you, affecting all creatures in its path.

    A Tiny or smaller creature on the ground is knocked down and rolled 1d4x3.3M,
    taking 1d4 points of nonlethal damage per 3.3M. If flying, a Tiny or smaller
    creature is blown back 2d6x3.3M and takes 2d6 points of nonlethal damage due
    to battering and buffeting.
    Small creatures are knocked prone by the force of the wind, or if flying are
    blown back 1d6x3.3M.
    Medium creatures are unable to move forward against the force of the wind,
    or if flying are blown back 1d6x1.7M.
    Large or larger creatures may move normally within a gust of wind effect.

    A gust of wind can’t move a creature beyond the limit of its range.

    Any creature, regardless of size, takes a -4 penalty on ranged attacks and
    Listen checks in the area of a gust of wind.

    In addition to the effects noted, a gust of wind can do anything that a
    sudden blast of wind would be expected to do, such as blowing away cirtain
    area-of-effect spells, fog and other things.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    For now, it will not knockback creatures (only knockdown them, fortitude
    save negates) and always takes a -4 penalty to ranged attacks and
    listen checks for 6 seconds.

    It will use a new "dispel" function to dispel AOE's in the line.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GUST_OF_WIND)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nSize;
    float fDelay;

    // Duration is 1 round for everything at the moment.
    float fDuration = 6.0;
    float fKnockdown;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    effect eKnockdown = EffectKnockdown();
    // Attack penalty only for all weapons, urg...
    effect eAttackPenalty = EffectAttackDecrease(4, ATTACK_BONUS_MISC);
    effect eListenPenalty = EffectSkillDecrease(SKILL_LISTEN, 4);
    effect ePenaltyLink = EffectLinkEffects(eAttackPenalty, eListenPenalty);

    // We get the first in the line
    // - Cylinder
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oTarget))
    {
        // If they are an AOE, dispel
        if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            PHS_DispelWindAreaOfEffect(oTarget, 50);
        }
        // Reaction type check
        else if(!GetIsReactionTypeFriendly(oTarget))
        {
            fDelay = GetDistanceToObject(oTarget)/30;

            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GUST_OF_WIND);

            // Check spell resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // We always apply the 6 second penalty.
                PHS_ApplyDuration(oTarget, ePenaltyLink, fDuration);

                // Fortitude negates the knockdown
                if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                {
                    // Apply this after fDelay, for 6.0 - fDelay
                    fKnockdown = 6.0 - fDelay;
                    DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eVis, eKnockdown, fKnockdown));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    }
}
