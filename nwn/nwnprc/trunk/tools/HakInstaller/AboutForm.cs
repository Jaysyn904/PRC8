using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Reflection;
using System.Windows.Forms;
using HakInstaller.Utilities;

namespace HakInstaller
{
	/// <summary>
	/// Summary description for AboutForm.
	/// </summary>
	public class AboutForm : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.Label labelCaption;
		private System.Windows.Forms.PictureBox pictureBox;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public AboutForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			string name = Path.GetFileNameWithoutExtension(Assembly.GetExecutingAssembly().Location);
			this.Text += name;

			string version = Assembly.GetExecutingAssembly().GetName().Version.ToString();
			labelCaption.Text = string.Format(labelCaption.Text, version);

			Icon icon = new Icon(typeof(AboutForm), "HakInstaller.ico");
			icon = new Icon(icon, 32, 32);
			pictureBox.Image = icon.ToBitmap();
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if(components != null)
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.labelCaption = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.button1 = new System.Windows.Forms.Button();
			this.pictureBox = new System.Windows.Forms.PictureBox();
			this.SuspendLayout();
			// 
			// labelCaption
			// 
			this.labelCaption.Location = new System.Drawing.Point(96, 16);
			this.labelCaption.Name = "labelCaption";
			this.labelCaption.Size = new System.Drawing.Size(256, 32);
			this.labelCaption.TabIndex = 0;
			this.labelCaption.Text = "HakInstaller {0} - Installs custom content in NWN modules";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(96, 56);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(256, 16);
			this.label2.TabIndex = 0;
			this.label2.Text = "(C) 2004 Bleedingedge (Mark Sironi)";
			// 
			// button1
			// 
			this.button1.DialogResult = System.Windows.Forms.DialogResult.OK;
			this.button1.FlatStyle = System.Windows.Forms.FlatStyle.System;
			this.button1.Location = new System.Drawing.Point(16, 88);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(72, 24);
			this.button1.TabIndex = 5;
			this.button1.Text = "&OK";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// pictureBox
			// 
			this.pictureBox.Location = new System.Drawing.Point(24, 16);
			this.pictureBox.Name = "pictureBox";
			this.pictureBox.Size = new System.Drawing.Size(32, 32);
			this.pictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
			this.pictureBox.TabIndex = 6;
			this.pictureBox.TabStop = false;
			// 
			// AboutForm
			// 
			this.AcceptButton = this.button1;
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(360, 128);
			this.ControlBox = false;
			this.Controls.Add(this.pictureBox);
			this.Controls.Add(this.button1);
			this.Controls.Add(this.labelCaption);
			this.Controls.Add(this.label2);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Name = "AboutForm";
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
			this.Text = "About ";
			this.ResumeLayout(false);

		}
		#endregion

		private void button1_Click(object sender, System.EventArgs e)
		{
		}

	}
}
