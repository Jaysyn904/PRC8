/*
26/1/21 by Stratovarius

Dispelling Orb
At 2nd level, you learn to shape a
small orb of incarnum and hurl it at any target within 30 feet
as a standard action. If you succeed on a ranged touch attack,
the dispelling orb functions as a targeted dispel magic spell
(caster level equals your meldshaper level). For every point
of essentia you invest in the orb, you gain a +1 insight bonus
on any dispel checks you make with it
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"
#include "inc_dispel"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_WITCH_DISPEL);   
    int nAttack = PRCDoRangedTouchAttack(oTarget);
    int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, GetPrimaryIncarnumClass(oMeldshaper), MELD_WITCH_DISPEL);
    effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);    
    
    if (nAttack > 0)
    {
		spellsDispelMagicMod(oTarget, nMeldshaperLvl+nEssentia, eVis, eImpact);
    }
}