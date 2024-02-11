//::Hypnotic Pattern
//::By ebonfowl for the PRC
//::Dedicated to Edgar, the real Ebonfowl

#include "prc_sp_func"
#include "prc_add_spell_dc"

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)
       )
    {
        if(DEBUG) DoDebug("sp_hypattern: Spell expired, clearing");
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
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    float fDuration = RoundsToSeconds(nCasterLevel); //modify if necessary

    effect eLink = EffectFascinate();
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

    int nHDBonus = nCasterLevel;
    if (nHDBonus > 10) nHDBonus = 10;
    int nMaxHD = d4(2) + nHDBonus;
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