/*:://////////////////////////////////////////////
//:: Spell Name Fire Seeds
//:: Spell FileName PHS_S_FireSeeds
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Fire]
    Level: Drd 6, Fire 6, Sun 6
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Targets: Up to four touched acorns or up to eight touched holly berries
    Duration: 10 min./level or until used
    Saving Throw: None or Reflex half; see text
    Spell Resistance: No

    Depending on the version of fire seeds you choose, you turn acorns into
    splash weapons that you or another character can throw, or you turn holly
    berries into bombs that you can detonate on command.

    Acorn Grenades: As many as four acorns turn into special splash weapons that
    can be hurled as far as 20M. A ranged touch attack roll is required to
    strike the intended target. Together, the acorns are capable of dealing 1d6
    points of fire damage per caster level (maximum 20d6), divided up equally
    among the acorns.

    Each acorn explodes upon striking any hard surface. In addition to its
    regular fire damage, it deals 1 point of splash damage per die. A creature
    within this area that makes a successful Reflex saving throw takes only half
    damage; a creature struck directly is not allowed a saving throw.

    Holly Berry Bombs: You turn as many as eight holly berries into special
    bombs. The holly berries are usually placed by hand, since they are too
    light to make effective thrown weapons. If you are within the same area and
    speak a word of command by using you class item, each berry instantly bursts
    into flame, causing 1d8 points of fire damage +1 point per caster level to
    every creature in a 1.67-M radius burst. A creature in the area that makes
    a successful Reflex saving throw takes only half damage.

    Berry Bombs which are held by something when the trigger word is activated
    will still explode as normal, if they are not in the given area, however,
    they will depissitate.

    Material Component: The acorns or holly berries.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    OK, simply put:

    - We use Acorns (A misc. Small item), and add a new item property which
      will cast a spell as if it was a grenade, and acts like one. Reflex saves
      are put as a DC on the item when the property is added, along with the
      caster level. SCRIPT: PHS_S_FIRESEEDS1

    - We use the Berry Bombs as new items. We create the items, and then
      are able to, of course, place them all anywhere or even give them away.
      They are stored as local variables on the caster, so when they activate
      the class item which triggers it, it will get the locals.

      This means no more then 1 casting at once of the berries.

      If the berries are not in the area of the caster, then they will still be
      berries (and look red) but not have the spell save DC needed to trigger
      them, and also be deleted from the array.

      If you enter with any berries, they are stripped of any DC's if the times
      that it's been cast doesn't match the times the caster has cast it.
      SCRIPT: PHS_S_FIRESEEDS2
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FIRE_SEEDS)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    // Target can be the acorn or a holly berry to auto-choose which one.
    object oItem = GetSpellTargetObject(); // Should be an item!
    object oPossessor = GetItemPossessor(oItem);
    object oNewThing, oOldThing;
    int nCnt, nCountOfAcorns, bBreak;
    string sTag = GetTag(oItem);
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Limit caster level to 20
    int nDice = PHS_LimitInteger(nCasterLevel, 20);

    // Duration is 10 minutes a level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // We must be possessing whatever item it is
    if(GetIsObjectValid(oPossessor) &&
       GetObjectType(oItem) == OBJECT_TYPE_ITEM)
    {
        // Signal event
        PHS_SignalSpellCastAt(oCaster, PHS_SPELL_FIRE_SEEDS, FALSE);

        // Apply visual - to the location
        PHS_ApplyLocationVFX(GetLocation(oItem), eVis);

        // We need to know if it is acorns or berries.
        if(sTag == PHS_ITEM_HOLLY_BERRIES)
        {
            // If we have not used up the holly berries yet, we cannto do it
            if(GetIsObjectValid(GetLocalObject(oCaster, "PHS_SPELL_FIRESEEDS_ARRAY1")))
            {
                // We can't do it again
                SendMessageToPC(oCaster, "You have a casting of Fireseeds on Berries already valid. You can only have 1.");
                return;
            }
            // If holly berries, we make several conversions to holly berry bombs.
            // Up to 8 are "converted"
            for(nCnt = 1; (nCnt <= 8 && bBreak != TRUE); nCnt++)
            {
                // Get the old item (might be the targeted berry!)
                oOldThing = GetItemPossessedBy(oCaster, PHS_ITEM_HOLLY_BERRIES);

                // Check if it exsists
                if(GetIsObjectValid(oOldThing))
                {
                    // Destroy old thing
                    DestroyObject(oOldThing);
                    // Create new thing
                    oNewThing = CreateItemOnObject(PHS_ITEM_HOLLY_BERRY_BOMBS, oCaster);

                    // Set, on the new thing, what the save DC is
                    SetLocalInt(oNewThing, "PHS_SPELL_FIRESEEDS_SAVEDC", nSpellSaveDC);

                    // Set to the local array this seed
                    SetLocalObject(oCaster, "PHS_SPELL_FIRESEEDS_ARRAY" + IntToString(nCnt), oNewThing);
                }
                else
                {
                    // Stop the loop
                    bBreak = TRUE;
                }
            }
            // We also apply a duration effect so we can only activate it when
            // the effect is in place
            PHS_ApplyDuration(oCaster, eDur, fDuration);
        }
        else if(sTag == PHS_ITEM_ACORNS)
        {
            // Acorns - we do up to 4. Its not currently choosable.
            // Therefore, we need to get the 4 to affect, if there are less then
            // 4, then we divide nCasterLevel by less then 4.
            oOldThing = GetFirstItemInInventory(oCaster);
            while(GetIsObjectValid(oOldThing))
            {
                // We check the tag. We will find one.
                if(GetTag(oOldThing) == PHS_ITEM_ACORNS &&
                  !GetItemHasItemProperty(oOldThing, ITEM_PROPERTY_CAST_SPELL))
                {
                    // Set it to the caster for now.
                    nCountOfAcorns++;
                    SetLocalObject(oCaster, "PHS_SPELL_FIRESEEDS_ARRAY" + IntToString(nCountOfAcorns), oOldThing);
                }
                oOldThing = GetNextItemInInventory(oCaster);
            }
            // Ok, so we have the items set. Make sure...
            if(nCountOfAcorns > 0)
            {
                // Get the amount of caster levels to use for each
                int nPerEach = PHS_LimitInteger(nDice/nCnt);
                // Create item property
                itemproperty IP_Throw = ItemPropertyCastSpell(PHS_IP_CONST_CASTSPELL_FIRESEED_ACORN, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);

                // We can add the property
                for(nCnt = 1; nCnt <= nCountOfAcorns; nCnt++)
                {
                    // Get the item, and delete it
                    oNewThing = GetLocalObject(oCaster, "PHS_SPELL_FIRESEEDS_ARRAY" + IntToString(nCnt));
                    DeleteLocalObject(oCaster, "PHS_SPELL_FIRESEEDS_ARRAY" + IntToString(nCnt));

                    // Add it for the duration and set the local for the dice
                    SetLocalInt(oNewThing, "PHS_SPELL_FIRESEEDS_SAVEDC", nSpellSaveDC);
                    SetLocalInt(oNewThing, "PHS_SPELL_FIRESEEDS_DICE", nPerEach);

                    // Add the item property
                    AddItemProperty(DURATION_TYPE_TEMPORARY, IP_Throw, oNewThing, fDuration);
                }
            }
            // End acorn things.
        }
    }
}
