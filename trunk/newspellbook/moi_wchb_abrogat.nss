/*
26/1/21 by Stratovarius

Word of Abrogation (Sp): Beginning at 6th level, you
can use your command of incarnum to counterspell your
enemies. To do so, you must first ready an action. If any
creature within 60 feet of you casts a spell or uses a spell-like
ability, you can attempt to negate the effect as an immediate
action with a caster level check (DC 11 + the enemy creature’s
caster level), using your meldshaper level as your caster level.
You gain a +1 bonus on the check for every point of essentia
you invest in this ability. You can abrogate only one spell or
spell-like effect with each use of this ability, so if you are
facing multiple spellcasters, you must decide which one to
target with your word of abrogation and wait until your chosen
target takes its turn.

*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper  = OBJECT_SELF;

	// If you've already got it, clean up instead
	if (!GetLocalInt(oMeldshaper, "Abrogation"))
	{
    	int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_WITCH_ABROGATION);   
    	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, GetPrimaryIncarnumClass(oMeldshaper), MELD_WITCH_ABROGATION);
    	// This is because if you've readied an action to counterspell, you can't attack
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectLinkEffects(EffectSlow(), EffectAttackDecrease(-40))), oMeldshaper, 9999.0);  
    	SetLocalInt(oMeldshaper, "Abrogation", 10+nMeldshaperLvl+nEssentia);
    }
    else 
    {
	    DeleteLocalInt(oMeldshaper, "Abrogation");	
	    PRCRemoveSpellEffects(MELD_WITCH_ABROGATION, oMeldshaper, oMeldshaper);
    	GZPRCRemoveSpellEffects(MELD_WITCH_ABROGATION, oMeldshaper, FALSE);    
    }
}