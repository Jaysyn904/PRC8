/*
30/12/19 by Stratovarius

Ankheg Breastplate Throat Bind

Green chitin spreads from your breastplate up your neck, blending into your skin there. This thickened skin seems to pulse slowly, in a rhythm unrelated to the beat of your heart or the movement of your breath.

You gain the ability to spit a line of acid as a standard action. Once per minute, you can emit a line of acid that is 5 feet long plus 5 feet per point of invested essentia.
Targets in the line take 2d6 points of acid damage plus 1d6 points for every point of invested essentia. They can reduce this damage by half with a successful Reflex save. 
*/

#include "moi_inc_moifunc"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_ANKHEG_BREASTPLATE);   
    
    if (!GetLocalInt(oMeldshaper, "AnkhegTimer"))
    {
	    //Set the lightning stream to start at the caster's hands
	    effect eLightning = EffectBeam(VFX_BEAM_DISINTEGRATE, oMeldshaper, BODY_NODE_CHEST);
	    effect eVis  = EffectVisualEffect(VFX_IMP_ACID_L);
	    effect eDamage;
	    location lTarget = GetLocation(oTarget);
	    object oNextTarget, oTarget2;
	    float fDelay;
	    float fDist = 5.0 + (5.0 * nEssentia);
	    int nDice = 2 + nEssentia;
	    int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_ANKHEG_BREASTPLATE);
	    int nCnt = 1;	
	    int nDamage;
	
	    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, oMeldshaper, nCnt);
	    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= FeetToMeters(fDist))
	    {
	        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
	        oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oMeldshaper));
	        while (GetIsObjectValid(oTarget))
	        {
	           //Exclude the caster from the damage effects
	           if (oTarget != oMeldshaper && oTarget2 == oTarget)
	           {
	                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oMeldshaper))
	                {
	                   //Fire cast spell at event for the specified target
	                   SignalEvent(oTarget, EventSpellCastAt(oMeldshaper, SPELL_LIGHTNING_BOLT));
	                   //Make an SR check
	                   if (!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
	                   {
	                        int nDC = GetMeldshaperDC(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_ANKHEG_BREASTPLATE);
	                        //Roll damage
	                        nDamage =  d6(nDice);

	                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
	                        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC,SAVING_THROW_TYPE_ELECTRICITY);
	                        if(nDamage > 0)
	                        {
	                        	eDamage = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_ACID);	                        
	                            fDelay = PRCGetSpellEffectDelay(GetLocation(oTarget), oTarget);
	                            //Apply VFX impcat, damage effect and lightning effect
	                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
	                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	                        }
	                    }
	                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 1.0, FALSE);
	                    //Set the currect target as the holder of the lightning effect
	                    oNextTarget = oTarget;
	                    eLightning = EffectBeam(VFX_BEAM_DISINTEGRATE, oNextTarget, BODY_NODE_CHEST);
	                }
	           }
	           //Get the next object in the lightning cylinder
	           oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(fDist), lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oMeldshaper));
	        }
	        nCnt++;
	        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, oMeldshaper, nCnt);
	    } 
	    
	    SetLocalInt(oMeldshaper, "AnkhegTimer", TRUE);
	    DelayCommand(60.0, DeleteLocalInt(oMeldshaper, "AnkhegTimer"));
    }
}