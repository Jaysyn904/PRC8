/*
26/1/21 by Stratovarius

Spiritflay (Su): Beginning at 8th level, you can catch a tiny
bit of an arcane spellcaster’s soulstuff between your hands and
mangle it. You can use this attack against any arcane spellcaster
or creature with spell-like abilities that is within 60 feet of
you. The target creature must make a successful Fortitude save
(DC 10 + your witchborn binder level + your Con modifier)
or take 1d8 points of damage per point of essentia you invest
in the ability, and also be nauseated for 1 round. A successful
Fortitude save halves the damage and negates the nausea. A
creature that has no arcane spells prepared or no arcane spell
slots unused is immune to this ability
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_WITCH_SPIRITFLAY);   
    int nAttack = PRCDoRangedTouchAttack(oTarget);
    int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, GetPrimaryIncarnumClass(oMeldshaper), MELD_WITCH_SPIRITFLAY);
    effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);    
    
    if (nAttack > 0)
    {
    	if (GetPrimaryArcaneClass(oTarget) != CLASS_TYPE_INVALID)
    	{
    		int nDC = 10 + GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oMeldshaper) + GetAbilityModifier(ABILITY_CONSTITUTION, oMeldshaper);
    		int nDam = d8(nEssentia);
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
				if (GetHasMettle(oTarget, SAVING_THROW_FORT))
					nDam = 0;   
					
				nDam /= 2;		
        	}
        	else 
        		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNausea(oTarget, 6.0), oTarget, RoundsToSeconds(1));
                
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_POSITIVE), oTarget);
		}	
    }
}