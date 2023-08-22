#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    //Define vars
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nDC = PRCGetSaveDC(oTarget, oPC);
    effect eCharm = EffectCharmed();
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDom = EffectCutsceneDominated();
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = HoursToSeconds(24 * nCasterLvl);

    //Link charm and persistant VFX
    //Not necessary anymore, might want to rename eLink2
//    effect eLink = EffectLinkEffects(eVis, eDur);
//    eLink = EffectLinkEffects(eLink, eCharm);
//    eLink = SupernaturalEffect(eLink);

    //Link domination and persistant VFX
    effect eLink2 = EffectLinkEffects(eVis, eDom);
    eLink2 = EffectLinkEffects(eLink2, eDur);
    eLink2 = SupernaturalEffect(eLink2);

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_COMMAND_UNDEAD, oPC);

    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration *= 2;

    object oCreatureSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
    
    //Undead
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
            //Check Spell Resistance
            if (!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
            {
                    //Dominate mindless
                    if(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 11)
                    {
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration);
                    }
                    else
                    {
//			  Doesn't seem to work anyway
//                        RemoveSpecificProperty(oCreatureSkin, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_MINDSPELLS);  
                        
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC, 1.0))
                        {

			    object oFaction = GetFirstFactionMember(oTarget, FALSE);
			    if (oFaction == oTarget)				
				oFaction = GetNextFactionMember(oTarget, FALSE);
			    ChangeToStandardFaction(oTarget, STANDARD_FACTION_DEFENDER);
			    AssignCommand(oTarget, ClearAllActions());
                            SetIsTemporaryFriend(oPC, oTarget, FALSE);

			    if(oFaction == OBJECT_INVALID)
			    {
			     DelayCommand(6.0, ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE));
			    }

			    else
			    {
			     DelayCommand(fDuration, ChangeFaction(oFaction, oTarget));
			    }

			     DelayCommand(fDuration, SetIsTemporaryEnemy(oPC, oTarget, FALSE));

			     //Doesn't do anything anyway
 			     //SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                        }
                    }
            }
    }
    else
        FloatingTextStringOnCreature("Target isn't Undead", oPC, FALSE);
        
    PRCSetSchool();
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oCreatureSkin);
}