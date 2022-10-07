using System;
using System.IO;
using System.Text;
using NWN;

namespace HakInstaller
{
	/// <summary>
	/// Summary description for PRCHif.
	/// </summary>
	public class PRCHif
	{
		/// <summary>
		/// Gets the file name of the PRC hif.
		/// </summary>
		public static string PRCHifFileName { get { return "PRC Consortium Pack.hif"; } }

		/// <summary>
		/// Gets the full path to the PRC hif.
		/// </summary>
		public static string PRCHifFullPath { get { return NWNInfo.GetFullFilePath(PRCHifFileName); } }

		/// <summary>
		/// Creates a temporary HIF file on disk for the PRC pack.
		/// </summary>
		public static void CreatePRCHif()
		{
			using (StreamWriter writer = new StreamWriter(PRCHifFullPath, false, Encoding.ASCII))
			{
				writer.Write(HIF);
			}
		}

		/// <summary>
		/// String constant for the PRC hif, the PRC version of the installer uses
		/// this as its HIF instead of looking for HIF files.
		/// </summary>
		private const string HIF = 
			"Title : PRC Pack\r\n" +
			"Version : 2.0\r\n" +
			"MinNWNVersion : 1.62, XP1, XP2\r\n" +

			"# Erf for the MMM areas\r\n" +
			"erf : prc_consortium.erf\r\n" +

			"# Haks used by the prc pack.\r\n" +
			"module.Hak : prc_2das.hak\r\n" +
			"module.Hak : prc_craft2das.hak\r\n" +
			"module.Hak : prc_scripts.hak\r\n" +
			"module.Hak : prc_textures.hak\r\n" +
			"module.Hak : prc_misc.hak\r\n" +

			"# Custom tlk used by the prc pack.\r\n" +
			"module.CustomTlk : prc_consortium.tlk\r\n" +

			"# Events that need to be wired up.\r\n" +
			"module.OnAcquireItem : prc_onaquire\r\n" +
			"module.OnActivateItem : prc_onactivate\r\n" +
			"module.OnClientEnter : prc_onenter\r\n" +
			"module.OnClientLeave : prc_onleave\r\n" +
			"module.OnCutsceneAbort : prc_oncutabort\r\n" +
			"module.OnHeartbeat : prc_onheartbeat\r\n" +
			"module.OnModuleLoad : prc_onmodload\r\n" +
			"module.OnPlayerDeath : prc_ondeath\r\n" +
			"module.OnPlayerDying : prc_ondying\r\n" +
			"module.OnPlayerEquipItem : prc_equip\r\n" +
			"module.OnPlayerLevelUp : prc_levelup\r\n" +
			"module.OnPlayerRest : prc_rest\r\n" +
			"module.OnPlayerRespawn : prc_onrespawn\r\n" +
			"module.OnUnaquireItem : prc_onunaquire\r\n" +
			"module.OnPlayerUnequipItem : prc_unequip\r\n" +
			"module.OnUserDefined : prc_onuserdef\r\n" +

			"# Cache PRC scripts for better performance.\r\n" +
			"module.Cache : prc_add_spl_pen\r\n" +
			"module.Cache : prc_add_spell_dc\r\n" +
			"module.Cache : prc_set_dmg_type\r\n" +
			"module.Cache : prc_caster_level\r\n" +
			"module.Cache : prc_onaquire\r\n" +
			"module.Cache : prc_onactivate\r\n" +
			"module.Cache : prc_equip\r\n" +
			"module.Cache : prc_onheartbeat\r\n" +
			"module.Cache : prc_onunaquire\r\n" +
			"module.Cache : prc_onuserdef\r\n";

	}
}
