/*
13/07/20 by Stratovarius

Black Labyrinth

Master, Shadowscape
Level/School: 9th/Conjuration (Creation)
Range: Personal
Area: One area
Duration: 12 hours/level
Saving Throw: Will partial, see text
Spell Resistance: No

The air blackens, the shadows of the alleys lengthen, and the wind shrieks as the Shadow and Material Planes collide.

Black labyrinth causes substantial disorientation within the area it affects. Direction and distance become impossible to determine, as the world itself bends and twists.

All attacks have a 50% miss chance.

Area effects with a source or target within the black labyrinth have a 20% chance of improper placement. If this occurs, the spell is centered 1d4 x 5 feet in a random direction from where the caster intended. 

All Search and Spot checks take a -10 penalty.

Any movement, from a 5-foot step to a full run and everything between, occurs in a random direction. A successful Will save negates this particular effect, but that save must be repeated for each round of movement.

Any teleportation effects with a destination inside the black labyrinth deposit their passengers 1d% x 5 feet from the intended destination. A teleport effect cast within the black labyrinth requires a successful Will save; 

When within your own black labyrinth, you are immune to the last two effects (movement and teleportation), but not the others. 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void DoLabyrinth(object oShadow, float fDur, int nDC, int nShadowcasterLevel, object oArea);

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.fDur = HoursToSeconds(12) * myst.nShadowcasterLevel;
        if(myst.bExtend) myst.fDur *= 2;   
        int nDC = GetShadowcasterDC(oShadow);
        
		DoLabyrinth(oShadow, myst.fDur, nDC, myst.nShadowcasterLevel, GetArea(oShadow));           
    }
}

void DoLabyrinth(object oShadow, float fDur, int nDC, int nShadowcasterLevel, object oArea)  
{
    SetLocalInt(oArea, "BlackLabyrinthTeleport", nDC);
    DelayCommand(5.95, DeleteLocalInt(oArea, "BlackLabyrinthTeleport"));  
    object oTarget = GetFirstObjectInArea(oArea);
    while (oTarget != OBJECT_INVALID)
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
        	SetLocalInt(oTarget, "BlackLabyrinth", TRUE);
        	DelayCommand(5.95, DeleteLocalInt(oTarget, "BlackLabyrinth"));
        	effect eLink = EffectLinkEffects(EffectSkillDecrease(SKILL_SPOT, 10), EffectSkillDecrease(SKILL_SEARCH, 10));
        	       eLink = EffectLinkEffects(eLink,  EffectMissChance(50));
        	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0, TRUE, -1, nShadowcasterLevel);
        }
        // Caster is immune to these effects
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && oTarget != oShadow)
        {
        	if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL)) 
        	{
        		location lRandom = GenerateNewLocation(oTarget, FeetToMeters(5.0*d10()), IntToFloat(Random(360)), IntToFloat(Random(360))); 
        		AssignCommand(oTarget, JumpToLocation(lRandom));
        	}	
        	SetLocalInt(oTarget, "BlackLabyrinthTeleport", nDC);
        	DelayCommand(5.95, DeleteLocalInt(oTarget, "BlackLabyrinthTeleport"));        	
        }        
        
        
        oTarget = GetNextObjectInArea(oArea);
    }
    
    if (fDur > 0.0) DelayCommand(6.0, DoLabyrinth(oShadow, fDur-6.0, nDC, nShadowcasterLevel, oArea));
}       	