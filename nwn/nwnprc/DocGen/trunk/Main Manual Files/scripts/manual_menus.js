<!--

/*

PRC Manual Menu Script
By Psi

*/

function setStatus(message)
{
	top.status = message;
	return true;
}

function unsetStatus()
{
	top.status = "";
	return true;
}

function openContent(type)
{
	switch(type)
	{
		case "main" : top.content.location = "../content/manual_content_main.html"; top.contentmenu.location = "../content/manual_content_blank.html"; break;
		case "baseclasses" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_base_classes.html"; break;
		case "prestigeclasses" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_prestige_classes.html"; break;
		case "domains" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_domains.html"; break;
		case "feats" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_feat.html"; break;
		case "epicfeats" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_epic_feat.html"; break;
		case "races" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_races.html"; break;
		case "psionicpowers" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_psionic_powers.html"; break;
		case "utterances" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_truename_utterances.html"; break;
		case "invocations" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_invocations.html"; break;
		case "maneuvers" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_maneuvers.html"; break;

		case "skills" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_skills.html"; break;

		case "spells" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_spells.html"; break;
		case "epicspells" : top.content.location = "../content/manual_content_epicspell.html"; top.contentmenu.location = "manual_menus_epic_spells.html"; break;
		case "modifiedspells" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_modified_spells.html"; break;
		case "itemcrafting" : top.content.location = "../content/modulebuilding/manual_modulebuilding_new_crafting.html"; top.contentmenu.location = "manual_menus_itemcrafting.html"; break;
		case "modulebuilding" : top.content.location = "../content/modulebuilding/manual_modulebuilding_overridenfiles.html"; top.contentmenu.location = "manual_menus_modulebuilding.html"; break;
		case "prcmaking" : top.content.location = "../content/prcmaking/manual_prcmaking_basics.html"; top.contentmenu.location = "manual_menus_prcmaking.html"; break;
		case "installation" : top.content.location = "../content/installation/prc.htm"; top.contentmenu.location = "manual_menus_installation.html"; break;
		case "playersguide" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_playerguide.html"; break;
		case "languages" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_languages.html"; break;
		case "crafting" : top.content.location = "../content/manual_content_blank.html"; top.contentmenu.location = "manual_menus_itemcrafting.html"; break;

	}
}

-->