/*
    sp_pattern

    Illusion (Pattern) [Mind-Affecting]
    Level: Brd 4, Sor/Wiz 4
    Components: V (Brd only), S, M, F; see text
    Casting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Effect: Colorful lights with a 20-ft.-radius spread
    Duration: Concentration +1 round/ level (D)
    Saving Throw: Will negates
    Spell Resistance: Yes
    A glowing, rainbow-hued pattern of interweaving colors fascinates those within it. Rainbow pattern fascinates a maximum of 24 Hit Dice of creatures. Creatures with the fewest HD are affected first. Among creatures with equal HD, those who are closest to the spell’s point of origin are affected first. An affected creature that fails its saves is fascinated by the pattern.
    With a simple gesture (a free action), you can make the rainbow pattern move up to 30 feet per round (moving its effective point of origin). All fascinated creatures follow the moving rainbow of light, trying to get or remain within the effect. Fascinated creatures who are restrained and removed from the pattern still try to follow it. If the pattern leads its subjects into a dangerous area each fascinated creature gets a second save. If the view of the lights is completely blocked creatures who can’t see them are no longer affected.
    The spell does not affect sightless creatures.
    Verbal Component: A wizard or sorcerer need not utter a sound to cast this spell, but a bard must sing, play music, or recite a rhyme as a verbal component.
    Material Component: A piece of phosphor.
    Focus: A crystal prism.

    By: Flaming_Sword
    Created: Sept 29, 2006
    Modified: Sept 30, 2006
*/

#include "prc_sp_func"
#include "prc_add_spell_dc"
void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)
       )
    {
        if(DEBUG) DoDebug("sp_pattern: Spell expired, clearing");
        PRCRemoveEffectsFromSpell(oTarget, nSpellID);

    }
    else
       DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));
}

void ConcentrationHB(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    if(GetBreakConcentrationCheck(oCaster))
    {
        //FloatingTextStringOnCreature("Crafting: Concentration lost!", oPC);
        //DeleteLocalInt(oPC, PRC_CRAFT_HB);
        //return;
        DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining);
    }
    else
        DelayCommand(6.0f, ConcentrationHB(oCaster, oTarget, nSpellID, nBeatsRemaining));
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget;// = PRCGetSpellTargetObject();
    location lLocation = PRCGetSpellTargetLocation();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    float fDuration = RoundsToSeconds(nCasterLevel); //modify if necessary

    effect eLink = EffectFascinate();
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

    int nMaxHD = 24;
    int nSumHD = 0;
    float nRadius = RADIUS_SIZE_HUGE;
    int nCount = 0;
    int i;
    string sPrefix = "PRC_PATTERN_";
    string sObj = sPrefix + "OBJECT_";
    string sHD = sPrefix + "HD_";
    string sDistance = sPrefix + "DISTANCE_";
    string sFlag = sPrefix + "FLAG_";
    if(array_exists(oCaster, sObj)) array_delete(oCaster, sPrefix + sObj);
    if(array_exists(oCaster, sHD)) array_delete(oCaster, sPrefix + sHD);
    if(array_exists(oCaster, sDistance)) array_delete(oCaster, sPrefix + sDistance);
    if(array_exists(oCaster, sFlag)) array_delete(oCaster, sPrefix + sFlag);
    array_create(oCaster, sObj);
    array_create(oCaster, sHD);
    array_create(oCaster, sDistance);
    array_create(oCaster, sFlag);
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, nRadius, lLocation, TRUE);
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_RAINBOW_PATTERN), lLocation);

    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {   //fill arrays
            array_set_object(oCaster, sObj, nCount, oTarget);
            array_set_int(oCaster, sHD, nCount, GetHitDice(oTarget));
            array_set_float(oCaster, sDistance, nCount, GetDistanceBetweenLocations(lLocation, GetLocation(oTarget)));
            array_set_int(oCaster, sFlag, nCount, 1);
            nCount++;
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, nRadius, lLocation, TRUE);
    }

    int nIndex;
    while(TRUE)
    {   //big risk here
        //nIndex = -1;  //FIX nIndex RESET
    for(i = 0; i < array_get_size(oCaster, sFlag); i++)
    {
        if(array_get_int(oCaster, sFlag, i))
        {
            nIndex = i;
            break;
        }
    }
        for(i = 0; i < array_get_size(oCaster, sFlag); i++)
        {   //search for target to affect
            if(i != nIndex && array_get_int(oCaster, sFlag, i))
            {   //sort by HD
                if(array_get_int(oCaster, sHD, i) < array_get_int(oCaster, sHD, nIndex))
                {
                    nIndex = i;
                }
                else if(array_get_int(oCaster, sHD, i) == array_get_int(oCaster, sHD, nIndex))
                {   //sort by distance
                    if(array_get_float(oCaster, sDistance, i) < array_get_float(oCaster, sDistance, nIndex))
                    {
                        nIndex = i;
                    }
                }
            }
        }
        oTarget = array_get_object(oCaster, sObj, nIndex);
        array_set_int(oCaster, sFlag, nIndex, 0);
        if(nSumHD + array_get_int(oCaster, sHD, nIndex) > nMaxHD)
            break;
        else
        {
            PRCSignalSpellEvent(oTarget, FALSE);
            nSumHD += array_get_int(oCaster, sHD, nIndex);
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            DelayCommand(6.0f, ConcentrationHB(oCaster, oTarget, nSpellID, FloatToInt(fDuration)));
        }
    }

    array_delete(oCaster, sObj);
    array_delete(oCaster, sHD);
    array_delete(oCaster, sDistance);
    array_delete(oCaster, sFlag);


    PRCSetSchool();
}