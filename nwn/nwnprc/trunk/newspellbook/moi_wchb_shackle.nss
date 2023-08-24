/*
26/1/21 by Stratovarius

Mage Shackles (Su): Beginning at 4th level, as a standard
action you can shape a set of shackles from incarnum. With
a successful melee touch attack, you can use these shackles
to bind a creature capable of arcane spellcasting or using
spell-like abilities, as long as it is within one size category
of you. You must overcome any spell resistance the target
creature might have with a successful caster level check,
using your meldshaper level as your caster level, or the
attack fails. Once so bound, the target creature is considered
entangled by the mage shackles and is also effectively barred
from planar movement, as if affected by a dimensional anchor spell.
In addition, the affected creature must succeed on a
caster level check (DC 10 + your meldshaper level + essentia
invested in the mage shackles) to cast an arcane spell or use
any spell-like ability.
A creature incapable of casting
arcane spells or using spell-like abilities is unaffected by
the mage shackles.
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"
#include "prc_inc_teleport"

void DispelMonitor(object oMeldshaper, object oTarget, int nMeld, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0) ||
       PRCGetDelayedSpellEffectsExpired(nMeld, oTarget, oMeldshaper)
       )
    {
        if(DEBUG) DoDebug("moi_wchb_shackle: The anchoring effect has been removed");
        // Reduce the teleport prevention counter
        AllowTeleport(oTarget);
        // Clear the effect presence marker
        DeleteLocalInt(oTarget, "PRC_DimAnch");
        // Clear the caster level check
        DeleteLocalInt(oTarget, "MageShackles");
        DeleteLocalObject(oTarget, "MageShacklesShaper");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oMeldshaper, oTarget, nMeld, nBeatsRemaining));
}

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_WITCH_SHACKLES);   
    int nAttack = PRCDoMeleeTouchAttack(oTarget);
    int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, GetPrimaryIncarnumClass(oMeldshaper), MELD_WITCH_SHACKLES);
    effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);    
    float fDur = 9999.0;
    
    if (nAttack > 0)
    {
    	// Have to break through SR and be within one size or larger than the target, and be arcane
        if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl) && PRCGetCreatureSize(oMeldshaper)+1 > PRCGetCreatureSize(oTarget) && GetPrimaryArcaneClass(oTarget) != CLASS_TYPE_INVALID)
        {    
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectLinkEffects(EffectEntangle(), EffectVisualEffect(VFX_DUR_ENTANGLE))), oTarget, fDur);  
    		SetLocalInt(oTarget, "MageShackles", 10+nMeldshaperLvl+nEssentia);
    		SetLocalObject(oTarget, "MageShacklesShaper", oMeldshaper);
            // No duplicate dimensional anchor spell effects
            if(!GetLocalInt(oTarget, "PRC_DimAnch"))
            {
                // Increase the teleportation prevention counter
                DisallowTeleport(oTarget);
                // Set a marker so the power won't apply duplicate effects
                SetLocalInt(oTarget, "PRC_DimAnch", TRUE);
                // Start the monitor
                DelayCommand(6.0f, DispelMonitor(oMeldshaper, oTarget, MELD_WITCH_SHACKLES, (FloatToInt(fDur) / 6) - 1));

                if(DEBUG) DoDebug("moi_wchb_shackle: The anchoring will wear off in " + IntToString(FloatToInt(fDur)) + "s");
            }    		
		}	
    }
}