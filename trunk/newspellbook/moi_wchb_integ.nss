/*
26/1/21 by Stratovarius

Grim Integument (Su): At 10th level, you can shape incarnum around a foe up to 30
feet away as a full-round action that provokes attacks of opportunity. Your foe 
can attempt a Reflex save (DC 10 + invested essentia + your Con modifier) to escape the
grim integument before it forms around him. If the target creature has spell resistance, 
you must make a caster level check to overcome it, using your meldshaper level as your
caster level. A successful saving throw renders the target immune to your grim integument 
for 24 hours.

Once the grim integument forms, the subject is rooted to the spot and unable to move.
It can still speak and use spells, but each time it attempts to use an arcane spell, 
it takes 1d6 points of damage per point of essentia invested in the grim integument.
A successful Fortitude saving throw (DC 10 + invested essentia + Con modifier) halves
this damage. 

The creature is immune to damage behind the shroud, but cannot see out. However, the
creature inside can burst it open with a successful Strength check (DC 20 + invested 
essentia). Otherwise, the grim integument persists for as long as you remain within 30
feet of the subject.

You can use this ability a number of times per day equal to 1 + your Constitution 
modifier (minimum once per day).
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void BurstIntegument(object oMeldshaper, object oTarget, int nEssentia)
{
    // Can't be more than 30 feet away, target gets a Strength check to burst it each round
    if(GetDistanceBetween(oMeldshaper, oTarget) > FeetToMeters(30.0) || (d20()+GetAbilityModifier(ABILITY_STRENGTH, oTarget)) >= (20+nEssentia) )
    {
    	PRCRemoveSpellEffects(MELD_WITCH_INTEGUMENT, oMeldshaper, oTarget);
    	GZPRCRemoveSpellEffects(MELD_WITCH_INTEGUMENT, oMeldshaper, FALSE);
        DeleteLocalInt(oTarget, "GIEssentia");
        DeleteLocalObject(oTarget, "GIMeldshaper");
    }
    else
       DelayCommand(6.0f, BurstIntegument(oMeldshaper, oTarget, nEssentia));
}

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_WITCH_INTEGUMENT);   
    int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, GetPrimaryIncarnumClass(oMeldshaper), MELD_WITCH_INTEGUMENT);
    effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);    
    
	// Have to break through SR, if they've already saved they can't be targeted again
   	if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl) && !GetLocalInt(oTarget, "GrimIntegument"))
   	{    
   		int nDC = 10 + nEssentia + GetAbilityModifier(ABILITY_CONSTITUTION, oMeldshaper);
    	if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        {
			effect eLink = EffectLinkEffects(EffectDamageImmunityAll(), EffectBlindness());
			       eLink = EffectLinkEffects(eLink, EffectMissChance(100));
			       eLink = EffectLinkEffects(eLink, EffectCutsceneImmobilize());
			       eLink = EffectLinkEffects(eLink, EffectVisualEffect(PSI_DUR_SHADOW_BODY));
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget);  
			SetLocalInt(oTarget, "GIEssentia", nEssentia);
			SetLocalObject(oTarget, "GIMeldshaper", oMeldshaper);
			DelayCommand(6.0f, BurstIntegument(oMeldshaper, oTarget, nEssentia));
       	}
       	else // If they succeed, they're immune for 24hrs
       	{
       		SetLocalInt(oTarget, "GrimIntegument", TRUE);
       		DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "GrimIntegument"));
       	}
	}	
}