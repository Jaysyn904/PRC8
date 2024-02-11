//::///////////////////////////////////////////////
//:: Manual of Gainful Exercise
//:: Manual of Quickness of Action
//:: Manual of Bodily Health
//:: Tome of Clear Thought
//:: Tome of Understanding
//:: Tome of Leadership and Influence
//:: is_prc_tome.nss
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Item should be a book with tag = PRC_TOME and
//:: resref = prc_it_tome_x_y.uti, where x is the
//:: ability (0=Str, 1=Dex, 2=Con, 3=Int, 4=Wis,
//:: 5=Cha), and y is bonus (1-5).
//:://////////////////////////////////////////////
/*================================================
Manual of Gainful Exercise: This thick tome
contains exercise descriptions and diet
suggestions, but entwined within the words is a
powerful magical effect. If anyone reads this book,
which takes a total of 48 hours over a minimum of
six days, she gains an inherent bonus of from +1
to +5 (depending on the type of manual) to her
Strength score. Once the book is read, the magic
disappears from the pages and it becomes a normal
book.

Strong evocation (if miracle is used); CL 17th;
Craft Wondrous Item, wish or miracle;
Price 27,500 gp (+1), 55,000 gp (+2), 82,500 gp
(+3), 110,000 gp (+4), 137,500 gp (+5);
Cost 1,250 gp + 5,100 XP (+1), 2,500 gp + 10,200 XP (+2),
3,750 gp + 15,300 XP (+3), 5,000 gp + 20,400 XP (+4),
6,250 gp + 25,500 XP (+5); Weight 5 lb.
==================================================
Manual of Quickness of Action: This thick tome
contains tips on coordination exercises and
balance, but entwined within the words is a
powerful magical effect. If anyone reads this
book, which takes a total of 48 hours over a
minimum of six days, he gains an inherent bonus of
from +1 to +5 (depending on the type of manual) to
his Dexterity score. Once the book is read, the
magic disappears from the pages and it becomes a
normal book.

Strong evocation (if miracle is used); CL 17th;
Craft Wondrous Item, wish or miracle;
Price 27,500 gp (+1), 55,000 gp (+2), 82,500 gp
(+3), 110,000 gp (+4), 137,500 gp (+5);
Cost 1,250 gp + 5,100 XP (+1), 2,500 gp + 10,200 XP (+2),
3,750 gp + 15,300 XP (+3), 5,000 gp + 20,400 XP (+4),
6,250 gp + 25,500 XP (+5); Weight 5 lb.
==================================================
Manual of Bodily Health: This thick tome contains
tips on health and fitness, but entwined within
the words is a powerful magical effect. If anyone
reads this book, which takes a total of 48 hours
over a minimum of six days, he gains an inherent
bonus of from +1 to +5 (depending on the type of
manual) to his Constitution score. Once the book
is read, the magic disappears from the pages and
it becomes a normal book. 

Strong evocation (if miracle is used); CL 17th;
Craft Wondrous Item, wish or miracle;
Price 27,500 gp (+1), 55,000 gp (+2), 82,500 gp
(+3), 110,000 gp (+4), 137,500 gp (+5);
Cost 1,250 gp + 5,100 XP (+1), 2,500 gp + 10,200 XP (+2),
3,750 gp + 15,300 XP (+3), 5,000 gp + 20,400 XP (+4),
6,250 gp + 25,500 XP (+5); Weight 5 lb.
==================================================
Tome of Clear Thought: This heavy book contains
instruction on improving memory and logic, but
entwined within the words is a powerful magical
effect. If anyone reads this book, which takes a
total of 48 hours over a minimum of six days, she
gains an inherent bonus of from +1 to +5
(depending on the type of tome) to her
Intelligence score. Once the book is read, the
magic disappears from the pages and it becomes a
normal book. Because the tome of clear thought
provides an inherent bonus, the reader will earn
extra skill points when she attains a new level.

Strong evocation (if miracle is used); CL 17th;
Craft Wondrous Item, miracle or wish;
Price 27,500 gp (+1), 55,000 gp (+2), 82,500 gp (+3),
110,000 gp (+4), 137,500 gp (+5);
Cost 1,250 gp + 5,100 XP (+1), 2,500 gp + 10,200 XP (+2),
3,750 gp + 15,300 XP (+3), 5,000 gp + 20,400 XP (+4),
6,250 gp + 25,500 XP (+5); Weight 5 lb.
==================================================
Tome of Understanding: This thick book contains
tips for improving instinct and perception, but
entwined within the words is a powerful magical
effect. If anyone reads this book, which takes a
total of 48 hours over a minimum of six days, she
gains an inherent bonus of from +1 to +5
(depending on the type of tome) to her Wisdom
score. Once the book is read, the magic disappears
from the pages and it becomes a normal book.

Strong evocation (if miracle is used); CL 17th;
Craft Wondrous Item, miracle or wish;
Price 27,500 gp (+1), 55,000 gp (+2), 82,500 gp (+3),
110,000 gp (+4), 137,500 gp (+5);
Cost 1,250 gp + 5,100 XP (+1), 2,500 gp + 10,200 XP (+2),
3,750 gp + 15,300 XP (+3), 5,000 gp + 20,400 XP (+4),
6,250 gp + 25,500 XP (+5); Weight 5 lb.
==================================================
Tome of Leadership and Influence: This ponderous
book details suggestions for persuading and
inspiring others, but entwined within the words is
a powerful magical effect. If anyone reads this
book, which takes a total of 48 hours over a
minimum of six days, he gains an inherent bonus of
from +1 to +5 (depending on the type of tome) to
his Charisma score. Once the book is read, the
magic disappears from the pages and it becomes a
normal book.

Strong evocation (if miracle is used); CL 17th;
Craft Wondrous Item, miracle or wish;
Price 27,500 gp (+1), 55,000 gp (+2), 82,500 gp (+3),
110,000 gp (+4), 137,500 gp (+5);
Cost 1,250 gp + 5,100 XP (+1), 2,500 gp + 10,200 XP (+2),
3,750 gp + 15,300 XP (+3), 5,000 gp + 20,400 XP (+4),
6,250 gp + 25,500 XP (+5); Weight 5 lb.
================================================*/

#include "x2_inc_switches"
#include "prc_inc_function"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    if(nEvent == X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC = GetItemActivator();
        string sResRef = GetResRef(GetItemActivated());
        string sAbility = GetSubString(sResRef, 12, 1);
        string sData = "PRC_InherentBonus_"+sAbility;
        int nBonus = StringToInt(GetStringRight(sResRef, 1));

        //Inherent bonuses do not stack
        if(nBonus > GetPersistantLocalInt(oPC, sData))
        {
            DestroyObject(GetItemActivated());
            SetPersistantLocalInt(oPC, sData, nBonus);
            SetPersistantLocalInt(oPC, "PRC_InherentBonus", TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oPC);
            EvalPRCFeats(oPC);
        }
        else
            FloatingTextStringOnCreature("You cannot gain any benefit from reading the book.", oPC, FALSE);

        SetExecutedScriptReturnValue();
    }
}