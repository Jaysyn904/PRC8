#include "prc_class_const"
#include "prc_inc_template"

void main()
{
    // Check that class level is high enough
    if (GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF) < 3)
    {
       return;
    }
    // Clean up
    if (GetLocalInt(OBJECT_SELF,"AODAuraOn"))
    {
        effect eF = GetFirstEffect(OBJECT_SELF);
        while (GetIsEffectValid(eF))
        {
            if ( (GetEffectType(eF) == EFFECT_TYPE_AREA_OF_EFFECT) &&
                 (GetEffectDurationType(eF) == DURATION_TYPE_PERMANENT))
                 RemoveEffect( OBJECT_SELF,eF);
            eF = GetNextEffect(OBJECT_SELF);
        }
        SetLocalInt(OBJECT_SELF,"AODAuraOn",FALSE);
    }
    // Apply Aura of Despair
    // Set variable to tell us it is on
    SetLocalInt(OBJECT_SELF,"AODAuraOn",TRUE);
    effect eAOE = EffectAreaOfEffect(VFX_MOB_CIRCEVIL_NODIS, "prc_blkgrd_aod_a", "prc_blkgrd_aod_b", "");
    // Cant be dispelled or removed during rest
    eAOE = SupernaturalEffect(eAOE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}