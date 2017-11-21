using System.Collections.Generic;
using System.Linq;
using System.Management;

namespace DeviceManager
{
    public class GetAllDevicesInfo
    {
        public static List<DeviceInfo> Devices
        {
            get
            {
                var devices = WmiManager.Devices;
                var devs = new List<DeviceInfo>();

                foreach (var o in devices)
                {
                    if (o["PNPClass"] == null)
                    {
                        continue;
                    }
                    var device = (ManagementObject) o;
                    var driver = device.GetRelated("Win32_SystemDriver");


                    if (driver.Count != 0)
                    {
                        devs.Add(new DeviceInfo(device, driver.OfType<ManagementObject>().FirstOrDefault()));
                        continue;
                    } 
                    devs.Add(new DeviceInfo(device, null));
                }

                return devs;
            }
        }
    }
}