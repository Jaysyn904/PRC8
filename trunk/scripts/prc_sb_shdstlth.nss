//::///////////////////////////////////////////////
//:: Shadow and Stealth
//:: prc_sb_shdstlth.nss
//:://////////////////////////////////////////////
//:: Applies the Shadowblade Shadow and Stealth bonus:
//:: one half class level (rounded down) to Hide and
//:: Move Silently skills.
//:://////////////////////////////////////////////
// x - moved to prc_feats.nss

#include "prc_alterations"

void main()
{/*
        object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
        int nBonus = GetLevelByClass(CLASS_TYPE_SHADOWBLADE, oPC) / 2;
        
        if(GetLocalInt(oSkin, "ShdStlthH") == nBonus) return;
        
        SetCompositeBonus(oSkin, "ShdStlthH", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        SetCompositeBonus(oSkin, "ShdStlthMS", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
*/}