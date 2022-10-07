/* Body Lamp racial ability for Ashrati
   Glow like a lightbulb*/

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    
    if (GetHasSpellEffect(SPELL_ASHRATI_BODYLAMP, oPC))
        PRCRemoveSpellEffects(SPELL_ASHRATI_BODYLAMP, oPC, oPC);
    else
    {
        effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        eLink = SupernaturalEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
    }    
}