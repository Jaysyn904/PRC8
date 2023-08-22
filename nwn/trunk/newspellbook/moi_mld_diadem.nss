/*
1/1/20 by Stratovarius

Diadem of Purelight

Descriptors: Light 
Classes: Incarnate, Soulborn
Chakra: Crown
Saving Throw: None

A shimmering ring of incarnum energy wreathes your head, shedding a pure blue-white light. The light clearly outlines the shapes of creatures and objects it illuminates, enhancing your visual acuity.

You shape incarnum into a circlet that illuminates the area around you. Your diadem of purelight sheds light as a torch, and grants you a +2 bonus on Spot checks. It also negates darkness spells.

Essentia: Every point of essentia invested in this soulmeld increases the bonus on Spot checks by +2.

Chakra Bind (Crown)

The light from the headband becomes steady and constant, amplifying the contrast between different creatures and objects.

The diadem of purelight negates any concealment within a 20 ft radius.
*/

void DiademHB(object oMeldshaper);

#include "moi_inc_moifunc"

void DiademHB(object oMeldshaper)
{
	location lTarget = GetLocation(oMeldshaper);
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
		PRCRemoveSpecificEffect(EFFECT_TYPE_CONCEALMENT, oTarget);
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(20.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    
    if (GetHasSpellEffect(MELD_DIADEM_OF_PURELIGHT, oMeldshaper)) DelayCommand(1.0, DiademHB(oMeldshaper));
}    

void main()
{
    object oMeldshaper = PRCGetSpellTargetObject(); 
	int nEssentia      = GetEssentiaInvested(oMeldshaper);
    effect eLink = EffectSkillIncrease(SKILL_SPOT, 2 + (nEssentia*2));
    
    SetLocalInt(oMeldshaper, "PRCInLight", GetLocalInt(oMeldshaper, "PRCInLight")+1); 
    SetLocalInt(oMeldshaper, "DiademPurelight", TRUE); 

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oMeldshaper, 9999.0);
    IPSafeAddItemProperty(GetPCSkin(oMeldshaper), ItemPropertyBonusFeat(IP_CONST_MELD_DIADEM_OF_PURELIGHT), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (GetIsMeldBound(oMeldshaper) == CHAKRA_CROWN) DiademHB(oMeldshaper);
}