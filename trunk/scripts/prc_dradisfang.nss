// This script handles special dragon 'weapons' for Li Lung and Fang Dragon Disciples
//
// Fang - You do not gain a breath weapon as standard Dragon Disciples do.  Rather, at level 3, you gain the ability to perform a special bite attack that will deal 1d4 points of Constitution Drain to your target.  You may use this special bite attack 3 times a day.
// Li Lung - You do not gain any special breath attack.  Instead you gain the ability to "roar" three times per day, deafening everyone within 60 feet with no saving throw.

const string SPECIAL_BREATH_USES = "DragonDiscipleBreathWeaponUses";

/*void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    if(!GetIsObjectValid(oTarget) || oTarget == oPC)
    {
        IncrementRemainingFeatUses(oPC, FEAT_DRAGON_DIS_BREATH);
        SendMessageToPC(oPC, "Invalid target!");
    }
*/
void main()
{}