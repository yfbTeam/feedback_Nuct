using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class CourseRoomCompare : EqualityComparer<CourseRoom>
    {
       public override bool Equals(CourseRoom x, CourseRoom y)
        {
            return x.Coures_Id == y.Coures_Id && x.StudySection_Id == y.StudySection_Id;
        }
       public override int GetHashCode(CourseRoom obj)
        {
            return obj.Coures_Id.GetHashCode();
        }
    }

    
}
