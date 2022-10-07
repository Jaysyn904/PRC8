//::///////////////////////////////////////////////
//:: Name      Dragon Cloud
//:: FileName  sp_drgn_cloud.nss
//:://////////////////////////////////////////////
/**@file Dragon Cloud
Conjuration (Calling) [Air]
Level: Sanctified 8
Components: V, S, Sacrifice
Casting Time: 1 round
Range: Special (see text)
Effect: One conjured dragon cloud (see text)
Duration: 1 min. + 1 minute/level
Saving Throw: None
Spell Resistance: No

You must cast this spell outdoors, in a place where
clouds are visible. It calls forth a spirit of
elemental air, binds it to a nearby cloud (either a
normal cloud or storm cloud), and gives it a
dragon-like form. Upon forming, the dragon-shaped
cloud swoops toward you, arriving in 1 minute
regardless of the actual distance from you.
(The time it takes to reach you counts toward the
spell's duration.) Once it arrives, you can command
the dragon cloud like a summoned creature. The dragon
cloud speaks Auran.

At the end of the spell's duration, the dragon cloud
evaporates into nothingness as the bound elemental
spirit returns to its home plane. The dragon cloud
cannot pass through liquids or solid objects.

Sacrifice: 1d3 points of Constitution damage.

Author:    Tenjac
Created:   6/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"


void SummonDragonCloud(location lLoc, float fDur)
{
    MultisummonPreSummon();
    effect sSummon = EffectSummonCreature("prc_drag_cld");
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, sSummon, lLoc, fDur); 
}

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    object oPC = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oPC);
    object oArea = GetArea(oPC);
    location lLoc = PRCGetSpellTargetLocation();
    int nAbove = GetIsAreaAboveGround(oArea);
    int nInside = GetIsAreaInterior(oArea);
    int nNatural = GetIsAreaNatural(oArea);
    float fDur = (60.0f * (nCasterLevel));

    if(nAbove == AREA_ABOVEGROUND && nInside == FALSE)
    {
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);
        DelayCommand(TurnsToSeconds(1), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc));
        DelayCommand(TurnsToSeconds(1), SummonDragonCloud(lLoc, fDur));
        //only pay the cost if cast sucessfully
        DoCorruptionCost(oPC, ABILITY_CONSTITUTION, d3(), 0);
    }
    
    else FloatingTextStringOnCreature("This spell must be cast outdoors and aboveground.", oPC, FALSE);

    //Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_GOOD, 10, FALSE);

    //SPGoodShift(oPC);

    PRCSetSchool();
}


