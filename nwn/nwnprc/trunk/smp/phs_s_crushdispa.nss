/*:://////////////////////////////////////////////
//:: Spell Name Crushing Despair
//:: Spell FileName phs_s_crushdispa
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: 10M. Area: Cone-shaped burst. Duration: 1 min./level
    Saving Throw: Will negates Spell Resistance: Yes

    An invisible cone of despair causes great sadness in the subjects. Each
    affected creature takes a -2 penalty on attack rolls, saving throws, skill
    checks, and weapon damage rolls.

    Crushing despair counters and dispels good hope.

    Material Component: A vial of tears.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We have no visuals for this, but can apply the effects, just no cone.

    Removes Good Hope or applys effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CRUSHING_DISPARE)) return;

    // Delcare Major Variables.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    float fDelay;
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare Effects
    // "-2 morale bonus on saving throws, attack rolls, skill
    //  checks, and weapon damage rolls"
    effect eSkills = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Impact VFX
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    // This is the dispell effect used when they have crushing dispare.
    effect eDispel = EffectVisualEffect(VFX_IMP_HEAD_ODD);

    // Link effects
    effect eLink = EffectLinkEffects(eSkills, eAttack);
    eLink = EffectLinkEffects(eLink, eDamage);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Declare the spell shape, size and the location. 10M
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CRUSHING_DISPARE, FALSE);
            // Delay for visuals and effects.
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;
            // Spell Resistance and Immunity
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Mind affecting will save
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR, oCaster, fDelay))
                {
                    // If we can dispel Good Hope, do so
                    if(PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_GOOD_HOPE, oTarget, fDelay))
                    {
                        // Apply effect if we remove any.
                        DelayCommand(fDelay, PHS_ApplyInstant(oTarget, eDispel));
                    }
                    else
                    {
                        // Apply the VFX impact and effects
                        DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration));
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    }
}
