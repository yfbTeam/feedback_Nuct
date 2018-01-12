using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{

    public class Sys_RoleOfUserComparer : EqualityComparer<Sys_RoleOfUser>
    {
        public override bool Equals(Sys_RoleOfUser x, Sys_RoleOfUser y)
        {
            return x.UniqueNo == y.UniqueNo;
        }
        public override int GetHashCode(Sys_RoleOfUser obj)
        {
            return obj.UniqueNo.GetHashCode();
        }
    }
}
