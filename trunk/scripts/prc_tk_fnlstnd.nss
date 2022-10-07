//::///////////////////////////////////////////////
//:: Bard Song
//:: prc_tk_fnlstnd.nss
//:://////////////////////////////////////////////
/*
    All allies within 30' gain 2d10 temp HP
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Aug 6, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_class_const"

void main()
{

    //Declare major variables
    int nLevel = GetLevelByClass(CLASS_TYPE_THAYAN_KNIGHT);
    int nChr = GetAbilityModifier(ABILITY_CHARISMA);
    int nDuration = nChr + nLevel; 
    int nHP = d10(2);
    effect eHP = EffectTemporaryHitpoints(nHP);

    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    eHP = ExtraordinaryEffect(eHP);
    
    while(GetIsObjectValid(oTarget))
    {
                if(oTarget == OBJECT_SELF)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nDuration));
                }
                else if(GetIsFriend(oTarget))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds(nDuration));
                }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}
