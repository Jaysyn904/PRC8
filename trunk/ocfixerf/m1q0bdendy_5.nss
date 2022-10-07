// Added compatibility for PRC base classes
#include "prc_class_const"

void main()
{
    object oAttacker = GetLastAttacker();
    if(GetWeaponRanged(GetLastWeaponUsed(oAttacker)) == FALSE)
    {
        SetLocalInt(OBJECT_SELF, "Generic_Surrender",1);
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                                               RADIUS_SIZE_HUGE,
                                               GetLocation(OBJECT_SELF));
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != OBJECT_SELF)
            {
                if(GetIsEnemy(oTarget))
                {
                    AdjustReputation(oTarget, OBJECT_SELF, 50);
                    ClearPersonalReputation(oTarget);
                    SetIsTemporaryFriend(oTarget);
                }
                AssignCommand(oTarget, ClearAllActions());
                AssignCommand(oTarget,ActionAttack(OBJECT_INVALID));
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                                           RADIUS_SIZE_HUGE,
                                           GetLocation(OBJECT_SELF));
        }
        ClearAllActions();
        if(GetLocalInt(GetModule(),"NW_G_M0Q01_FIGHTER_TEST") > 0)
        {
            if(GetLevelByClass(CLASS_TYPE_ANTI_PALADIN, oAttacker)
            || GetLevelByClass(CLASS_TYPE_BARBARIAN, oAttacker)
            || GetLevelByClass(CLASS_TYPE_BARD, oAttacker)
            || GetLevelByClass(CLASS_TYPE_BOWMAN, oAttacker)
            || GetLevelByClass(CLASS_TYPE_BRAWLER, oAttacker)
            || GetLevelByClass(CLASS_TYPE_CRUSADER, oAttacker)
            || GetLevelByClass(CLASS_TYPE_CW_SAMURAI, oAttacker)
            || GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oAttacker)
            || GetLevelByClass(CLASS_TYPE_DUSKBLADE, oAttacker)
            || GetLevelByClass(CLASS_TYPE_FIGHTER, oAttacker)
            || GetLevelByClass(CLASS_TYPE_HEXBLADE, oAttacker)
            || GetLevelByClass(CLASS_TYPE_KNIGHT, oAttacker)
            || GetLevelByClass(CLASS_TYPE_MARSHAL, oAttacker)
            || GetLevelByClass(CLASS_TYPE_MONK, oAttacker)
            || GetLevelByClass(CLASS_TYPE_NOBLE, oAttacker)
            || GetLevelByClass(CLASS_TYPE_PALADIN, oAttacker)
            || GetLevelByClass(CLASS_TYPE_PSYWAR, oAttacker)
            || GetLevelByClass(CLASS_TYPE_RANGER, oAttacker)
            || GetLevelByClass(CLASS_TYPE_SAMURAI, oAttacker)
            || GetLevelByClass(CLASS_TYPE_SCOUT, oAttacker)
            || GetLevelByClass(CLASS_TYPE_SOHEI, oAttacker)
            || GetLevelByClass(CLASS_TYPE_SOULKNIFE, oAttacker)
            || GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oAttacker)
            || GetLevelByClass(CLASS_TYPE_SWORDSAGE, oAttacker)
            || GetLevelByClass(CLASS_TYPE_TRUENAMER, oAttacker)
            || GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oAttacker)
            || GetLevelByClass(CLASS_TYPE_WARBLADE, oAttacker)
			|| GetLevelByClass(CLASS_TYPE_TOTEMIST, oAttacker)
			|| GetLevelByClass(CLASS_TYPE_SOULBORN, oAttacker)
			|| GetLevelByClass(CLASS_TYPE_INCARNATE, oAttacker)
			|| GetLevelByClass(CLASS_TYPE_FACTOTUM, oAttacker)
			|| GetLevelByClass(CLASS_TYPE_BINDER, oAttacker))
            {
                SetLocalInt(GetModule(),"NW_G_M1Q0BMelee",TRUE);
                if(GetLocalInt(GetModule(),"NW_G_M1Q0BRanged"))
                {
                    SetLocalInt(GetModule(),"NW_G_M0Q01_FIGHTER_TEST",2);
                }
            }
            else
            {
                SetLocalInt(GetModule(),"NW_G_M0Q01_NONFIGHTER_PASS2",TRUE);
            }
        }
        SpeakOneLinerConversation();
    }
}