
//:////////////////////////////////////
//:  Eye of Gruumsh - Command the Horde
//:  Gives +2 will saves to all allied
//:  non-good orcs and half-orcs
//:////////////////////////////////////
#include "prc_alterations"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    object oCaster = OBJECT_SELF;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCaster) );
    while(GetIsObjectValid(oTarget))
    {
         if(oTarget != oCaster &&
            GetIsFriend(oTarget) && 
            MyPRCGetRacialType(oTarget) == RACIAL_TYPE_HALFORC ||
            MyPRCGetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC &&
            GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD &&
            !GetHasSpellEffect(SPELL_COMMAND_THE_HORDE, oTarget) )
         {
              int iEOGLevel = GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH, oCaster);
              effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_ALL);
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWill, oTarget, HoursToSeconds(iEOGLevel) );
              
              effect eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE, FALSE);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         }
         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCaster) );
    }
}