
#include "prc_alterations"
void main()
{
    object oPC = OBJECT_SELF;
    
    effect eCloakDance = EffectConcealment(100);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCloakDance, oPC, 6.0);

}