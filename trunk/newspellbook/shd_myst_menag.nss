/*
12/12/19 by Stratovarius

Menagerie of Darkness

Master, Shadowscape
Level/School: 8th/Transmutation
Range: 30 ft.
Area: 30-ft.-radius emanation centered on you
Duration: 10 minutes/level
Saving Throw: Will negates
Spell Resistance: Yes

Nearby animals and vermin abruptly shudder. Their mouths and eyes gape wide as a torrent of blackness flows into them from the surrounding gloom.

Any animals or vermin within the emanation, or who enter it, must make a Will save or immediately take on the aspects of their shadow selves, temporarily gaining the dark creature template. 
You gain control over these animals, as per the spell dominate animal. Menagerie of darkness does not affect animals or vermin with Hit Dice higher than your caster level.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_template"

void DoMenagerie(object oShadow, float fDur, int nDC, int nShadowcasterLevel);

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.fDur = 600.0 * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;   
        int nDC = GetShadowcasterDC(oShadow);
        
		DoMenagerie(oShadow, myst.fDur, nDC, myst.nShadowcasterLevel);           
    }
}

void DoMenagerie(object oShadow, float fDur, int nDC, int nShadowcasterLevel)  
{
	location lTarget = GetLocation(oShadow);
	// Loop the allies to get the bonus
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
    	int nRacialType = MyPRCGetRacialType(oTarget);

		// Must be a vermin or animal and not already have the dark template and have HD less than or equal to caster level
    	if((nRacialType == RACIAL_TYPE_VERMIN || nRacialType == RACIAL_TYPE_ANIMAL) && !GetHasTemplate(TEMPLATE_DARK, oTarget) && nShadowcasterLevel >= GetHitDice(oTarget))
        {
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            {
                effect eLink = EffectCutsceneDominated();
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur, TRUE, MYST_MENAGERIE_OF_DARKNESS, nShadowcasterLevel);  
                ApplyTemplateToObject(TEMPLATE_DARK, oTarget);
            }
        }

        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    
    if (fDur > 0.0) DelayCommand(3.0, DoMenagerie(oShadow, fDur-3.0, nDC, nShadowcasterLevel));
}       	