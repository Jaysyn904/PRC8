//::///////////////////////////////////////////////
//:: Mislead
//:: sp_mislead.nss
//:://////////////////////////////////////////////
/*
Illusion (Figment, Glamer)
Level: Brd 5, Luck 6, Sor/Wiz 6, Trickery 6
Components: S
Casting Time: 1 standard action
Range: Close (8M)
Target/Effect: You/one illusory double
Duration: 1 round/level (D) and concentration + 3 rounds; see text
Saving Throw: None or Will disbelief (if interacted with); see text
Spell Resistance: No

You become invisible (as improved invisibility, a glamer), and at the same
time, an illusory double of you (as major image, a figment) appears. You are
then free to go elsewhere while your double moves away. The double appears
within range but thereafter moves as you direct it. You can make the figment
appear superimposed perfectly over your own body so that observers don’t
notice an image appearing and you turning invisible. The double moves at
your speed and can talk and gesture as if it were real, but it cannot
attack or cast spells, though it can pretend to do so.

Actions you can give it as a henchmen is "Follow" "Do nothing (stand ground)"
"Attack (Pretend to attack)".

The illusory double lasts as long as you concentrate upon it, plus 3
additional rounds. After you cease concentration, the illusory double
continues to carry out the same activity until the duration expires. The
improved invisibility lasts for 1 round per level, regardless of concentration.

*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: June 20, 2010
//:://////////////////////////////////////////////

#include "prc_inc_spells"


void CleanCopy(object oImage)
{
    SetLootable(oImage, FALSE);
    // remove inventory contents
    object oItem = GetFirstItemInInventory(oImage);
    while(GetIsObjectValid(oItem))
    {
        SetPlotFlag(oItem,FALSE);
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem2))
            {
                object oItem3 = GetFirstItemInInventory(oItem2);
                while(GetIsObjectValid(oItem3))
                {
                    SetPlotFlag(oItem3,FALSE);
                    DestroyObject(oItem3);
                    oItem3 = GetNextItemInInventory(oItem2);
                }
                SetPlotFlag(oItem2,FALSE);
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oImage);
    }
    // remove non-visible equipped items
    int i;
    for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
    {
        oItem = GetItemInSlot(i, oImage);
        if(GetIsObjectValid(oItem))
        {
            if(i == INVENTORY_SLOT_HEAD || i == INVENTORY_SLOT_CHEST ||
                i == INVENTORY_SLOT_RIGHTHAND || i == INVENTORY_SLOT_LEFTHAND ||
                i == INVENTORY_SLOT_CLOAK) // visible equipped items
            {
                SetDroppableFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, TRUE);
                // remove all item properties
                itemproperty ipLoop=GetFirstItemProperty(oItem);
                while (GetIsItemPropertyValid(ipLoop))
                {
                    RemoveItemProperty(oItem, ipLoop);
                    ipLoop=GetNextItemProperty(oItem);
                }
            }
            else // can't see it so destroy
            {
                SetPlotFlag(oItem,FALSE);
                DestroyObject(oItem);
            }
        }
    }
    TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

object CreateImage(object oPC)
{
    string sImage = "PC_IMAGE"+ObjectToString(oPC)+"mislead";
    effect eConseal = EffectConcealment(100);
    effect eMiss = EffectMissChance(100);
    effect eImmune = EffectSpellLevelAbsorption(9);
    effect eGhost = EffectCutsceneGhost();
    effect eDominated = EffectCutsceneDominated();
    effect eLink = EffectLinkEffects(eConseal, eMiss);
    eLink = EffectLinkEffects(eLink, eImmune);
    eLink = EffectLinkEffects(eLink, eGhost);
    eLink = EffectLinkEffects(eLink, eDominated);
    eLink = SupernaturalEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhost, oPC, 0.05f);

    // make, then clean up
    object oImage = CopyObject(oPC, GetLocation(oPC), OBJECT_INVALID, sImage);
    CleanCopy(oImage);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oImage);
    //Spellfail :)
    SetLocalInt(oImage, "DarkDiscorporation", TRUE);

    /*SetCommandable(TRUE, oImage);
    ChangeToStandardFaction(oImage, STANDARD_FACTION_DEFENDER);
    SetIsTemporaryFriend(OBJECT_SELF, oImage, FALSE);*/
    // We will start the heartbeat - delayed due to concentration check
    DelayCommand(2.0f, ExecuteScript("sp_mislead_x", oImage));

    return oImage;
}

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ILLUSION);

    float fDuration = RoundsToSeconds(PRCGetCasterLevel(OBJECT_SELF));

    if(GetHasFeat(FEAT_INSIDIOUSMAGIC, OBJECT_SELF) && GetHasFeat(FEAT_SHADOWWEAVE, OBJECT_SELF))
       fDuration *= 2;

    int nMetaMagic = PRCGetMetaMagicFeat();
    if(CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        fDuration *= 2; //Duration is +100%
    }

    effect eVfx = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
    effect eEff = EffectLinkEffects(EffectInvisibility(INVISIBILITY_TYPE_IMPROVED), EffectVisualEffect(VFX_DUR_INVISIBILITY));
           eEff = EffectLinkEffects(eEff, EffectConcealment(50));
           eEff = EffectLinkEffects(eEff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

    // Remove pervious castings of it
    PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_MISLEAD);

    // Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_MISLEAD, FALSE));

    //Create the image
    object oImage = CreateImage(OBJECT_SELF);

    // Apply VFX and effect.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVfx, OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEff, OBJECT_SELF, fDuration);

    PRCSetSchool();
}