/**
 * Hexblade: Dark Companion
 * 14/09/2005
 * Stratovarius
 * Type of Feat: Class Specific
 * Prerequisite: Hexblade level 4.
 * Specifics: The Hexblade gains a dark companion. It is an illusionary creature that does not engage in combat, but all monsters near it take a -2 penalty to AC and Saves.
 * Use: Selected.
 *
 * This just tells it to follow the master and do nothing else.
 */

#include "inc_debug"  
#include "prc_misc_const"  
  
void main()  
{  
    object oMaster = GetMaster();  
  
    if(!GetIsObjectValid(oMaster))  
    {  
        SetIsDestroyable(TRUE, FALSE, FALSE);  
        DestroyObject(OBJECT_SELF, 0.2);  
        return;  
    }  
  
    // Check for missing DARK_COMPANION effects and reapply if needed  
    int bHasAOE = FALSE;  
    int bHasGhost = FALSE;  
    int bHasEthereal = FALSE;  
      
    effect eCheck = GetFirstEffect(OBJECT_SELF);  
    while(GetIsEffectValid(eCheck))  
    {  
        if(GetEffectTag(eCheck) == "DARK_COMPANION")  
        {  
            int nType = GetEffectType(eCheck);  
            if(nType == EFFECT_TYPE_AREA_OF_EFFECT) bHasAOE = TRUE;  
            if(nType == EFFECT_TYPE_CUTSCENEGHOST) bHasGhost = TRUE;  
            if(nType == EFFECT_TYPE_ETHEREAL) bHasEthereal = TRUE;  
        }  
        eCheck = GetNextEffect(OBJECT_SELF);  
    }  
      
    // Reapply all effects if any are missing  
    if(!bHasAOE || !bHasGhost || !bHasEthereal)  
    {  
        // Remove any existing DARK_COMPANION effects first  
        eCheck = GetFirstEffect(OBJECT_SELF);  
        while(GetIsEffectValid(eCheck))  
        {  
            if(GetEffectTag(eCheck) == "DARK_COMPANION")  
            {  
                RemoveEffect(OBJECT_SELF, eCheck);  
            }  
            eCheck = GetNextEffect(OBJECT_SELF);  
        }  
          
        // Reapply the complete effect package  
        effect eLink = EffectAreaOfEffect(VFX_PER_10_FT_INVIS, "prc_hexbl_comp_a", "prc_hexbl_comp_c", "");  
               eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOW_GREY));  
               eLink = EffectLinkEffects(eLink, EffectCutsceneGhost());  
               eLink = EffectLinkEffects(eLink, EffectEthereal());  
               eLink = TagEffect(eLink, "DARK_COMPANION");  
               eLink = SupernaturalEffect(eLink);  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);  
    }  
  
    // Movement logic  
    if(GetIsInCombat(oMaster))  
    {  
        object oMove = GetAttackTarget(oMaster);  
        if(GetIsObjectValid(oMove))  
        {  
            ClearAllActions(TRUE);  
            ActionForceFollowObject(GetAttackTarget(oMaster), 1.0f);  
        }  
    }  
    else  
    {  
        ClearAllActions(TRUE);  
        ActionForceFollowObject(oMaster, 4.0f);  
    }  
}