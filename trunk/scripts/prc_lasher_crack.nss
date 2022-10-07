//::///////////////////////////////////////////////
//:: Lasher - Crack of Fate/Doom
//:: Copyright (c) 2005
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC

    code "borrowed" from tempest two weapon feats

    code modified to allow toggling, switching
        between crack of fate/doom
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 24, 2005
//:: Modified: Jan 23, 2006
//:://////////////////////////////////////////////

//compiler would completely crap itself unless this include was here
#include "prc_alterations"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    //string sMessage = "";

    int iClassLevel = GetLevelByClass(CLASS_TYPE_LASHER, oPC);
    int nAttacks;
    int nPenalty;
    int nSpellID = GetSpellId();
    int nCrackLevel = GetLocalInt(oPC, "PRC_LASHER_CRACK");


    //new toggle code
    PRCRemoveSpellEffects(SPELL_LASHER_CRACK_FATE, oPC, oPC);
    PRCRemoveSpellEffects(SPELL_LASHER_CRACK_DOOM, oPC, oPC);

    if(GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) != BASE_ITEM_WHIP)
    {
        if(nCrackLevel == 1)
            FloatingTextStringOnCreature("*Crack of Fate Deactivated*", oPC, FALSE);
        else if(nCrackLevel == 2)
            FloatingTextStringOnCreature("*Crack of Doom Deactivated*", oPC, FALSE);
        DeleteLocalInt(oPC, "PRC_LASHER_CRACK");
        SendMessageToPC(oPC, "You must have a whip equipped for this feat to work");
        return;
    }

    if(nSpellID == SPELL_LASHER_CRACK_FATE)
        nAttacks = 1;
    else if(nSpellID == SPELL_LASHER_CRACK_DOOM)
        nAttacks = 2;

    if(nAttacks == nCrackLevel) //toggle off, effects removed already
    {
        if(nAttacks == 1)
            FloatingTextStringOnCreature("*Crack of Fate Deactivated*", oPC, FALSE);
        else if(nAttacks == 2)
            FloatingTextStringOnCreature("*Crack of Doom Deactivated*", oPC, FALSE);
        DeleteLocalInt(oPC, "PRC_LASHER_CRACK");
        return;
    }
    else
    {   //apply extra attacks
        nPenalty = nAttacks * 2;
        effect eAttacks = SupernaturalEffect(EffectModifyAttacks(nAttacks));
        effect ePenalty = SupernaturalEffect(EffectAttackDecrease(nPenalty));
        effect eLink = EffectLinkEffects(eAttacks, ePenalty);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

        if(nAttacks == 1)
            FloatingTextStringOnCreature("*Crack of Fate Activated*", oPC, FALSE);
        else if(nAttacks == 2)
            FloatingTextStringOnCreature("*Crack of Doom Activated*", oPC, FALSE);
        SetLocalInt(oPC, "PRC_LASHER_CRACK", nAttacks);
    }

    /*  old code
    if(!GetHasSpellEffect(SPELL_LASHER_CRACK, oPC) )
    {
        if(GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_WHIP)
        {   //apply effects if holding a whip
            if(iClassLevel > 2)
            {
                nAttacks = ((iClassLevel + 2) / 5);
                if(nAttacks > 2)
                    nAttacks = 2;
                nPenalty = nAttacks * 2;

                effect eAttacks = SupernaturalEffect(EffectModifyAttacks(nAttacks));
                effect ePenalty = SupernaturalEffect(EffectAttackDecrease(nPenalty));
                effect eLink = EffectLinkEffects(eAttacks, ePenalty);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
            }
        }
        else
        {
            FloatingTextStringOnCreature("*Invalid Weapon. Ability Not Activated!*", oPC, FALSE);
        }
    }
    else
    {
        // Removes effects, not too sure if I need this bit
        PRCRemoveSpellEffects(SPELL_LASHER_CRACK, oPC, oPC);

    }
    */
}