#include "inc_newspellbook"
#include "prc_inc_domain"

void main()
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
}