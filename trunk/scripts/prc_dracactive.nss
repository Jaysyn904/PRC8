//::///////////////////////////////////////////////
//:: Draconic Active Feats
//:: prc_dracactive.nss
//::///////////////////////////////////////////////
/*
    Handles the usable feats of the Draconic series of feats from 
    Races of the Dragon and Dragon Magic
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 17, 2007
//:://////////////////////////////////////////////

#include "prc_inc_burn"
#include "prc_inc_breath"

void ActivateSavingThrow(int nSpellLevel, object oPC = OBJECT_SELF)
{
    SetLocalInt(oPC, "BurnSpellLevel", nSpellLevel);
    int bCanUse = BurnSpell(oPC);
    DeleteLocalInt(oPC, "BurnSpellLevel");
    
    //if none left, exit
    if(!bCanUse) return;
	
	effect eLink = EffectSavingThrowIncrease(SAVING_THROW_ALL, nSpellLevel);
        float fDur = 6.0f;

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
	
}


void ActivateBreath(int nSpellLevel, object oPC = OBJECT_SELF)
{
    SetLocalInt(oPC, "BurnSpellLevel", nSpellLevel);
    int bCanUse = BurnSpell(oPC);
    DeleteLocalInt(oPC, "BurnSpellLevel");
    
    //if none left, exit
    if(!bCanUse) return;    
	
	int nDamageType;
        struct breath DracBreath;
	
	        //Acid
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC))
            {
                 nDamageType = DAMAGE_TYPE_ACID;
            }
             
            //Cold
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC))
            {
                 nDamageType = DAMAGE_TYPE_COLD;
            }
            //Electric
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC))
            {
                 nDamageType = DAMAGE_TYPE_ELECTRICAL;
            }
            //Fire
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC)
               || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC))
            {
                 nDamageType = DAMAGE_TYPE_FIRE;
            }
            //Sonic
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC))
            {
                 nDamageType = DAMAGE_TYPE_SONIC;
            }
            //"Concussive Force"
            if(GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC))
            {
                 nDamageType = DAMAGE_TYPE_BLUDGEONING;
            }            
	
	
        int nSaveDCBonus     = nSpellLevel;
        int nNumberOfDice    = 2;
        int nDieSize         = 6;
        location lTarget     = PRCGetSpellTargetLocation();
        
        //check for Dragonheart Mage abilities
        int nHeartLevel = GetLevelByClass(CLASS_TYPE_DRAGONHEART_MAGE, oPC);
        if ( nHeartLevel > 5)
        {
        	nDieSize = 8;
        }
        if ( nHeartLevel > 9)
        {
        	nNumberOfDice = 3;
        	nDieSize = 6;
        }
        if ( nHeartLevel > 15)
        {
        	nNumberOfDice = 3;
        	nDieSize = 8;
        }
        if ( nHeartLevel > 19)
        {
        	nNumberOfDice = 4;
        	nDieSize = 6;
        }
        if ( nHeartLevel > 25)
        {
        	nNumberOfDice = 4;
        	nDieSize = 8;
        }
        if ( nHeartLevel > 29)
        {
        	nNumberOfDice = 5;
        	nDieSize = 6;
        }
        
        nNumberOfDice = nNumberOfDice * nSpellLevel;

        //cone handling for sonic, fire, and cold
        if((nDamageType == DAMAGE_TYPE_COLD) 
            || (nDamageType == DAMAGE_TYPE_FIRE) 
            || (nDamageType == DAMAGE_TYPE_SONIC))
        {
            DracBreath = CreateBreath(oPC, FALSE, 30.0, nDamageType, nDieSize, nNumberOfDice, ABILITY_CHARISMA, nSaveDCBonus, BREATH_NORMAL, 0);
        }//end cone handling
            
        //otherwise do a line
        else
        {
            DracBreath = CreateBreath(oPC, TRUE, 60.0, nDamageType, nDieSize, nNumberOfDice, ABILITY_CHARISMA, nSaveDCBonus, BREATH_NORMAL, 0);
        }//end Electric line breath handling
        
        ApplyBreath(DracBreath, lTarget);
}	

void main()
{
    object oPC = OBJECT_SELF;
    int bSpontCaster = FALSE;
    int nFirstArcane = GetPrimaryArcaneClass(oPC);

    //make sure new spellbooks are allowed
    if((GetPRCSwitch(PRC_SORC_DISALLOW_NEWSPELLBOOK) && nFirstArcane == CLASS_TYPE_SORCERER)
    || (GetPRCSwitch(PRC_BARD_DISALLOW_NEWSPELLBOOK) && nFirstArcane == CLASS_TYPE_BARD))
    {
        FloatingTextStringOnCreature("New spellbooks are disabled and this feat requires them.", oPC, FALSE);
        return;
    }

    //make sure user is a spontaneous caster
    int i;
    for(i = 1; i <= 3; i++)
    {
        int nClass = GetClassByPosition(i, oPC);
        if((GetSpellbookTypeForClass(nClass) == SPELLBOOK_TYPE_SPONTANEOUS)
        && GetIsArcaneClass(nClass, oPC))
              bSpontCaster = TRUE;
    }

    if(!bSpontCaster)
    {
        FloatingTextStringOnCreature("This ability requires spontaneous arcane spell slots.", oPC, FALSE);
        return;
    }

    int nFeatUsed = GetSpellId();

    switch(nFeatUsed)
    {
        //Draconic Arcane Grace activations
        case SPELL_DRACONIC_GRACE_1: ActivateSavingThrow(1); break;
        case SPELL_DRACONIC_GRACE_2: ActivateSavingThrow(2); break;
        case SPELL_DRACONIC_GRACE_3: ActivateSavingThrow(3); break;
        case SPELL_DRACONIC_GRACE_4: ActivateSavingThrow(4); break;
        case SPELL_DRACONIC_GRACE_5: ActivateSavingThrow(5); break;
        case SPELL_DRACONIC_GRACE_6: ActivateSavingThrow(6); break;
        case SPELL_DRACONIC_GRACE_7: ActivateSavingThrow(7); break;
        case SPELL_DRACONIC_GRACE_8: ActivateSavingThrow(8); break;
        case SPELL_DRACONIC_GRACE_9: ActivateSavingThrow(9); break;

        //Draconic Breath
        case SPELL_DRACONIC_BREATH_1: ActivateBreath(1); break;
        case SPELL_DRACONIC_BREATH_2: ActivateBreath(2); break;
        case SPELL_DRACONIC_BREATH_3: ActivateBreath(3); break;
        case SPELL_DRACONIC_BREATH_4: ActivateBreath(4); break;
        case SPELL_DRACONIC_BREATH_5: ActivateBreath(5); break;
        case SPELL_DRACONIC_BREATH_6: ActivateBreath(6); break;
        case SPELL_DRACONIC_BREATH_7: ActivateBreath(7); break;
        case SPELL_DRACONIC_BREATH_8: ActivateBreath(8); break;
        case SPELL_DRACONIC_BREATH_9: ActivateBreath(9); break;

        default: FloatingTextStringOnCreature("Should not happen. o.O", oPC, FALSE); break;
    }
}
