/*
04/03/21 by Stratovarius

Eurynome, Mother of the Material
  
Eurynome grants lordship over the beasts of land, seas, and air. She also gives those with whom she binds some of the might of titans.

Vestige Level: 4th
Binding DC: 21
Special Requirement: Eurynome hates Amon for some unknown reason and will not answer your call if you are already bound to him.

Influence: Eurynome’s influence makes you paranoid and ungrateful; you see secret motives and possible betrayals behind every action. Eurynome requires that you not 
attack a foe unless an ally has already done so. If no allies are present, she makes no such requirement

Granted Abilities: 
Eurynome grants you the ability to befriend animals and wield a massive hammer. In addition, she turns your blood into poison and gives you resistance to weapon blows.

Animal Friend: All animals automatically have an initial attitude of friendly toward you.

OnEnter
*/

#include "bnd_inc_bndfunc"

void main()
{
    //Declare major variables
    object oBinder = GetLocalObject(GetModule(), "EurynomeCharm");
    //FloatingTextStringOnCreature(GetName(oBinder)+" created this AoE", GetFirstPC());

    //Capture the first target object in the shape.
    object oTarget = GetEnteringObject();
    if (!GetIsFriend(oTarget, oBinder) && oTarget != oBinder && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_ANIMAL)
    {
    	//AssignCommand(oTarget, ClearAllActions(TRUE));
    	//effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE), EffectCharmed());
    	       
    	//AssignCommand(oBinder, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, HoursToSeconds(24)));   
    	SetLocalObject(oBinder, "EurynomeCharm", oTarget);
    	ExecuteScript("bnd_vest_eurychr", oBinder);
    }
}
