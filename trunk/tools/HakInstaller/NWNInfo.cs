using System;
using System.IO;
using Microsoft.Win32;

namespace NWN
{
	/// <summary>
	/// This class encapsulates various information about the NWN application.
	/// </summary>
	public class NWNInfo
	{
		#region public static properties/methods
		/// <summary>
		/// Gets whether or not NWN is installed on this PC.
		/// </summary>
		public static bool IsInstalled { get { return singleton.installed; } }

		/// <summary>
		/// Returns true if XP1 is installed.
		/// </summary>
		public static bool IsXP1Installed { 
            get { return singleton.isXP1Installed; }
            set { singleton.isXP1Installed = value; }
        }

		/// <summary>
		/// Returns true if XP2 is installed.
		/// </summary>
		public static bool IsXP2Installed { 
            get { return singleton.isXP2Installed; }
            set { singleton.isXP2Installed = value; }
        }
	
		/// <summary>
		/// Returns true if the OC modules are installed.
		/// </summary>
		public static bool IsOCModsInstalled
		{
			get
			{
				// Return true if all of the modules are on disk.
				foreach (string module in ocModules)
				{
					string file = Path.Combine(NWMPath, module);
					if (!File.Exists(file)) return false;
				}
				return true;
			}
		}

		/// <summary>
		/// Returns true if the XP1 modules are installed.
		/// </summary>
		public static bool IsXP1ModsInstalled
		{
			get
			{
				// Return true if all of the modules are on disk.
				foreach (string module in xp1Modules)
				{
					string file = Path.Combine(NWMPath, module);
					if (!File.Exists(file)) return false;
				}
				return true;
			}
		}

		/// <summary>
		/// Returns true if the XP2 modules are installed.
		/// </summary>
		public static bool IsXP2ModsInstalled
		{
			get
			{
				// Return true if all of the modules are on disk.
				foreach (string module in xp2Modules)
				{
					string file = Path.Combine(NWMPath, module);
					if (!File.Exists(file)) return false;
				}
				return true;
			}
		}

		/// <summary>
		/// Gets the list of OC modules.
		/// </summary>
		public static string[] OCModules { get { return ocModules; } }

		/// <summary>
		/// Gets the list of XP1 modules
		/// </summary>
		public static string[] XP1Modules { get { return xp1Modules; } }

		/// <summary>
		/// Gets the list of XP2 modules.
		/// </summary>
		public static string[] XP2Modules { get { return xp2Modules; } }

		/// <summary>
		/// Gets/sets the path that NWN is installed in.  The path may be set to
		/// allow for the manipulation of NWN on remote installs or for multiple
		/// installs.  If the path is set to string.Empty, then the value will
		/// revert back to the install path in the registry.
		/// </summary>
		public static string InstallPath
		{
			get
			{
				return string.Empty == singleton.overridePath ?
					singleton.installPath : singleton.overridePath;
			}
			set
			{
				singleton.overridePath = value;
			}
		}
		
		/// <summary>
		/// Gets the path for the bioware modules.
		/// </summary>
		public static string NWMPath { get { return Path.Combine(InstallPath, "nwm"); } }

		/// <summary>
		/// Gets the path for the tools subdirectory.
		/// </summary>
		public static string ToolsPath { get { return Path.Combine(InstallPath, "Utils"); } }

		/// <summary>
		/// Gets the path for the modules subdirectory.
		/// </summary>
		public static string ModulesPath { get { return Path.Combine(InstallPath, "Modules"); } }

		/// <summary>
		/// Gets the path for the hak info files.
		/// </summary>
		public static string HakInfoPath { get { return HakPath; } }

		/// <summary>
		/// Gets the path for the hak .
		/// </summary>
		public static string HakPath { get { return Path.Combine(InstallPath, "hak"); } }

		/// <summary>
		/// Gets the installed NWN version.
		/// </summary>
		public static string Version { 
            get { return singleton.version; }
            set { singleton.version = value; }
        }

		/// <summary>
		/// Gets the full path for the specified NWN file.
		/// </summary>
		/// <param name="file">The NWM file to get the full path for.</param>
		/// <returns>The full path to the NWM file.</returns>
		public static string GetFullFilePath(string file)
		{
			return Path.Combine(GetPathForFile(file), file);
		}

