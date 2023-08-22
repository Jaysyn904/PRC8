#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int nBiowareSize = GetCreatureSize(oPC);
    //CEP adds other sizes, take them into account too
    if(nBiowareSize == 20)
        nBiowareSize = CREATURE_SIZE_DIMINUTIVE;
    else if(nBiowareSize == 21)
        nBiowareSize = CREATURE_SIZE_FINE;
    else if(nBiowareSize == 22)
        nBiowareSize = CREATURE_SIZE_GARGANTUAN;
    else if(nBiowareSize == 23)
        nBiowareSize = CREATURE_SIZE_COLOSSAL;
    int nPRCSizeAll     = PRCGetCreatureSize(oPC, PRC_SIZEMASK_ALL);                           //includes 'simple' size changes
    int nPRCSizeAbility = PRCGetCreatureSize(oPC, PRC_SIZEMASK_NORMAL);                        //includes only things that change ability scores
    int nPRCSize        = PRCGetCreatureSize(oPC, PRC_SIZEMASK_NORMAL | PRC_SIZEMASK_NOABIL);  //also includes things that dont change ability scores
    
    if (DEBUG) DoDebug("prc_size: nBiowareSize = "+IntToString(nBiowareSize));
    if (DEBUG) DoDebug("prc_size: nPRCSizeAll = "+IntToString(nPRCSizeAll));
    if (DEBUG) DoDebug("prc_size: nPRCSizeAbility = "+IntToString(nPRCSizeAbility));
    if (DEBUG) DoDebug("prc_size: nPRCSize = "+IntToString(nPRCSize));

    //if size hasnt changed,  abort
    if (nBiowareSize == nPRCSizeAll)
        return;

    //change counters
    int nStr;
    int nDex;
    int nCon;
    int nACNatural;
    int nACDodge;
    int nAB;
    int nHide;
    //increase
    if(nPRCSize > nBiowareSize)
    {
        //these track if that change should be applied or not
        int nFineToDiminutive     = (nPRCSize >= CREATURE_SIZE_DIMINUTIVE && nBiowareSize <= CREATURE_SIZE_FINE);
        int nDiminutiveToTiny     = (nPRCSize >= CREATURE_SIZE_TINY       && nBiowareSize <= CREATURE_SIZE_DIMINUTIVE);
        int nTinyToSmall          = (nPRCSize >= CREATURE_SIZE_SMALL      && nBiowareSize <= CREATURE_SIZE_TINY);
        int nSmallToMedium        = (nPRCSize >= CREATURE_SIZE_MEDIUM     && nBiowareSize <= CREATURE_SIZE_SMALL);
        int nMediumToLarge        = (nPRCSize >= CREATURE_SIZE_LARGE      && nBiowareSize <= CREATURE_SIZE_MEDIUM);
        int nLargeToHuge          = (nPRCSize >= CREATURE_SIZE_HUGE       && nBiowareSize <= CREATURE_SIZE_LARGE);
        int nHugeToGargantuan     = (nPRCSize >= CREATURE_SIZE_GARGANTUAN && nBiowareSize <= CREATURE_SIZE_HUGE);
        int nGargantuanToColossal = (nPRCSize >= CREATURE_SIZE_COLOSSAL   && nBiowareSize <= CREATURE_SIZE_GARGANTUAN);
        
        //add in the bonuses
        //each size category is cumulative
        if(nFineToDiminutive)
        {
            nACNatural  +=  0;
            nACDodge    += -4;
            nAB         += -4;
            nHide       += -4;
        }
        if(nDiminutiveToTiny)
        {
            nACNatural  +=  0;
            nACDodge    += -2;
            nAB         += -4;
            nHide       += -4;
        }
        if(nTinyToSmall)
        {
            nACNatural  +=  0;
            nACDodge    += -1;
            nAB         += -1;
            nHide       += -4;
        }
        if(nSmallToMedium)
        {
            nACNatural  +=  0;
            nACDodge    += -1;
            nAB         += -1;
            nHide       += -4;
        }
        if(nMediumToLarge)
        {
            nACNatural  +=  2;
            nACDodge    += -1;
            nAB         += -1;
            nHide       += -4;
        }
        if(nLargeToHuge)
        {
            nACNatural  +=  3;
            nACDodge    += -1;
            nAB         += -1;
            nHide       += -4;
        }
        if(nHugeToGargantuan)
        {
            nACNatural  +=  4;
            nACDodge    += -2;
            nAB         += -2;
            nHide       += -4;
        }
        if(nGargantuanToColossal)
        {
            nACNatural  +=  5;
            nACDodge    += -4;
            nAB         += -4;
            nHide       += -4;
        }
    }
    //decrease
    else if(nPRCSize < nBiowareSize)
    {
        //these track if that change should be applied or not
        int nDiminuativeToFine    = (nPRCSize <= CREATURE_SIZE_FINE       && nBiowareSize >= CREATURE_SIZE_DIMINUTIVE);
        int nTinyToDiminuative    = (nPRCSize <= CREATURE_SIZE_DIMINUTIVE && nBiowareSize >= CREATURE_SIZE_TINY);
        int nSmallToTiny          = (nPRCSize <= CREATURE_SIZE_TINY       && nBiowareSize >= CREATURE_SIZE_SMALL);
        int nMediumToSmall        = (nPRCSize <= CREATURE_SIZE_SMALL      && nBiowareSize >= CREATURE_SIZE_MEDIUM);
        int nLargeToMedium        = (nPRCSize <= CREATURE_SIZE_MEDIUM     && nBiowareSize >= CREATURE_SIZE_LARGE);
        int nHugeToLarge          = (nPRCSize <= CREATURE_SIZE_LARGE      && nBiowareSize >= CREATURE_SIZE_HUGE);
        int nGargantuanToHuge     = (nPRCSize <= CREATURE_SIZE_HUGE       && nBiowareSize >= CREATURE_SIZE_GARGANTUAN);
        int nColossalToGargantuan = (nPRCSize <= CREATURE_SIZE_GARGANTUAN && nBiowareSize >= CREATURE_SIZE_COLOSSAL);
      
        //add in the bonuses
        //each size category is cumulative
        if(nDiminuativeToFine)
        {
            nACNatural  +=  0;
            nACDodge    +=  4;
            nAB         +=  4;
            nHide       +=  4;
        }
        if(nTinyToDiminuative)
        {
            nACNatural  +=  0;
            nACDodge    +=  2;
            nAB         +=  2;
            nHide       +=  4;
        }
        if(nSmallToTiny)
        {
            nACNatural  +=  0;
            nACDodge    +=  1;
            nAB         +=  1;
            nHide       +=  4;
        }
        if(nMediumToSmall)
        {
            nACNatural  +=  0;
            nACDodge    +=  1;
            nAB         +=  1;
            nHide       +=  4;
        }
        if(nLargeToMedium)
        {
            nACNatural  += -2;
            nACDodge    +=  1;
            nAB         +=  1;
            nHide       +=  4;
        }
        if(nHugeToLarge)
        {
            nACNatural  += -3;
            nACDodge    +=  1;
            nAB         +=  1;
            nHide       +=  4;
        }
        if(nGargantuanToHuge)
        {
            nACNatural  += -4;
            nACDodge    +=  2;
            nAB         +=  2;
            nHide       +=  4;
        }
        if(nColossalToGargantuan)
        {
            nACNatural  += -5;
            nACDodge    +=  4;
            nAB         +=  4;
            nHide       +=  4;
        }
    }   
    //increase
    if(nPRCSizeAbility > nBiowareSize)
    {
        //these track if that change should be applied or not
        int nFineToDiminutive     = (nPRCSizeAbility >= CREATURE_SIZE_DIMINUTIVE && nBiowareSize <= CREATURE_SIZE_FINE);
        int nDiminutiveToTiny     = (nPRCSizeAbility >= CREATURE_SIZE_TINY       && nBiowareSize <= CREATURE_SIZE_DIMINUTIVE);
        int nTinyToSmall          = (nPRCSizeAbility >= CREATURE_SIZE_SMALL      && nBiowareSize <= CREATURE_SIZE_TINY);
        int nSmallToMedium        = (nPRCSizeAbility >= CREATURE_SIZE_MEDIUM     && nBiowareSize <= CREATURE_SIZE_SMALL);
        int nMediumToLarge        = (nPRCSizeAbility >= CREATURE_SIZE_LARGE      && nBiowareSize <= CREATURE_SIZE_MEDIUM);
        int nLargeToHuge          = (nPRCSizeAbility >= CREATURE_SIZE_HUGE       && nBiowareSize <= CREATURE_SIZE_LARGE);
        int nHugeToGargantuan     = (nPRCSizeAbility >= CREATURE_SIZE_GARGANTUAN && nBiowareSize <= CREATURE_SIZE_HUGE);
        int nGargantuanToColossal = (nPRCSizeAbility >= CREATURE_SIZE_COLOSSAL   && nBiowareSize <= CREATURE_SIZE_GARGANTUAN);

        //add in the bonuses
        //each size category is cumulative
        if(nFineToDiminutive)
        {
            nStr        +=  0;
            nDex        += -2;
            nCon        +=  0;
        }
        if(nDiminutiveToTiny)
        {
            nStr        +=  2;
            nDex        += -2;
            nCon        +=  0;
        }
        if(nTinyToSmall)
        {
            nStr        +=  4;
            nDex        += -2;
            nCon        +=  0;
        }
        if(nSmallToMedium)
        {
            nStr        +=  2;
            nDex        += -2;
            nCon        +=  2;
        }
        if(nTinyToSmall)
        {
            nStr        +=  4;
            nDex        += -2;
            nCon        +=  0;
        }
        if(nSmallToMedium)
        {
            nStr        +=  2;
            nDex        += -2;
            nCon        +=  2;
        }
        if(nMediumToLarge)
        {
            nStr        +=  8;
            nDex        += -2;
            nCon        +=  4;
        }
        if(nLargeToHuge)
        {
            nStr        +=  8;
            nDex        += -2;
            nCon        +=  4;
        }
        if(nHugeToGargantuan)
        {
            nStr        +=  8;
            nDex        +=  0;
            nCon        +=  4;
        }
        if(nGargantuanToColossal)
        {
            nStr        +=  8;
            nDex        +=  0;
            nCon        +=  4;
        }
    }
    //decrease
    else if(nPRCSizeAbility < nBiowareSize)
    {
        //these track if that change should be applied or not
        int nDiminuativeToFine    = (nPRCSizeAbility <= CREATURE_SIZE_FINE       && nBiowareSize >= CREATURE_SIZE_DIMINUTIVE);
        int nTinyToDiminuative    = (nPRCSizeAbility <= CREATURE_SIZE_DIMINUTIVE && nBiowareSize >= CREATURE_SIZE_TINY);
        int nSmallToTiny          = (nPRCSizeAbility <= CREATURE_SIZE_TINY       && nBiowareSize >= CREATURE_SIZE_SMALL);
        int nMediumToSmall        = (nPRCSizeAbility <= CREATURE_SIZE_SMALL      && nBiowareSize >= CREATURE_SIZE_MEDIUM);
        int nLargeToMedium        = (nPRCSizeAbility <= CREATURE_SIZE_MEDIUM     && nBiowareSize >= CREATURE_SIZE_LARGE);
        int nHugeToLarge          = (nPRCSizeAbility <= CREATURE_SIZE_LARGE      && nBiowareSize >= CREATURE_SIZE_HUGE);
        int nGargantuanToHuge     = (nPRCSizeAbility <= CREATURE_SIZE_HUGE       && nBiowareSize >= CREATURE_SIZE_GARGANTUAN);
        int nColossalToGargantuan = (nPRCSizeAbility <= CREATURE_SIZE_GARGANTUAN && nBiowareSize >= CREATURE_SIZE_COLOSSAL);
        
        //add in the bonuses
        //each size category is cumulative
        if(nDiminuativeToFine)
        {
            nStr        +=  0;
            nDex        +=  2;
            nCon        +=  0;
        }
        if(nTinyToDiminuative)
        {
            nStr        += -2;
            nDex        +=  2;
            nCon        +=  0;
        }
        if(nSmallToTiny)
        {
            nStr        += -4;
            nDex        +=  2;
            nCon        +=  0;
        }
        if(nMediumToSmall)
        {
            nStr        += -4;
            nDex        +=  2;
            nCon        += -2;
        }
        if(nLargeToMedium)
        {
            nStr        += -8;
            nDex        +=  2;
            nCon        += -4;
        }
        if(nHugeToLarge)
        {
            nStr        += -8;
            nDex        +=  2;
            nCon        += -4;
        }    
        if(nGargantuanToHuge)
        {
            nStr        += -8;
            nDex        +=  0;
            nCon        += -4;
        }
        if(nColossalToGargantuan)
        {
            nStr        += -8;
            nDex        +=  0;
            nCon        += -4;
        }   
    }       

    //do 'simple' size change effects, like the expand/compress psionic powers
    int nSimpleChange = nPRCSizeAll - nPRCSize;
    nStr     += 2 * nSimpleChange;
    nDex     -= 2 * nSimpleChange;
    nACDodge -=     nSimpleChange;
    nHide    -= 4 * nSimpleChange;
