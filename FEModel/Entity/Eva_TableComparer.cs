using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class Eva_TableComparer : EqualityComparer<Eva_Table>
    {
        public override bool Equals(Eva_Table x, Eva_Table y)
        {
            return x.Id == y.Id;
        }
        public override int GetHashCode(Eva_Table obj)
        {
            return obj.Id.GetHashCode();
        }
    }
}
