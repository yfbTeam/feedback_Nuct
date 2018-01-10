using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class RegularDataModel
    {

        public int? Id { get; set; }

        public string TeacherName { get; set; }

        public string TeacherUID { get; set; }

        public string ExpertName { get; set; }

        public string ExpertUID { get; set; }

        public string Course_Name { get; set; }

        public string CourseID { get; set; }

        public string Departent_Name { get; set; }

        public string ReguName { get; set; }

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public string State { get; set; }

        public int StateType { get; set; }

        public byte? LookType { get; set; }

        public int? ReguId { get; set; }

        public string DisPlayName { get; set; }

        public int? SectionID { get; set; }

        public int AnswerCount { get; set; }

        public int Num { get; set; }
    }
}
