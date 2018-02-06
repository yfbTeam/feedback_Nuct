using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
   public class CCModel
    {
        public string ClassID { get; set; }

        public string CourseID { get; set; }

        public string ClassName { get; set; }

        public string Course_Name { get; set; }

        public string Id { get; set; }
    }

   public class CCModelComparer : EqualityComparer<CCModel>
   {
       public override bool Equals(CCModel x, CCModel y)
       {
           return x.ClassID == y.ClassID&& x.CourseID == y.CourseID;
       }
       public override int GetHashCode(CCModel obj)
       {
           return obj.ClassID.GetHashCode();
       }
   }
}
