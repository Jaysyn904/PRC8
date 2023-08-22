using System;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Globalization;
using System.Threading;
using System.Windows.Forms;
using HakInstaller.Utilities;
using NWN;

namespace HakInstaller
{
	/// <summary>
	/// Summary description for InstallFormBase.
	/// </summary>
	public class InstallFormBase: Form
	{
		#region public properties/methods
		/// <summary>
		/// Default constructur
		/// </summary>
		public InstallFormBase()
		{
			// Wire up event handlers
			Load += new EventHandler(InstallFormBase_Load);
		}
		#endregion

		#region protected fields/properties/methods
		/// <summary>
		/// Sets the proper values for the string labels.
		/// </summary>
		/// <param name="labelVersion">The version string</param>
		/// <param name="labelPath">The path string</param>
		protected void SetLabels(Label labelVersion, Label labelPath)
		{
			// Load strings for XP1 and XP2 installed if they are otherwise use
			// nothing.
			string xp1 = NWNInfo.IsXP1Installed ? 
				StringResources.GetString("VersionFormatXP1") : string.Empty;
			string xp2 = NWNInfo.IsXP1Installed ? 
				StringResources.GetString("VersionFormatXP2") : string.Empty;

			labelVersion.Text = StringResources.GetString("VersionFormat", NWNInfo.Version, xp1, xp2);
			labelPath.Text = StringResources.GetString("PathFormat", NWNInfo.InstallPath);
		}

