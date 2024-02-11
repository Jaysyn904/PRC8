using System;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Threading;
using System.Windows.Forms;
using HakInstaller.Utilities;
using NWN;

namespace HakInstaller
{
	/// <summary>
	/// This is the main form of the HakInstaller application.
	/// </summary>
	public class InstallForm : InstallFormBase
	{
		#region public methods/properties.
		/// <summary>
		/// Class constructor
		/// </summary>
		public InstallForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			// Add the major/minor version number to the caption, full version
			// number is available in the about box.
			Version version = Assembly.GetExecutingAssembly().GetName().Version;
			string versionText = string.Format("{0}.{1}", version.Major, version.Minor);
			Text = string.Format(Text, versionText);

			SetLabels(labelVersion, labelPath);
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}
		#endregion

		#region Windows Form Designer generated code
		private System.Windows.Forms.Label labelVersion;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Button buttonInstall;
		private System.Windows.Forms.Button buttonCancel;
		private System.Windows.Forms.CheckedListBox checkedHaks;
		private System.Windows.Forms.CheckedListBox checkedModules;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label labelPath;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(InstallForm));
			this.labelVersion = new System.Windows.Forms.Label();
			this.checkedHaks = new System.Windows.Forms.CheckedListBox();
			this.label1 = new System.Windows.Forms.Label();
			this.buttonInstall = new System.Windows.Forms.Button();
			this.buttonCancel = new System.Windows.Forms.Button();
			this.checkedModules = new System.Windows.Forms.CheckedListBox();
			this.label2 = new System.Windows.Forms.Label();
			this.labelPath = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// labelVersion
			// 
			this.labelVersion.Location = new System.Drawing.Point(24, 8);
			this.labelVersion.Name = "labelVersion";
			this.labelVersion.Size = new System.Drawing.Size(240, 16);
			this.labelVersion.TabIndex = 0;
			// 
			// checkedHaks
			// 
			this.checkedHaks.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left)));
			this.checkedHaks.CheckOnClick = true;
			this.checkedHaks.Location = new System.Drawing.Point(24, 96);
			this.checkedHaks.Name = "checkedHaks";
			this.checkedHaks.Size = new System.Drawing.Size(248, 169);
			this.checkedHaks.Sorted = true;
			this.checkedHaks.TabIndex = 3;
			this.checkedHaks.ThreeDCheckBoxes = true;
			this.checkedHaks.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.checkedHaks_ItemCheck);
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(24, 72);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(248, 16);
			this.label1.TabIndex = 2;
			this.label1.Text = "Select the con&tent you would like to install:";
			// 
			// buttonInstall
			// 
			this.buttonInstall.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.buttonInstall.Enabled = false;
			this.buttonInstall.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonInstall.Location = new System.Drawing.Point(24, 280);
			this.buttonInstall.Name = "buttonInstall";
			this.buttonInstall.Size = new System.Drawing.Size(72, 24);
			this.buttonInstall.TabIndex = 6;
			this.buttonInstall.Text = "&Install";
			this.buttonInstall.Click += new System.EventHandler(this.buttonInstall_Click);
			// 
			// buttonCancel
			// 
			this.buttonCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.buttonCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.buttonCancel.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonCancel.Location = new System.Drawing.Point(112, 280);
			this.buttonCancel.Name = "buttonCancel";
			this.buttonCancel.Size = new System.Drawing.Size(72, 24);
			this.buttonCancel.TabIndex = 7;
			this.buttonCancel.Text = "&Close";
			this.buttonCancel.Click += new System.EventHandler(this.buttonCancel_Click);
			// 
			// checkedModules
			// 
			this.checkedModules.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
				| System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.checkedModules.CheckOnClick = true;
			this.checkedModules.Location = new System.Drawing.Point(288, 96);
			this.checkedModules.Name = "checkedModules";
			this.checkedModules.Size = new System.Drawing.Size(248, 169);
			this.checkedModules.Sorted = true;
			this.checkedModules.TabIndex = 5;
			this.checkedModules.ThreeDCheckBoxes = true;
			this.checkedModules.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.checkedModules_ItemCheck);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(288, 72);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(248, 16);
			this.label2.TabIndex = 4;
			this.label2.Text = "Select the &modules you want the haks installed in:";
			// 
			// labelPath
			// 
			this.labelPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.labelPath.Location = new System.Drawing.Point(24, 32);
			this.labelPath.Name = "labelPath";
			this.labelPath.Size = new System.Drawing.Size(504, 16);
			this.labelPath.TabIndex = 1;
			// 
			// InstallForm
			// 
			this.AcceptButton = this.buttonInstall;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.buttonCancel;
			this.ClientSize = new System.Drawing.Size(560, 310);
			this.Controls.Add(this.labelPath);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.checkedModules);
			this.Controls.Add(this.buttonInstall);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.checkedHaks);
			this.Controls.Add(this.labelVersion);
			this.Controls.Add(this.buttonCancel);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MinimumSize = new System.Drawing.Size(568, 328);
			this.Name = "InstallForm";
			this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Show;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "NWN Content Installer {0}";
			this.Load += new System.EventHandler(this.InstallForm_Load);
			this.ResumeLayout(false);

		}
		#endregion

		#region form event handlers
		/// <summary>
		/// The form's load event handler.  Fills in the contents of the form and sets
		/// it up.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void InstallForm_Load(object sender, System.EventArgs e)
		{
			// Fill in the check list boxes.
			LoadHakInfoList(checkedHaks);
			LoadModuleList(checkedModules);
		}
		#endregion

		#region control event handlers
		/// <summary>
		/// Event handler for the ItemCheck event on the modules check list box.
		/// It enables/disables the install button depending on whether at least
		/// one module and hak have been selected.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void checkedModules_ItemCheck(object sender, System.Windows.Forms.ItemCheckEventArgs e)
		{
			// The install button should be enabled if at least one module and hak
			// has been selectted.  Note that this event is fired BEFORE the checked
			// state of the item changes so we have to check the event args for
			// it's new state.
			int adjustment = CheckState.Checked == e.NewValue ? 1 : -1;
			bool fModuleChecked = checkedModules.CheckedItems.Count + adjustment > 0;
			bool fHakChecked = checkedHaks.CheckedItems.Count > 0;

			buttonInstall.Enabled = fModuleChecked && fHakChecked;
		}

		/// <summary>
		/// Event handler for the ItemCheck event on the haks check list box.
		/// It enables/disables the install button depending on whether at least
		/// one module and hak have been selected.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void checkedHaks_ItemCheck(object sender, System.Windows.Forms.ItemCheckEventArgs e)
		{
			// We only support checking 1 hak, so uncheck the previously checked hak if we
			// are checking a hak.
			if (CheckState.Checked == e.NewValue && checkedHaks.CheckedIndices.Count > 0) 
				checkedHaks.SetItemChecked(checkedHaks.CheckedIndices[0], false);

			// The install button should be enabled if at least one module and hak
			// has been selectted.  Note that this event is fired BEFORE the checked
			// state of the item changes so we have to check the event args for
			// it's new state.
			int adjustment = CheckState.Checked == e.NewValue ? 1 : -1;
			bool fModuleChecked = checkedModules.CheckedItems.Count > 0;
			bool fHakChecked = checkedHaks.CheckedItems.Count + adjustment > 0;

			buttonInstall.Enabled = fModuleChecked && fHakChecked;
		}

		/// <summary>
		/// Handler for the install button click event.  It installs the selected
		/// haks in the selected modules.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void buttonInstall_Click(object sender, System.EventArgs e)
		{
			// Build an array of the checked hif files.
			HakInfo[] hifs = new HakInfo[checkedHaks.CheckedItems.Count];
			for (int i = 0; i < checkedHaks.CheckedIndices.Count; i++)
				hifs[i] = (HakInfo) checkedHaks.CheckedItems[i];

			// Count the total number of .mod/.nwm files selected.
			int numModules = 0;
			foreach (Module module in checkedModules.CheckedItems)
				numModules += module.Modules.Length;

			// Create the modules list and fill it in.
			string[] modules = new string[numModules];
			numModules = 0;
			foreach (Module module in checkedModules.CheckedItems)
			{
				module.Modules.CopyTo(modules, numModules);
				numModules += module.Modules.Length;
			}

			PerformInstall(hifs, modules);

			// Clear the checked state of all modules.
			CheckedListBox.CheckedIndexCollection checkedIndeces = 
				checkedModules.CheckedIndices;
			foreach (int index in checkedIndeces)
				checkedModules.SetItemChecked(index, false);
		}

		/// <summary>
		/// Cancel button click event, it closes the application.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void buttonCancel_Click(object sender, System.EventArgs e)
		{
			Application.Exit();
		}
		#endregion
	}
}
