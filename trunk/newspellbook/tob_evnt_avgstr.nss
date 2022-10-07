//::///////////////////////////////////////////////
//:: Name     Avenging Strike On Hit
//:: FileName  tob_evnt_avgstr.nss
//:://////////////////////////////////////////////
/** Benefit: As a swift action, you can channel the
power of your faith and energy to enhance a single
attack you make. You gain a bonus equal to your CHA
bonus (if any) on the attack roll and damage roll
for the next melee attack you make against an evil
outsider. You can use this ability a number of times
per day equal to your charisma bonus (minimum 1).

Author:    Tenjac
Created:   20.3.2007
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oWielder = OBJECT_SELF;  
        object oTarget = PRCGetSpellTargetObject();
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oWielder);
        object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oWielder);
        int nType = MyPRCGetRacialType(oTarget);
        int nAlign = GetAlignmentGoodEvil(oTarget);
        int nSpell;
        
        if(nAlign == ALIGNMENT_EVIL && nType == RACIAL_TYPE_OUTSIDER)
        {
                //Remove script
                RemoveEventScript(oWeap, EVENT_ONHIT, "tob_evnt_avgstr");
                RemoveEventScript(oWeap2, EVENT_ONHIT, "tob_evnt_avgstr");
                
                //remove spell effects
                effect eTest = GetFirstEffect(oWielder);
                
                while (GetIsEffectValid(eTest))
                {
                        nSpell = GetEffectSpellId(eTest);
                        if(nSpell == SPELL_AVENGING_STRIKE)
                        {
                                RemoveEffect(oWielder, eTest);
                        }
                        eTest = GetNextEffect(oWielder);
                }
        }                       
}