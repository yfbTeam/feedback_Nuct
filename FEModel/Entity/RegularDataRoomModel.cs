using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FEModel.Entity
{
    public class RegularDataRoomModel
    {

        public int? Id { get; set; }

        public string TeacherName { get; set; }

        public string TeacherUID { get; set; }

        public int Num { get; set; }





        public int? SectionID { get; set; }

        public string DisPlayName { get; set; }

        public int? ReguID { get; set; }

        public string ReguName { get; set; }

        public string CourseID { get; set; }

        public string CourseName { get; set; }

        public string DepartmentID { get; set; }

        public string RoomDepartmentName { get; set; }

        public string GradeName { get; set; }

        public string ClassName { get; set; }

        public int? StudentCount { get; set; }

        public int QuestionCount { get; set; }

        public decimal QuestionAve { get; set; }

        public decimal ScoreAve { get; set; }

        public int? TableID { get; set; }

        public bool IsAnswer { get; set; }

        public DateTime? CreateTime { get; set; }

        public int? RoomID { get; set; }

        public DateTime? EndTime { get; set; }

        public DateTime? StartTime { get; set; }

        public bool IsOverTime { get; set; }

        public string ClassID { get; set; }

        public string State { get; set; }

        public int StateType { get; set; }
    }
}
