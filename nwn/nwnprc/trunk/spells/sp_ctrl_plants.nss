//:://////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////
//::
/*
	Control Plants
	Transmutation
	Level: 	Drd 8, Plant 8
	Components: 	V, S, DF
	Casting Time: 	1 standard action
	Range: 	Close (25 ft. + 5 ft./2 levels)
	Targets: 	Up to 2 HD/level of plant creatures, 
				no two of which can be more than 30 ft. 
				apart
	Duration: 	1 min./level
	Saving Throw: 	Will negates
	Spell Resistance: 	No

	This spell enables you to control the actions of one 
	or more plant creatures for a short period of time. You 
	command the creatures by voice and they understand you, 
	no matter what language you speak. Even if vocal 
	communication is impossible the controlled plants do 
	not attack you. At the end of the spell, the subjects 
	revert to their normal behavior.

	Suicidal or self-destructive commands are simply ignored. 
*/
//::
//::////////////////////////////////////////////// 
//::	Script:     sp_ctrl_plants
//::	Author:     Jaysyn
//::	Created:    2025-08-11 22:28:40
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
        return;

    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl  = PRCGetCasterLevel(OBJECT_SELF);
	
	if (GetLevelByClass(CLASS_TYPE_VERDANT_LORD, OBJECT_SELF) >= 4)
	{
		CasterLvl = CasterLvl + 3;
	} 
	
    int nDuration  = CasterLvl; // minutes
    int nHDLimit   = CasterLvl * 2; // RAW

    if (nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;

    int nPenetr = CasterLvl + SPGetPenetr();

    // Close range in NWN terms: 25 ft. + 5 ft./2 levels
    float fMaxRange = 25.0 + (IntToFloat(CasterLvl / 2) * 5.0);

    object oTarget = PRCGetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fMaxRange, lTarget, TRUE);

    while (GetIsObjectValid(oCreature) && nHDLimit > 0)
    {
        if (MyPRCGetRacialType(oCreature) == RACIAL_TYPE_PLANT
            && !GetIsReactionTypeFriendly(oCreature)
            && GetDistanceBetweenLocations(lTarget, GetLocation(oCreature)) <= 30.0
            && GetHitDice(oCreature) <= nHDLimit)
        {
            // Fire cast spell at event for the specified target
            SignalEvent(oCreature, EventSpellCastAt(OBJECT_SELF, SPELL_CONTROL_PLANTS));

            if (!PRCDoResistSpell(OBJECT_SELF, oCreature, nPenetr))
            {
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oCreature, PRCGetSaveDC(oCreature, OBJECT_SELF),
                                      SAVING_THROW_TYPE_NONE, OBJECT_SELF, 1.0))
                {
                    // Remove old domination if present
                    effect eCheck = GetFirstEffect(oCreature);
                    while (GetIsEffectValid(eCheck))
                    {
                        int nType = GetEffectType(eCheck);
                        if (nType == EFFECT_TYPE_DOMINATED || nType == EFFECT_TYPE_CUTSCENE_DOMINATED)
                            RemoveEffect(oCreature, eCheck);

                        eCheck = GetNextEffect(oCreature);
                    }

                    // Apply domination
                    effect eControl = EffectCutsceneDominated();
                    effect eMind    = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
                    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    effect eVis     = EffectVisualEffect(VFX_IMP_DOMINATE_S);
                    effect eLink    = EffectLinkEffects(eMind, eControl);
                    eLink           = EffectLinkEffects(eLink, eDur);

                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCreature);
                    DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCreature,
                                                            MinutesToSeconds(nDuration), TRUE, -1, CasterLvl));

                    nHDLimit -= GetHitDice(oCreature);
                }
            }
        }
        oCreature = GetNextObjectInShape(SHAPE_SPHERE, fMaxRange, lTarget, TRUE);
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
