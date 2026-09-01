//::///////////////////////////////////////////////
//:: Name      Eldritch Glaive
//:: FileName  inv_eldrtch_glv.nss
//::///////////////////////////////////////////////
/*

Least Invocation
Blast Shape
2nd Level Spell

Your eldritch blast takes on the physical form of a
glaive. If you hit with the glaive, the target is
hit as if with your eldritch blast, including any
essence applied. The glaive dissipates next round.

*/
//::///////////////////////////////////////////////

void CheckForAttack(object oPC, object oTarget, object oGlaive);

#include "prc_inc_combat"
#include "inv_inc_invfunc"
#include "inv_inc_blast"

void CheckForAttack(object oPC, object oTarget, object oGlaive)
{
	if (oGlaive == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
	{
    	//Set up to delete after duration ends
    	DestroyObject(oGlaive, 6.0f);
    	int nAtkBns = GetHasFeat(FEAT_ELDRITCH_SCULPTOR, oPC) ? 2 : 0;

    	//Schedule the attack. 
    	DelayCommand(0.0, PerformAttackRound(oTarget, oPC, EffectVisualEffect(VFX_IMP_MAGBLUE),
        	0.0, nAtkBns, 0, 0, TRUE, "*Eldritch Glaive Hit*", "*Eldritch Glaive Miss*",
        	TRUE, TOUCH_ATTACK_MELEE, FALSE, PRC_COMBATMODE_ALLOW_TARGETSWITCH));

    	//Fire cast spell at event for the specified target
    	DelayCommand(0.0, SignalEvent(oTarget, EventSpellCastAt(oPC, INVOKE_ELDRITCH_BLAST)));
        // Target is valid and we know it's an enemy and we're in combat
        DelayCommand(0.25, AssignCommand(oPC, ActionAttack(oTarget)));

        // We set INV_HELLFIRE for the next 6 seconds while the eldritch gaive completes
        if(GetIsHellFireBlast(oPC))
        {
            if(HellFireConDamage(oPC))
            {
                SetLocalInt(OBJECT_SELF, "INV_HELLFIRE", TRUE);
                DelayCommand(6.0, DeleteLocalInt(oPC, "INV_HELLFIRE"));
            }
        }
    }
    else
    	DelayCommand(0.1, CheckForAttack(oPC, oTarget, oGlaive));
}

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    if (oPC == oTarget)
    	return;
    object oGlaive = CreateItemOnObject("prc_eldrtch_glv", oPC);
    
    /*if (PRCGetCreatureSize(oPC) == CREATURE_SIZE_SMALL)
    	oGlaive = CreateItemOnObject("prc_eldrtch_gls", oPC);
    else
    	oGlaive = CreateItemOnObject("prc_eldrtch_glv", oPC);*/
    //nAtkBns += GetAttackBonus(oTarget, oPC, OBJECT_INVALID, FALSE, TOUCH_ATTACK_MELEE_SPELL);

    // Construct the bonuses
    itemproperty ipAddon = ItemPropertyOnHitCastSpell(IP_CONST_CASTSPELL_ELDRITCH_GLAIVE_ONHIT, (GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK) + 1) / 2);
    AddItemProperty(DURATION_TYPE_PERMANENT, ipAddon, oGlaive);

    // Force equip
    ClearAllActions();
    ForceEquip(oPC, oGlaive, INVENTORY_SLOT_RIGHTHAND);

    // Make even more sure the glaive cannot be dropped
    SetDroppableFlag(oGlaive, FALSE);
    SetItemCursedFlag(oGlaive, TRUE);
    
    CheckForAttack(oPC, oTarget, oGlaive);
}
