//::///////////////////////////////////////////////
//:: Forest Master: Deep Roots
//:: prc_fm_deeproots.nss
//:://////////////////////////////////////////////
/*
Deep Roots (Su): Beginning at 8th level, once per day the forest
master may sink roots into the ground in any natural surface
place that can support at least some vegetation. While rooted, the
forest master gains fast healing 5, but has an effective Dexterity
score of 1 and may not move from the spot in which he stands.
*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 20230107
//:://////////////////////////////////////////////

void main()
{
//:: Declare major variables
	object oPC		= OBJECT_SELF;
	object oArea 	= GetArea(oPC);
	
	int bDeepRoots 	= GetLocalInt(oPC, "DeepRootsActive");
	int iNatural 	= GetIsAreaNatural(oArea);
	int iSurface 	= GetIsAreaAboveGround(oArea);
	
	effect eRoots 		= EffectCutsceneImmobilize();
	effect eRegen 		= EffectRegenerate(4, 6.0f);
	effect eEntangle	= EffectVisualEffect(VFX_DUR_ENTANGLE);
	effect eLink;
	effect eEffect;
	
//:: Deep Roots only works where trees can grow.	
	if ((!iNatural) || (!iSurface))
	{
		SendMessageToPC(oPC, "You must be outdoors on fertile ground for this ability to function.");
		return;
	}

	if (bDeepRoots)
	{
	//:: End & remove Deep Roots			
		eEffect = GetFirstEffect(oPC);
			
		while(GetIsEffectValid(eEffect))
		{
			if(GetEffectTag(eEffect) == "FM_DeepRoots")
			{
				RemoveEffect(oPC, eEffect);
			}
				
		eEffect = GetNextEffect(oPC);
		}
	
		SetLocalInt(oPC, "DeepRootsActive", 0);
		
		return;
	}
	
	//:: Link & tag effects	
		eLink = EffectLinkEffects(eRoots, eRegen);	
		eLink = EffectLinkEffects(eLink, eEntangle);
		eLink = SupernaturalEffect(eLink);
		eLink = TagEffect(eLink, "FM_DeepRoots");
		
	//:: Clear the effect to be safe and prevent stacking
		effect eCheckEffect = GetFirstEffect(oPC);
            
		while (GetIsEffectValid(eCheckEffect))
		{
			if (GetEffectTag(eCheckEffect) == "FM_DeepRoots")
			{
				RemoveEffect(oPC, eCheckEffect);
			}
			
			eCheckEffect = GetNextEffect(oPC);
		
		}
	//:: Apply effects & set int var
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		SetLocalInt(oPC, "DeepRootsActive", 1);
	
}