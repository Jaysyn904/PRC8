/*
3/1/21 by Stratovarius

When you attain 3rd level, inner power begins to shine forth from your face, giving you a radiant countenance that dismays your foes.
With a glance, you can render a single foe within 30 feet shaken for 1 round (Will negates; save DC 10 + invested
essentia + Cha modifier). Your glance becomes a mindaffecting fear effect, and using it requires a move action.
Any foe that successfully saves against this effect is immune to your unbearable countenance for 1 hour thereafter. 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper = OBJECT_SELF;
    int nEssentia      = GetEssentiaInvested(oMeldshaper, MELD_INCANDESCENT_COUNTENANCE);
	effect eLink;
	
    if (nEssentia) 
    {
    	if(!TakeMoveAction(oMeldshaper)) return;
        object oTarget = PRCGetSpellTargetObject(); 
        int nDC = 10 + nEssentia + GetAbilityModifier(ABILITY_CHARISMA, oMeldshaper);
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR) && !GetLocalInt(oTarget, "IncanCountenance"))
        {
            // Same effect as Doom Spell
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, 6.0);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOOM), oTarget);
        }    
        else
        {
        	SetLocalInt(oTarget, "IncanCountenance", TRUE);
        	DelayCommand(HoursToSeconds(1), DeleteLocalInt(oTarget, "IncanCountenance"));
        }
    }
}