/* Body Lamp Dazzle racial ability for Ashrati
   Dazzle enemies*/
   
/*    Once per day, as a free action, an asherati can bring his skin up
   to full brilliance so rapidly that it can dazzle all creatures within
   30 feet for 1 minute. Creatures can avoid this effect with a 
   successful Fortitude save (DC 10 +1/2 the asherati's character level 
   + his Cha modifier). */
   
#include "prc_inc_spells"

void main()
{
//:: Declare major variables
    object oCaster = OBJECT_SELF;
    location lLoc = GetLocation(oCaster);
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();

    float fRange = FeetToMeters(30.0);
    float fDelay;

    effect eVis = EffectVisualEffect(VFX_FNF_FIREBALL);
	
//:: Calculate the Fortitude saving throw DC
    int nDC = 10 + (GetHitDice(oCaster) / 2) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);	

//:: Display the visual effect instantly at the caster's location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);

//:: Get the first target in the radius around the caster
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRange, lLoc);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
			if (oTarget != oCaster)
			{
			//:: Fire spell cast at event for target
				SignalEvent(oTarget, EventSpellCastAt(oCaster, PRCGetSpellId()));

				if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
				{
					fDelay = PRCGetRandomDelay(0.4, 1.1);

				//:: Apply penalty effect
					effect eDazzle = SupernaturalEffect(EffectDazzle());				
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, 60.0);
				
				}
			}
        }
	//:: Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRange, lLoc);
    }
}