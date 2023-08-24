/*
21/02/19 by Stratovarius

Shadow Hood

Fundamental 
Level/School: 0/Evocation
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One creature 
Duration: 1 round/level 
Saving Throw: Will negates 
Spell Resistance: No

Swirling shadows manifest around your foe’s head.

Swirling tendrils and bursts of mystic shadow distract the subject. It takes a –1 penalty on attack rolls and Dexterity-based checks.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_sp_tch"

void main()
{
    object oShadow      = OBJECT_SELF;
    // Get infinite uses at this level
    if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oShadow) >= 14) IncrementRemainingFeatUses(oShadow, 23670);
    if(!ShadPreMystCastCode()) return;

    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        SignalEvent(oTarget, EventSpellCastAt(oShadow, myst.nMystId));
        
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        { 
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetShadowcasterDC(oShadow), SAVING_THROW_TYPE_SPELL))
                {
                    myst.fDur = 6.0 * myst.nShadowcasterLevel;       
                    if(myst.bExtend) myst.fDur *= 2;
                    
                    myst.eLink = EffectLinkEffects(EffectSkillDecrease(SKILL_HIDE, 1), EffectAttackDecrease(1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_MOVE_SILENTLY, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_OPEN_LOCK, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_PARRY, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_PICK_POCKET, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_SET_TRAP, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_TUMBLE, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_RIDE, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectSkillDecrease(SKILL_BALANCE, 1));
                    myst.eLink = EffectLinkEffects(myst.eLink, EffectVisualEffect(VFX_DUR_BRIGHT_LIGHT_INDIGO_PULSE_SLOW));
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(myst.eLink), oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);  
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_PURPLE), oTarget);             
                }    
        }
    }
}
