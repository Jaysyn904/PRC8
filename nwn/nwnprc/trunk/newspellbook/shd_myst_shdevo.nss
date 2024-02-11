/*
14/02/19 by Stratovarius

Shadow Evocation

Initiate, Dark Reflections 
Level/School: 4th/Illusion (Shadow)

This mystery can mimic an evocation spell of lower than 5th level. 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "inc_dynconv"

void main()
{
    object oShadow      = OBJECT_SELF;
    int nMyst = PRCGetSpellId();
    
    if (nMyst == MYST_SHADOW_EVOCATION || nMyst == MYST_GREATER_SHADOW_EVO)
    {
        if(!ShadPreMystCastCode()) return;

        object oTarget      = PRCGetSpellTargetObject();
        struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

        if(myst.bCanMyst)
        {
            int nSpellId = GetLocalInt(oShadow, "ShadowEvocation");
            if (nSpellId > 0)
            {
                SetLocalInt(oShadow, "ShadowEvoking", nMyst);
                AssignCommand(oShadow, ActionCastSpell(nSpellId, myst.nShadowcasterLevel, 0, GetShadowcasterDC(oShadow)));
                DelayCommand(1.0, DeleteLocalInt(oShadow, "ShadowEvoking"));
            }    
        }
    }
    else
    {
        AssignCommand(oShadow, ClearAllActions(TRUE));
        SetLocalInt(oShadow, "ShadowEvoMax", 4);
        if (nMyst == MYST_GREATER_SHADOW_EVO_CONV) SetLocalInt(oShadow, "ShadowEvoMax", 6);
        StartDynamicConversation("shd_myst_evoconv", oShadow, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oShadow);
    }    
}