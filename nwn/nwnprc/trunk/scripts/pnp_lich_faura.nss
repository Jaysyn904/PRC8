//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_faura
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// fear aura for lich
#include "prc_class_const"
#include "prc_inc_template"

void main()
{
    //if doesn't have the template, needs class level 2
    if (GetLevelByClass(CLASS_TYPE_LICH, OBJECT_SELF) < 2 &&
        !GetHasTemplate(TEMPLATE_DEMILICH, OBJECT_SELF) &&
		!GetHasTemplate(TEMPLATE_ARCHLICH, OBJECT_SELF) &&
        !GetHasTemplate(TEMPLATE_LICH, OBJECT_SELF))
    {
       FloatingTextStringOnCreature("*The Fear Aura Does Not Work Until Level 2*", OBJECT_SELF, FALSE);
       return;
    }

    // turn off aura if it is on
    if (GetLocalInt(OBJECT_SELF,"LichAuraOn"))
    {
        effect eF = GetFirstEffect(OBJECT_SELF);
        while (GetIsEffectValid(eF))
        {
            if ( (GetEffectType(eF) == EFFECT_TYPE_AREA_OF_EFFECT) &&
                 (GetEffectDurationType(eF) == DURATION_TYPE_PERMANENT))
                 RemoveEffect( OBJECT_SELF,eF);
            eF = GetNextEffect(OBJECT_SELF);
        }
        SetLocalInt(OBJECT_SELF,"LichAuraOn",FALSE);
        return;
    }

    // turn aura on
    // Set variable to tell us it is on
    SetLocalInt(OBJECT_SELF,"LichAuraOn",TRUE);
    effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR);
    // Cant be dispelled or removed during rest
    eAOE = SupernaturalEffect(eAOE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}
