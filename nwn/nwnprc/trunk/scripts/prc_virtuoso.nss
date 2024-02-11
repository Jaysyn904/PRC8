/*
    prc_virtuoso

    Handles Virtuoso feats

    WARNING: Many of these don't care about
    faction, will affect both allies and enemies!

    Designed along the lines of Bard Song

    By: Flaming_Sword
    Created: Jul 8, 2006
    Modified: Jul 9, 2006
*/

#include "prc_inc_clsfunc"

void main()
{
    object oPC = OBJECT_SELF;
    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,oPC))
    {
        FloatingTextStrRefOnCreature(85764,oPC); // not useable when silenced
        return;
    }
    int nSpellID = GetSpellId();
    if(!VirtuosoPerformanceDecrement(oPC, nSpellID))
    {
        SendMessageToPC(oPC, "You do not have enough daily uses of Virtuoso Performance to use this ability.");
        return;
    }
    object oTarget = PRCGetSpellTargetObject();
    int nDuration = 10;
    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870)) nDuration *= 10;
    // lingering song
    if(GetHasFeat(424)) nDuration += 5;
    float fDuration = RoundsToSeconds(nDuration);

    object oItem;
    int nTemp;
    effect eLink;
    int nCasterLevel = PRCGetCasterLevel(oPC);
    int nPerform = GetSkillRank(SKILL_PERFORM, oPC);
    //Constructing effects
    switch(nSpellID)
    {
        case SPELL_VIRTUOSO_SUSTAINING_SONG:
        {
            if(nPerform < 11)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }

            //insert pnp stabilisation code here
            eLink = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
            eLink = EffectLinkEffects(eLink, EffectRegenerate(1, 6.0));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

            break;
        }
        case SPELL_VIRTUOSO_CALUMNY:
        {
            if(nPerform < 13)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }
            break;
        }
        case SPELL_VIRTUOSO_JARRING_SONG:
        {
            if(nPerform < 14)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }
            break;
        }
        case SPELL_VIRTUOSO_SHARP_NOTE:
        {
            if(nPerform < 15)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }
            break;
        }
        case SPELL_VIRTUOSO_MINDBENDING_MELODY:
        {
            if(nPerform < 16)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }
            eLink = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
            eLink = EffectLinkEffects(eLink, PRCGetScaledEffect(EffectDominated(), oTarget));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

            int nRacial = MyPRCGetRacialType(oTarget);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
            //Make sure the target is a humanoid
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                if  ((nRacial == RACIAL_TYPE_DWARF) ||
                    (nRacial == RACIAL_TYPE_ELF) ||
                    (nRacial == RACIAL_TYPE_GNOME) ||
                    (nRacial == RACIAL_TYPE_HALFLING) ||
                    (nRacial == RACIAL_TYPE_HUMAN) ||
                    (nRacial == RACIAL_TYPE_HALFELF) ||
                    (nRacial == RACIAL_TYPE_HALFORC))
                {
                   //Make SR Check
                   if (!PRCDoResistSpell(oPC, oTarget, nCasterLevel + SPGetPenetr()))
                   {
                        //Make Will Save
                        if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 15 + GetAbilityModifier(ABILITY_CHARISMA, oPC), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
                        {
                            DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,nCasterLevel));
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOMINATE_S), oTarget);
                        }
                    }
                }
            }
            return;

            break;
        }
        case SPELL_VIRTUOSO_GREATER_CALUMNY:
        {
            if(nPerform < 17)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }
            break;
        }
        case SPELL_VIRTUOSO_MAGICAL_MELODY:
        {   //dummy effect, good for checking if there is a spell effect
            if(nPerform < 18)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }
            break;
        }
        case SPELL_VIRTUOSO_SONG_OF_FURY:
        {
            if(nPerform < 19)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }
            eLink = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
            eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
            eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, 2));
            eLink = EffectLinkEffects(eLink, EffectACDecrease(2, AC_DODGE_BONUS));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

            break;
        }
        case SPELL_VIRTUOSO_REVEALING_MELODY:
        {
            if(nPerform < 20)
            {
                SendMessageToPC(oPC, "You do not have enough ranks in Perform to use this ability.");
                return;
            }
            effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eSight = EffectTrueSeeing();
            if(GetPRCSwitch(PRC_PNP_TRUESEEING))
            {
                eSight = EffectSeeInvisible();
                int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
                if(nSpot == 0)
                    nSpot = 15;
                effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
                effect eUltra = EffectUltravision();
                eSight = EffectLinkEffects(eSight, eSpot);
                eSight = EffectLinkEffects(eSight, eUltra);
            }
            eLink = EffectLinkEffects(eVis, eSight);
            eLink = EffectLinkEffects(eLink, eDur);

            break;
        }
    }
    eLink = ExtraordinaryEffect(eLink);

    object oAffected = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
    while(GetIsObjectValid(oAffected))
    {

        PRCRemoveEffectsFromSpell(oAffected, nSpellID);
        if(oAffected == oPC)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_BARD_SONG)), oAffected, fDuration,TRUE,-1,nCasterLevel);
        }
        switch(nSpellID)
        {
            case SPELL_VIRTUOSO_SUSTAINING_SONG:
            {
                //insert pnp stabilisation code here
                if(GetCurrentHitPoints(oAffected) <= 10)    //arbitrary check for now
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAffected, fDuration,TRUE,-1,nCasterLevel);
                }
                break;
            }
            case SPELL_VIRTUOSO_CALUMNY:
            {
                break;
            }
            case SPELL_VIRTUOSO_JARRING_SONG:
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE)), oAffected, fDuration,TRUE,-1,nCasterLevel);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)), oAffected, fDuration,TRUE,-1,nCasterLevel);

                break;
            }
            case SPELL_VIRTUOSO_SHARP_NOTE:
            {
                oItem = IPGetTargetedOrEquippedMeleeWeapon();
                if(GetIsObjectValid(oItem))
                {
                    nTemp = StringToInt(Get2DACache("baseitems", "WeaponType", GetBaseItemType(oItem)));
                    if(nTemp && (nTemp != 2))   //piercing and slashing weapons
                        IPSafeAddItemProperty(oItem,ItemPropertyKeen(), 600.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
                }
                break;
            }
            case SPELL_VIRTUOSO_MINDBENDING_MELODY:
            {
                break;
            }
            case SPELL_VIRTUOSO_GREATER_CALUMNY:
            {
                break;
            }
            case SPELL_VIRTUOSO_MAGICAL_MELODY:
            {
                if(spellsIsTarget(oAffected, SPELL_TARGET_ALLALLIES, oPC))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR)), oAffected, fDuration,TRUE,-1,nCasterLevel);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE)), oAffected, fDuration,TRUE,-1,nCasterLevel);
                }
                break;
            }
            case SPELL_VIRTUOSO_SONG_OF_FURY:
            {
                if(spellsIsTarget(oAffected, SPELL_TARGET_ALLALLIES, oPC))
                {
                    int iVoice;
                    switch(d3())
                    {
                         case 1: iVoice = VOICE_CHAT_BATTLECRY1;
                                 break;
                         case 2: iVoice = VOICE_CHAT_BATTLECRY2;
                                 break;
                         case 3: iVoice = VOICE_CHAT_BATTLECRY3;
                                 break;
                    }
                    PlayVoiceChat(iVoice, oAffected);

                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAffected, fDuration,TRUE,-1,nCasterLevel);
                }
                break;
            }
            case SPELL_VIRTUOSO_REVEALING_MELODY:
            {

                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAffected, fDuration,TRUE,-1,17);

                break;
            }
        }
        oAffected = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
    }
}