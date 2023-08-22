#include "prc_class_const"

void main()
{
    object oBinder = OBJECT_SELF;
    
    int nClass = GetLevelByClass(CLASS_TYPE_BINDER, oBinder);
	if (nClass >= 13)
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL)), oBinder);
	if (nClass >= 6)
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_FEAR)), oBinder);		
}
