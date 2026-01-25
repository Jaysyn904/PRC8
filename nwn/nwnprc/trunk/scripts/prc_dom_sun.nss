//::///////////////////////////////////////////////  
//:: Sun Domain Power  
//:: prc_dom_sun.nss  
//:://////////////////////////////////////////////  
/*  
    Type of Feat: Domain.  
  
    Specifics: Once per day, you can perform a greater turning   
    against undead in place of a regular turning. The greater   
    turning destroys undead instead of turning them.  
  
    Use: Selected.  
*/  
//:://////////////////////////////////////////////  
#include "inc_newspellbook"
#include "prc_inc_domain"
#include "prc_inc_spells"  
  
void main()  
{  
    object oPC = OBJECT_SELF;  
  
    // Used by the uses per day check code for bonus domains
    if(!DecrementDomainUses(PRC_DOMAIN_SUN, oPC)) return; 
	
	if(!CheckTurnUndeadUses(oPC, 1))
    {
        SpeakStringByStrRef(40550);
        return;
    }
	
    // Mystics with sun domain can turn undead, but can't use greater turning
    int bMystic = GetLevelByClass(CLASS_TYPE_MYSTIC, oPC) && GetHasFeat(FEAT_BONUS_DOMAIN_SUN, oPC);

    if(bMystic)
    {
        if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
            return;
    }	
  
    ActionDoCommand(SetLocalInt(oPC, "UsingSunDomain", TRUE));
    ActionCastSpellAtObject(SPELLABILITY_TURN_UNDEAD, oPC, METAMAGIC_ANY, TRUE);
    ActionDoCommand(DelayCommand(0.1f, DeleteLocalInt(oPC, "UsingSunDomain")));
}


/* void main()
{
    object oPC = OBJECT_SELF;

    // Used by the uses per day check code for bonus domains
    if(!DecrementDomainUses(PRC_DOMAIN_SUN, oPC)) return;

    // Mystics with sun domain can turn undead, but can't use greater turning
    int bMystic = GetLevelByClass(CLASS_TYPE_MYSTIC, oPC) && GetHasFeat(FEAT_BONUS_DOMAIN_SUN, oPC);

    if(bMystic)
    {
        if(!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
            return;
    }
    else ActionDoCommand(SetLocalInt(oPC, "UsingSunDomain", TRUE));
    ActionCastSpell(SPELLABILITY_TURN_UNDEAD);
    ActionDoCommand(DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD));
    ActionDoCommand(DeleteLocalInt(oPC, "UsingSunDomain"));
} */