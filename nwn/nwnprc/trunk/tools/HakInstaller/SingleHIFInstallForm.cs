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
	/// This is the main form of the HakInstaller application.
	/// </summary>
	public class SingleHIFInstallForm : InstallFormBase
	{
		#region public methods/properties.
		/// <summary>
		/// Class constructor
		/// </summary>
		public SingleHIFInstallForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			SetLabels(labelVersion, labelPath);

			// Validate our HIF to make sure we can really install.
			ValidateHIF();

			// Save the HIF title as the title for our form.
			Text = StringResources.GetString("SingleHIFTitle", hif.Title, 
				hif.VersionText);
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
		private System.Windows.Forms.Button buttonInstall;
		private System.Windows.Forms.Button buttonCancel;
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
			System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(SingleHIFInstallForm));
			this.labelVersion = new System.Windows.Forms.Label();
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
			// buttonInstall
			// 
			this.buttonInstall.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.buttonInstall.Enabled = false;
			this.buttonInstall.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonInstall.Location = new System.Drawing.Point(24, 280);
			this.buttonInstall.Name = "buttonInstall";
			this.buttonInstall.Size = new System.Drawing.Size(64, 24);
			this.buttonInstall.TabIndex = 6;
			this.buttonInstall.Text = "&Install";
			this.buttonInstall.Click += new System.EventHandler(this.buttonInstall_Click);
			// 
			// buttonCancel
			// 
			this.buttonCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.buttonCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.buttonCancel.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.buttonCancel.Location = new System.Drawing.Point(104, 280);
			this.buttonCancel.Name = "buttonCancel";
			this.buttonCancel.Size = new System.Drawing.Size(64, 24);
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
			this.checkedModules.Location = new System.Drawing.Point(24, 96);
			this.checkedModules.Name = "checkedModules";
			this.checkedModules.Size = new System.Drawing.Size(320, 169);
			this.checkedModules.Sorted = true;
			this.checkedModules.TabIndex = 5;
			this.checkedModules.ThreeDCheckBoxes = true;
			this.checkedModules.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.checkedModules_ItemCheck);
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(24, 72);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(328, 16);
			this.label2.TabIndex = 4;
			this.label2.Text = "Select the &modules you want to update to use the PRC pack:";
			// 
			// labelPath
			// 
			this.labelPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
				| System.Windows.Forms.AnchorStyles.Right)));
			this.labelPath.Location = new System.Drawing.Point(24, 32);
			this.labelPath.Name = "labelPath";
			this.labelPath.Size = new System.Drawing.Size(320, 16);
			this.labelPath.TabIndex = 1;
			// 
			// SingleHIFInstallForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.CancelButton = this.buttonCancel;
			this.ClientSize = new System.Drawing.Size(368, 318);
			this.Controls.Add(this.labelPath);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.checkedModules);
			this.Controls.Add(this.buttonInstall);
			this.Controls.Add(this.labelVersion);
			this.Controls.Add(this.buttonCancel);
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MinimumSize = new System.Drawing.Size(376, 352);
			this.Name = "SingleHIFInstallForm";
			this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Show;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "title goes here";
			this.SizeChanged += new System.EventHandler(this.InstallForm_SizeChanged);
			this.Load += new System.EventHandler(this.InstallForm_Load);
			this.ResumeLayout(false);

		}
		#endregion

		#region private fields/properties/methods
		private HakInfo hif;

		/// <summary>
		/// Validates the single HIF and throws an EntryPointNotFoundException
		/// to exit the application if it does not validate.
		/// </summary>
		private void ValidateHIF()
		{
			hif = new HakInfo(NWNInfo.GetFullFilePath(MainForm.Hif));
		
			// Validate the PRC pack HIF, if validation fails then display
			// the error message and exit the app.
			string error;
			if (!hif.Validate(out error))
			{
				MessageBox.Show(error, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
				throw new EntryPointNotFoundException();
			}
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
			LoadModuleList(checkedModules);
		}

		private void InstallForm_SizeChanged(object sender, System.EventArgs e)
		{
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

			buttonInstall.Enabled = fModuleChecked;
		}

		/// <summary>
		/// Handler for the install button click event.  It installs the selected
		/// haks in the selected modules.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void buttonInstall_Click(object sender, System.EventArgs e)
		{
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

			PerformInstall(new HakInfo[1] { hif }, modules);

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
