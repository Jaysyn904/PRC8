/**
 * @file
 * Summon Alien for Zceryll
 *
 */

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ZCERYLL)) return;
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ZCERYLL);
    int nSpell = SPELL_SUMMON_CREATURE_V;
    if (nBinderLevel >= 18) nSpell = SPELL_SUMMON_CREATURE_IX;
    else if (nBinderLevel >= 16) nSpell = SPELL_SUMMON_CREATURE_VIII;
    else if (nBinderLevel >= 14) nSpell = SPELL_SUMMON_CREATURE_VII;
    else if (nBinderLevel >= 12) nSpell = SPELL_SUMMON_CREATURE_VI;
    
    DoRacialSLA(nSpell, nBinderLevel, GetBinderDC(oBinder, VESTIGE_ZCERYLL));    
}
        