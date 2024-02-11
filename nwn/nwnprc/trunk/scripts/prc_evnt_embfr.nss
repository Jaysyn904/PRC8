////////////////////////////////////////////////
// Embalming Fire On-Hit
// prc_evnt_embfr.nss
////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oZombie = OBJECT_SELF;        
        effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CHILL_SHIELD), EffectDamageIncrease(d6(1), DAMAGE_TYPE_FIRE));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oZombie, TurnsToSeconds(1));
}