//    nAB      -=     nSimpleChange; // this will be done in the power/spell itself, so it will be instant
    
    //see if they are increases or decreases
    int nStrInc   = (nStr > 0) ?    nStr : 0;
    int nStrDec   = (nStr < 0) ? -1*nStr : 0;
    int nDexInc   = (nDex > 0) ?    nDex : 0;
    int nDexDec   = (nDex < 0) ? -1*nDex : 0;
    int nConInc   = (nCon > 0) ?    nCon : 0;
    int nConDec   = (nCon < 0) ? -1*nCon : 0;

    int nACNaturalInc = (nACNatural > 0) ?    nACNatural : 0;
    int nACNaturalDec = (nACNatural < 0) ? -1*nACNatural : 0;
    int nACDodgeInc   = (nACDodge   > 0) ?    nACDodge   : 0;
    int nACDodgeDec   = (nACDodge   < 0) ? -1*nACDodge   : 0;
    int nHideInc      = (nHide      > 0) ?    nHide      : 0;
    int nHideDec      = (nHide      < 0) ? -1*nHide      : 0;
    
    //now apply the bonuses/penalties
    object oSkin = GetPCSkin(oPC);
    SetCompositeAttackBonus(oPC, "SizeChangesAB", nAB);

    SetCompositeBonus(oSkin, "SizeChangesStrInc", nStrInc, ITEM_PROPERTY_ABILITY_BONUS          , IP_CONST_ABILITY_STR);
    SetCompositeBonus(oSkin, "SizeChangesStrDec", nStrDec, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_STR);
    SetCompositeBonus(oSkin, "SizeChangesDexInc", nDexInc, ITEM_PROPERTY_ABILITY_BONUS          , IP_CONST_ABILITY_DEX);
    SetCompositeBonus(oSkin, "SizeChangesDexDec", nDexDec, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_DEX);
    SetCompositeBonus(oSkin, "SizeChangesConInc", nConInc, ITEM_PROPERTY_ABILITY_BONUS          , IP_CONST_ABILITY_CON);
    SetCompositeBonus(oSkin, "SizeChangesConDec", nConDec, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CON);

    SetCompositeBonus(oSkin, "SizeChangesHideInc", nHideInc, ITEM_PROPERTY_SKILL_BONUS             , SKILL_HIDE);
    SetCompositeBonus(oSkin, "SizeChangesHideDec", nHideDec, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_HIDE);

    SetCompositeBonus(oSkin, "SizeChangesACNInc", nACNaturalInc, ITEM_PROPERTY_AC_BONUS    , IP_CONST_ACMODIFIERTYPE_NATURAL);
    SetCompositeBonus(oSkin, "SizeChangesACNDec", nACNaturalDec, ITEM_PROPERTY_DECREASED_AC, IP_CONST_ACMODIFIERTYPE_NATURAL);

    SetCompositeBonus(oSkin, "SizeChangesACDInc", nACDodgeInc, ITEM_PROPERTY_AC_BONUS    , IP_CONST_ACMODIFIERTYPE_DODGE);
    SetCompositeBonus(oSkin, "SizeChangesACDDec", nACDodgeDec, ITEM_PROPERTY_DECREASED_AC, IP_CONST_ACMODIFIERTYPE_DODGE);
}