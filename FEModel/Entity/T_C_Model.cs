using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class T_C_Model
    {

        public string Teacher_Name { get; set; }

        public string UniqueNo { get; set; }

        public string Department_Name { get; set; }

        public string Department_UniqueNo { get; set; }

        List<T_C_Model_Child> t_C_Model_Childs = new List<T_C_Model_Child>();

        public List<T_C_Model_Child> T_C_Model_Childs
        {
            get { return t_C_Model_Childs; }
            set { t_C_Model_Childs = value; }
        }
    }

    public class T_C_Model_Child
    {
        public bool result { get; set; }
        public string Course_Name { get; set; }
        public string Course_UniqueNo { get; set; }

        public string TeacherUID { get; set; }

        public bool Selected { get; set; }

        public string SelectedExperUID { get; set; }

        public string SelectedExperName { get; set; }
    }

    public class T_C_Model_ChildComparer : EqualityComparer<T_C_Model_Child>
    {
        public override bool Equals(T_C_Model_Child x, T_C_Model_Child y)
        {
            return x.Course_UniqueNo == y.Course_UniqueNo && x.TeacherUID == y.TeacherUID;
        }
        public override int GetHashCode(T_C_Model_Child obj)
        {
            return obj.TeacherUID.GetHashCode();
        }
    }
}
