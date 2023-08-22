#include "prc_inc_clsfunc"

void CleanCopy(object oImage)
{
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void CleanAllCopies()
{
    string sImage1 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";
    string sImage2 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"flurry";

    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
        {
         if(GetTag(oCreature) == sImage1 || GetTag(oCreature) == sImage2)
         {
            CleanCopy(oCreature);
         }
         oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
        }
}

void RemoveExtraImages()
{
    string sImage1 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";
    string sImage2 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"flurry";

    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
        {
         if(GetTag(oCreature) == sImage1 || GetTag(oCreature) == sImage2)
         {
         DestroyObject(oCreature, 0.0);
         }
         oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
        }
}

void main2()
{

object oTarget = PRCGetSpellTargetObject();

int iLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, OBJECT_SELF);
int iAdd = iLevel/3;
int iImages = d4(1) + 3;

PRCRemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

SetLocalObject(OBJECT_SELF, "FLURRY_TARGET", oTarget);

FlurryEffects(OBJECT_SELF);

string sImage = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"flurry";

effect eImage = EffectCutsceneGhost();
       eImage = SupernaturalEffect(eImage);
effect eNoSpell = EffectSpellFailure(100);
       eNoSpell = SupernaturalEffect(eNoSpell);

    int iPlus;
    for (iPlus = 0; iPlus < iImages; iPlus++)
    {

     object oImage = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, sImage);

     AssignCommand(oImage, ActionAttack(oTarget, FALSE));
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImage, oImage);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoSpell, oImage);

     ChangeToStandardFaction(oImage, STANDARD_FACTION_DEFENDER);
     SetIsTemporaryFriend(OBJECT_SELF, oImage, FALSE);

     DestroyObject(oImage, iLevel * 60.0); // they dissapear after one minute per level.
    }

    CleanAllCopies();

    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
        {
         if(GetTag(oCreature) == sImage)
         {
         DelayCommand(3.0, SPMakeAttack(oTarget, oCreature));
         }
         oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
        }

}

void main()
{
   // First we'll see if this target is in the flurry list.
   int i;
   string sName1 = "FLURRY_TARGET_";
   object oTarget = PRCGetSpellTargetObject();

   for (i = 0 ; i < 10 ; i++)
   {
      string sName2 = sName1 + IntToString(i);
      if (GetLocalObject(OBJECT_SELF, sName2) == oTarget)
      {
         IncrementRemainingFeatUses(OBJECT_SELF, 3534); // Flurry of Swords
         FloatingTextStringOnCreature("This target has already been selected today.", OBJECT_SELF, FALSE);
         return;
      }
   }

   if (oTarget == OBJECT_SELF)
   {
      IncrementRemainingFeatUses(OBJECT_SELF, 3534); // Flurry of Swords
      FloatingTextStringOnCreature("You may not target yourself.", OBJECT_SELF, FALSE);
      return;
   }

   if (!GetIsReactionTypeHostile(oTarget))
   {
      IncrementRemainingFeatUses(OBJECT_SELF, 3534); // Flurry of Swords
      FloatingTextStringOnCreature("You must target an enemy.", OBJECT_SELF, FALSE);
      return;
   }

   // If it's not on the flurry list, add it to the list
   int iTargets = GetLocalInt(OBJECT_SELF, "FLURRY_TARGET_NUMBER");
   sName1 = "FLURRY_TARGET_" + IntToString(iTargets);

   SetLocalInt(OBJECT_SELF, "FLURRY_TARGET_NUMBER", iTargets + 1);
   SetLocalObject(OBJECT_SELF, sName1, oTarget);

   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));

   // Continue on...
   DelayCommand(0.0, RemoveExtraImages());
   DelayCommand(0.5, main2());
}