		/// <summary>
		/// Loads all of the hack info files into the hak check list box.
		/// </summary>
		protected void LoadHakInfoList(CheckedListBox checkedHaks)
		{
			// Get all of the modules in the module directory and add them to
			// the list box.
			string[] haks = Directory.GetFiles(NWNInfo.GetPathForFile("foo.hif"), "*.hif");
			foreach (string hak in haks)
			{
				// Load the HIF now and perform validation before adding it to the
				// list of HIFs.
				HakInfo hif = new HakInfo(hak);
				string error;
				if (hif.Validate(out error))
					checkedHaks.Items.Add(hif);
				else
					MessageBox.Show(error, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
			}

			if (0 == checkedHaks.Items.Count)
			{
				MessageBox.Show(StringResources.GetString("NoHIFS"), "Error", MessageBoxButtons.OK,
					MessageBoxIcon.Error);
				Close();
				Hide();
				Application.Exit();
			}
		}

		/// <summary>
		/// Loads all of the modules in the NWN modules directory into the module
		/// check list box.
		/// </summary>
		protected void LoadModuleList(CheckedListBox checkedModules)
		{
			// Turn sorting on so all of the user modules get added alphabetically
			checkedModules.Sorted = true;

			// Get all of the modules in the module directory and add them to
			// the list box.
			string[] modules = Directory.GetFiles(NWNInfo.ModulesPath, "*.mod");
			foreach (string module in modules)
			{
				checkedModules.Items.Add(new Module(Path.GetFileName(module)));
			}

			// Turn off sorting so we can add the OC/XP1/XP2 at the top.
			checkedModules.Sorted = false;

			// Add the OC/XP1/XP2 modules if appropriate.
			if (NWNInfo.IsXP2ModsInstalled)
				checkedModules.Items.Insert(0, new Module(StringResources.GetString("XP2Name"), NWNInfo.XP2Modules));
			if (NWNInfo.IsXP1ModsInstalled)
				checkedModules.Items.Insert(0, new Module(StringResources.GetString("XP1Name"), NWNInfo.XP1Modules));
			if (NWNInfo.IsOCModsInstalled) 
				checkedModules.Items.Insert(0, new Module(StringResources.GetString("OCName"), NWNInfo.OCModules));
		}

		/// <summary>
		/// Checks the modules to see if any of the specified hifs are installed already,
		/// if they are it prompts the user to see if we should continue.
		/// </summary>
		/// <param name="hifs">The list of hifs</param>
		/// <param name="modules">The list of modules</param>
		/// <returns>True if the user cancels the operation, false if they do not</returns>
		protected bool CheckForHifConflicts(HakInfo[] hifs, string[] modules)
		{
			// Get the list of conflicts if there aren't any then just return false.
			HifConflictCollection conflicts = HakInstaller.CheckInstalledHifs(hifs, modules);
			if (null == conflicts) return false;

			// There are conflicts, prompt the user for what to do.
			HifConflictsForm form = new HifConflictsForm(conflicts);
			return DialogResult.Cancel == form.ShowDialog(this);
		}

		private void InitializeComponent()
		{
			// 
			// InstallFormBase
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(292, 266);
			this.Name = "InstallFormBase";
			this.Load += new System.EventHandler(this.InstallFormBase_Load);

		}

		/// <summary>
		/// Handler for the install button click event.  It installs the selected
		/// haks in the selected modules.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		public void PerformInstall(HakInfo[] hifs, string[] modules)
		{
			try
			{
				// Before starting check for hif conflicts and ask the user if they really want to
				// continue.
				if (CheckForHifConflicts(hifs, modules)) return;

				// Create a progress control, 
				InstallProgressForm progress = new InstallProgressForm();
				ThreadPool.QueueUserWorkItem(new WaitCallback(DoHakInstall),
					new InstallInfo(hifs, modules, progress));
				progress.ShowDialog(this);
			}
			finally
			{
			}
		}
		#endregion

		#region private nested classes
		private class InstallInfo
		{
			#region public properties/methods
			/// <summary>
			/// Gets the list of haks to add.
			/// </summary>
			public HakInfo[] Hifs { get { return hifs; } }

			/// <summary>
			/// Gets the list of modules to add haks to.
			/// </summary>
			public string[] Modules { get { return modules; } }

			/// <summary>
			/// Gets the object used to display progress information.
			/// </summary>
			public InstallProgressForm Progress { get { return progress; } }

			/// <summary>
			/// Class constructor
			/// </summary>
			/// <param name="hifs">The list of haks to add</param>
			/// <param name="modules">The list of modules to add haks to</param>
			/// <param name="progress">The object used to show progress</param>
			public InstallInfo(HakInfo[] hifs, string[]modules, 
				InstallProgressForm progress)
			{
				this.hifs = hifs;
				this.modules = modules;
				this.progress = progress;
			}
			#endregion

			#region private fields/properties/methods
			private InstallProgressForm progress;
			private HakInfo[] hifs;
			private string[] modules;
			#endregion
		}
		#endregion

		#region private fields/properties/methods
		private SystemMenu systemMenu;

		/// <summary>
		/// This function performs the install of the haks into the modules.  It is
		/// intended to be called in a background thread using the thread pool, allowing
		/// a progress dialog to be displayed to the user while the work is being done.
		/// </summary>
		/// <param name="o">InstallInfo object containing the install data.</param>
		protected void DoHakInstall(object o)
		{
			// Force the thread to use the invariant culture to make the install
			// code work on foreign language versions of windows.
			Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture;

			// Do the hak install and when we're done close the progress form.
			InstallInfo info = (InstallInfo) o;
			try
			{
				// The OC/XP1/XP2 files can be marked as read only, so we have to undo that
				// for all modules in the list.
				foreach (string module in info.Modules)
				{
					string file = NWNInfo.GetFullFilePath(module);
					FileAttributes attrs = File.GetAttributes(file);
					attrs &= ~FileAttributes.ReadOnly;
					File.SetAttributes(file, attrs);
				}

				HakInstaller.InstallHaks(info.Hifs, info.Modules, info.Progress);
			}
			catch(Exception e)
			{
				MessageBox.Show(info.Progress, e.Message, "Error", 
					MessageBoxButtons.OK, MessageBoxIcon.Error);
			}
			finally
			{
				info.Progress.Close();

				// Reset any .nwm files back to read only to leave them as we found them,
				// in case the engine wants them marked read only.
				foreach (string module in info.Modules)
				{
					if (0 == string.Compare(".nwm", Path.GetExtension(module), true, CultureInfo.InvariantCulture))
					{
						string file = NWNInfo.GetFullFilePath(module);
						FileAttributes attrs = File.GetAttributes(file);
						attrs |= FileAttributes.ReadOnly;
						File.SetAttributes(file, attrs);
					}
				}
			}
		}
		#endregion

		#region menu handlers
		/// <summary>
		/// Event handler for the system menu About menu item.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="args"></param>
		private void OnAbout(object sender, EventArgs args)
		{
			AboutForm form = new AboutForm();
			form.ShowDialog(this);
		}
		#endregion

		#region form event handlers
		/// <summary>
		/// Event handler for the forms' load event, it wires up our system menu items.  Doing
		/// these in the constructor breaks CenterWindow.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void InstallFormBase_Load(object sender, System.EventArgs e)
		{
			systemMenu = new SystemMenu(this);

			SystemMenuItem item = new SystemMenuItem("-", systemMenu);
			systemMenu.Add(item);

			item = new SystemMenuItem("&About", systemMenu);
			item.Click += new EventHandler(OnAbout);
			systemMenu.Add(item);
		}
		#endregion
	}


	/// <summary>
	/// This object defines a 'module' that is displayed in the right checked list box in
	/// the form.  For most modules it refers to a single module, but for the bioware modules
	/// it refers to a group of modules.
	/// </summary>
	public class Module
	{
		#region public properties/methods
		/// <summary>
		/// Gets the name of the module object, this is the text that should be
		/// displayed to the user.
		/// </summary>
		public string Name { get { return name; } }

		/// <summary>
		/// Gets the list of modules that make up this module object.
		/// </summary>
		public string[] Modules { get { return modules; } }

		/// <summary>
		/// Constructor to create a module object for a single module on disk.
		/// </summary>
		/// <param name="module">The module</param>
		public Module(string module)
		{
			name = Path.GetFileNameWithoutExtension(module);
			modules = new string[] { module };
		}

		/// <summary>
		/// Constructor to create a module object for a collection of modules
		/// </summary>
		/// <param name="name">The display name for the collection</param>
		/// <param name="modules">The list of modules.</param>
		public Module(string name, string[] modules)
		{
			this.name = name;
			this.modules = modules;
		}

		/// <summary>
		/// Override of ToString() to use the Name property.
		/// </summary>
		/// <returns></returns>
		public override string ToString() { return Name; }
		#endregion

		#region private fields/properties/methods
		string name;
		private string[] modules;
		#endregion
	}
}
