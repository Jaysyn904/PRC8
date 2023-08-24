/*:://////////////////////////////////////////////
//:: Name On Equip Item - Cursed Items etc.
//:: FileName SMP_EVT_Equip
//:://////////////////////////////////////////////
    When cirtain items are equipped, they could be cursed - but appear as normal
    items.

    This includes the functions and code for cursed items - equipping them
    allows them to function as they do - cannot be removed except via.
    Remove Curse, for instance - and the proper item properties (EG: -5 AC
    rather then +5 AC) are added.

    The cursed items are done by tag and/or flags as variables. Most cursed
    items also require the use of other events - obviously including the On
    Item Unequip event.

    These cursed items are optional - and disabled by default (nothing happens
    when equipped, picked up or anything).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{

/*:://////////////////////////////////////////////
//:: Curses - Effects Applied / Notes
//:://////////////////////////////////////////////
    Simple curses:

    - Opposite effect
    - Drawback
    - Completely different effect

    Can be put on many normal items.


    Special items:

    - Boots of dancing:
      * Produces a unremovable Ottos Irresisstable Dance effect (but orignal
        item powers are kept), until Remove Curse is cast on the character - thusly
        removing the cursed effect and the boots.

    - Bracers of Defenselessness:
      * Appear to be +5 bracers, but the enchantment is replaced with -5 AC!
        Cannot be removed until Remove Curse is used.

    - Cloak of Poisonousness:
      * DC 28 fortitude save, or death! Remove curse removes this item's power
        and it can then be removed - if they were sucessful at not dying.

    - Dust of Sneezing and Choking:
      * Not equipped. New spell (identified under the normal Dust of Appearance
        item property name) which causes 2d4 con damage (DC 15 to resist) and
        an additional 1d4 (DC15 to resist, 1 minute later) - and stunned for 5d4
        rounds.


//::////////////////////////////////////////////*/
}
