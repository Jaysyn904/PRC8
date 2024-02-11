//::///////////////////////////////////////////////
//:: Faerie Fire
//:: sp_faerie_fire
//:://////////////////////////////////////////////
/*
Faerie Fire
Evocation [Light]
Level:            Drd 1
Components:       V, S, DF
Casting Time:     1 standard action
Range:            Long (400 ft. + 40 ft./level)
Area:             Creatures and objects within a 5-ft.-radius burst
Duration:         1 min./level (D)
Saving Throw:     None
Spell Resistance: Yes


A pale glow surrounds and outlines the subjects. Outlined subjects shed light
as candles. Outlined creatures do not benefit from the concealment normally
provided by darkness (though a 2nd-level or higher magical darkness effect
functions normally), blur, displacement, invisibility, or similar effects.
The light is too dim to have any special effect on undead or dark-dwelling
creatures vulnerable to light. The faerie fire can be blue, green, or violet,
according to your choice at the time of casting. The faerie fire does not
cause any harm to the objects or creatures thus outlined.

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: Sept 22 , 2004
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"

//#include "x2_inc_spellhook"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr();
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = MinutesToSeconds(nCasterLvl);
    effect eVis, eExplode;

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    switch(Random(3))
    {
        case 0:
            eVis = EffectVisualEffect(VFX_DUR_LIGHT_PURPLE_5);
            eExplode = EffectVisualEffect(VFX_IMP_FAERIE_FIRE_VIOLET);
            break;
        case 1:
            eVis = EffectVisualEffect(VFX_DUR_LIGHT_BLUE_5);
            eExplode = EffectVisualEffect(VFX_IMP_FAERIE_FIRE_BLUE);
            break;
        case 2:
            eVis = EffectVisualEffect(VFX_DUR_LIGHT_YELLOW_5);
            eExplode = EffectVisualEffect(VFX_IMP_FAERIE_FIRE_GREEN);
            break;
    }

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FAERIE_FIRE));

        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
            PRCRemoveSpecificEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY, oTarget);
            PRCRemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oTarget);
            PRCRemoveSpecificEffect(EFFECT_TYPE_DARKNESS, oTarget);
            PRCRemoveSpecificEffect(EFFECT_TYPE_CONCEALMENT, oTarget);
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    PRCSetSchool();
}