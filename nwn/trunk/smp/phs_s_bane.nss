/*:://////////////////////////////////////////////
//:: Spell Name Bane
//:: Spell FileName PHS_S_Bane
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Bane
    Enchantment (Compulsion) [Fear, Mind-Affecting]
    Level: Clr 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: 10 Meters
    Area: All enemies within 10 Meters
    Duration: 1 min./level
    Saving Throw: Will negates
    Spell Resistance: Yes

    Bane fills your enemies with fear and doubt. Each affected creature takes a
    -1 penalty on attack rolls and a -1 penalty on saving throws against fear
    effects.

    Bane counters and dispels bless.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    If they have bless, it dispels it, else it causes -1 to attack rolls
    and saves VS fear.

    This counters bless.

    It is a fear saving throw too :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(PHS_SpellHookCheck()) return;

    // Define major variables
    object oCaster = OBJECT_SELF;
    location lSelf = GetLocation(oCaster);
    object oTarget;
    // Delay = distance / 20
    float fDelay;
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration is in turns
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Effect - attack -1, effect -1 save vs. fear.
    effect eAttack = EffectAttackDecrease(1);
    effect eMorale = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    // Link effects
    effect eLink = EffectLinkEffects(eAttack, eMorale);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    // This is the dispel effect used when they have bless.
    effect eDispel = EffectVisualEffect(VFX_IMP_HEAD_EVIL);

    // AOE visual applied.
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    PHS_ApplyLocationVFX(lSelf, eImpact);

    // Loop enemies - and apply the effects.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_30, lSelf);
    while(GetIsObjectValid(oTarget))
    {
        // Only affects non-friends. PvP Check. Must be able to be affected
        if(!GetIsFriend(oTarget) && !GetFactionEqual(oTarget) &&
           oTarget != oCaster && GetIsReactionTypeHostile(oTarget) &&
        // Make sure they are not immune to spells
          !PHS_TotalSpellImmunity(oTarget))
        {
            //Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BANE);

            // Delay for visuals and effects.
            fDelay = GetDistanceBetween(oCaster, oTarget)/20;

            // Resistance and immunity checking. Check fear + mind immunity too
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay) &&
               !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
               !PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_FEAR))
            {
                // Fear will-based saving throw.
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FEAR, oCaster, fDelay))
                {
                    // Remove bless - dispells it.
                    if(PHS_RemoveSpellEffectsFromTarget(SPELL_BLESS, oTarget, fDelay))
                    {
                        // Apply effect if we remove any.
                        DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eDispel));
                    }
                    else
                    {
                        //Apply the VFX impact and effects
                        DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
                        PHS_ApplyDuration(oTarget, eLink, fDuration);
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_30, lSelf);
    }
}
