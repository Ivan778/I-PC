using System;
using System.Windows.Forms;

namespace DeviceManager
{
    public partial class DeviceManager : Form
    {
        public DeviceManager()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            foreach (var item in WmiManager.Devices)
            {
                var cdf = item["Name"];
                listBox1.Items.Add(cdf != null ? $"{listBox1.Items.Count}) {cdf}" : $"{listBox1.Items.Count}) ");
                listBox1.Items.ins
            }
        }
    }
}