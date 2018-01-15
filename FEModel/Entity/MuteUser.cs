using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class MuteUser
    {
        public string UserName { get; set; }

        public string RoleName { get; set; }

        public int? RoleID { get; set; }
    }

    public class MuteUserComparer : EqualityComparer<MuteUser>
    {
        public override bool Equals(MuteUser x, MuteUser y)
        {
            return x.UserName == y.UserName;
        }
        public override int GetHashCode(MuteUser obj)
        {
            return obj.UserName.GetHashCode();
        }
    }
}