		/// <summary>
		/// Gets the partial path (relative to the NWN install directory) of
		/// the file, i.e. hak\foo.hak, etc.
		/// </summary>
		/// <param name="file">The NWM file to get the full path for.</param>
		/// <returns>The partial path to the NWM file.</returns>
		public static string GetPartialFilePath(string file)
		{
			// Determine the path based on the file's extension.  Hif files are
			// a new file type (hack info) that we use to store information about
			// what files are contained in a 'hak'.
			FileInfo info = new FileInfo(file);
			switch (info.Extension.ToLower())
			{
				case ".tlk":
					return Path.Combine("tlk", file);
				case ".erf":
					return Path.Combine("erf", file);
				case ".hif":
				case ".hak":
					return Path.Combine("hak", file);
				case ".mod":
					return Path.Combine("modules", file);
				case ".nwm":
					return Path.Combine("nwm", file);
				default:
					return file;
			}
		}

		/// <summary>
		/// This method gets the path that the specified NWN file should be
		/// installed in.  It supports .mod, .nwm, .tlk, .erf, .hak file types.
		/// </summary>
		/// <param name="file">The file to get the path for</param>
		/// <returns>The path that the file should be installed in</returns>
		public static string GetPathForFile(string file)
		{
			// Determine the path based on the file's extension.  Hif files are
			// a new file type (hack info) that we use to store information about
			// what files are contained in a 'hak'.
			FileInfo info = new FileInfo(file);
			switch (info.Extension.ToLower())
			{
				case ".tlk":
					return Path.Combine(InstallPath, "tlk");
				case ".erf":
					return Path.Combine(InstallPath, "erf");
				case ".hif":
				case ".hak":
					return Path.Combine(InstallPath, "hak");
				case ".mod":
					return Path.Combine(InstallPath, "modules");
				case ".nwm":
					return Path.Combine(InstallPath, "nwm");
			}

			// If we get here the file is something we don't know about, return
			// string.Empty.
			return string.Empty;
		}
		#endregion

		#region private fields/properties/methods
		/// <summary>
		/// Class constructor implemented as private, since the object is a singleton
		/// and can only be created internally.
		/// </summary>
		private NWNInfo()
		{
			RegistryKey key = Registry.LocalMachine.OpenSubKey(regPath);

			// If we were able to open up the NWN registry key then NWW is
			// installed on the PC, save the important registration information.
			if (null != key)
			{
				installed = true;
				installPath = key.GetValue(regLocation) as string;
				version = key.GetValue(regVersion) as string;
			}

			// Check for the XP1 Guid registry entry, if it's there then
			// mark XP1 as being installed.
			key = Registry.LocalMachine.OpenSubKey(regXP1Path);
			if (null != key && null != key.GetValue(regGuid)) isXP1Installed = true;

			// Check for the XP2 Guid registry entry, if it's there then
			// mark XP2 as being installed.
			key = Registry.LocalMachine.OpenSubKey(regXP2Path);
			if (null != key && null != key.GetValue(regGuid)) isXP2Installed = true;
		}

		// Module lists for the various modules in the OC/XP1/XP2
		private static string[] ocModules = new string[] { "Prelude.nwm", "Chapter1.nwm", "Chapter1E.nwm", 
			"Chapter2.nwm", "Chapter2E.nwm", "Chapter3.nwm", "Chapter4.nwm" };
		private static string[] xp1Modules = new string[] 
			{ "XP1-Chapter 1.nwm", "XP1-Interlude.nwm", "XP1-Chapter 2.nwm" };
		private static string[] xp2Modules = new string[] 
			{ "XP2_Chapter1.nwm", "XP2_Chapter2.nwm", "XP2_Chapter3.nwm" };

		private const string regPath = @"SOFTWARE\BioWare\NWN\Neverwinter";
		private const string regXP1Path = @"SOFTWARE\BioWare\NWN\Undrentide";
		private const string regXP2Path = @"SOFTWARE\BioWare\NWN\Underdark";
		private const string regGuid = "Guid";
		private const string regLocation = "Location";
		private const string regVersion = "Version";

		private static NWNInfo singleton = new NWNInfo();

		private string installPath = string.Empty;
		private string overridePath = string.Empty;
		private string version = string.Empty;
		private bool installed = false;
		private bool isXP1Installed = false;
		private bool isXP2Installed = false;
		#endregion
	}
}
