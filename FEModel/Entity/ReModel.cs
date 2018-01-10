using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class ReModel
    {

        public string ReguName { get; set; }

        public int? ReguId { get; set; }
    }

    public class ReModelComparer : EqualityComparer<ReModel>
    {
        public override bool Equals(ReModel x, ReModel y)
        {
            return x.ReguId == y.ReguId;
        }
        public override int GetHashCode(ReModel obj)
        {
            return obj.ReguId.GetHashCode();
        }
    }
}
