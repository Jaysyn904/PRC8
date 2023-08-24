//::///////////////////////////////////////////////
//:: Turns player into a wolf
//:: prc_wwformwolf
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 11, 2004
//:://////////////////////////////////////////////

#include "pnp_shft_poly"

void main()
{
    object oPC = OBJECT_SELF;
    int nPoly;

   if (GetLocalInt(oPC, "WWWolf") != TRUE)
   {
    	nPoly = POLYMORPH_TYPE_WOLF_0;

    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1))
    	{
    	    nPoly = POLYMORPH_TYPE_WOLF_1;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2))
    	{
    	    nPoly = POLYMORPH_TYPE_WOLF_2;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
    	{
    	    nPoly = POLYMORPH_TYPE_WOLF_0s;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1)  && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
    	{
    	    nPoly = POLYMORPH_TYPE_WOLF_1s;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2)  && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
    	{
    	    nPoly = POLYMORPH_TYPE_WOLF_2s;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
    	{
    	    nPoly = POLYMORPH_TYPE_WOLF_0l;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1)  && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
    	{
    	    nPoly = POLYMORPH_TYPE_WOLF_1l;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2)  && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
    	{
    	    nPoly = POLYMORPH_TYPE_WOLF_2l;
    	}
	
    	LycanthropePoly(oPC, nPoly);
    	SetLocalInt(oPC, "WWWolf", TRUE);
    }
    else
    {
    ExecuteScript("prc_wwunpoly", oPC);
    SetLocalInt(oPC, "WWWolf", FALSE);
    }    	
}
