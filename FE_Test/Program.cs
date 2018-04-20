using ConferenceCommon.ProcessHelper;
using FEHandler;
using FEHandler.Eva_Manage;
using FEHandler.SetMenu;
using FEHandler.SysClass;
using FEHandler.UserMan;
using FEModel;
using FEModel.Enum;
using FEUtility;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FE_Test
{
    class Program
    {
        static void Main(string[] args)
        {
            //helper. Init_Course();
            //var t = File.ReadAllLines(@"E:\vs_work2\FE_Test\TextFile1.txt");
            //var ksp = Eva_ManageHandler.Teacher_Course_ClassInfo();
            //var s = Constant.Indicator_List;
            //var d = Constant.IndicatorType_List;

            //CourseInfoHandler.GetCourseInfo_SelectHelper(1, "0");
            //Eva_ManageHandler.Get_Eva_TableHelper(1, "");

            //Eva_ManageHandler.Get_Backlog_Helper("12101020111");

            //Eva_ManageHandler.Get_Eva_RegularHelper(1, 2);
            //Eva_ManageHandler.Get_Eva_RegularData_RoomDetailList_Helper(1, 25, 2209, "001265", "7121001", 2, 1);


            //ProcessManage.KillProcess("w3wp");

            Eva_ManageHandler.Get_Eva_RegularData_Helper(0, 10, 3, 0, "", "0196", "", "", 1, FuncType.getcount,1);

            //var jsm = SetMenuHandler.TestGetMenuInfoHelper("3", "");

            //var s = Split_Hepler.ints_to_string(new List<int>() { 1, 3, 4 });
            //Eva_ManageHandler.Get_Eva_QuestionAnswer_Helper(0, 100, 1, "", "", 0, "", IsAllSchool.School, FEModel.Enum.ModeType.Check, true, true, true);
            //Eva_ManageHandler.Get_Eva_TableHelper(1, "", 1, "001414");

            foreach (var item in Constant.Teacher_List)
            {
                var count = Constant.Sys_RoleOfUser_List.Count(i => i.Role_Id == 3 && i.UniqueNo == item.UniqueNo);
                if (count == 0)
                {
                    Constant.Sys_RoleOfUserService.Add(new Sys_RoleOfUser()
                    {
                        UniqueNo = item.UniqueNo,
                        Role_Id = 3,
                        IsDelete = 0,
                        CreateTime = DateTime.Now,
                        EditTime = DateTime.Now,
                        CreateUID = "",
                        EditUID = "",
                    });
                }

            }
        }


    }
}


public class helper
{
    public static void Init_()
    {
        //foreach (var item in t)
        //{
        //    var a = item.Split('\t');


        //    var student = Constant.Student_List.FirstOrDefault(i => i.UniqueNo == a[4]);
        //    if (student != null)
        //    {
        //        student.Name = a[5];
        //        student.Major_Id = a[0];
        //        student.Departent_Name = a[1];
        //        student.SubDepartmentID = a[9];
        //        student.SubDepartmentName = a[10];
        //        student.MajorID = a[7];
        //        student.MajorName = a[8];
        //        student.Sex = a[6] == "男" ? (byte)0 : (byte)1;
        //        student.ClassNo = a[2];
        //        student.ClassName = a[3];
        //        Constant.StudentService.Update(student);
        //    }
        //    else
        //    {
        //        Student Student = new Student()
        //        {
        //            Name = a[5],
        //            Major_Id = a[0],
        //            Departent_Name = a[1],
        //            SubDepartmentID = a[9],
        //            SubDepartmentName = a[10],
        //            MajorID = a[7],
        //            MajorName = a[8],
        //            Sex = a[6] == "男" ? (byte)0 : (byte)1,
        //            ClassNo = a[2],
        //            ClassName = a[3],
        //            CreateTime = DateTime.Now,
        //            CreateUID = "admin",
        //            EditTime = DateTime.Now,
        //            EditUID = "admin",
        //            IsDelete = 0,
        //            IsEnable = 0,
        //            StuNo = a[4],
        //            UniqueNo = a[4],

        //        };
        //        Constant.StudentService.Add(Student);
        //    }
        //}
    }

    public static void Init_T()
    {
        //foreach (var item in t)
        //{
        //    var a = item.Split('\t');


        //    var teacher = Constant.Teacher_List.FirstOrDefault(i => i.UniqueNo == a[4]);
        //    if (teacher != null)
        //    {
        //        teacher.Name = a[5];
        //        teacher.Status = a[7];
        //        teacher.SubDepartmentID = a[2];
        //        teacher.SubDepartmentName = a[3];
        //        Constant.TeacherService.Update(teacher);
        //    }
        //    else
        //    {
        //        int b = 0;
        //    }
        //}
    }

    public static void Init_S()
    {
        //foreach (var item in t)
        //{
        //    var a = item.Split('\t');

        //    var major = Constant.Major_List.FirstOrDefault(i => i.Major_Name == a[28]);
        //    var submajor = Constant.SubMajor_List.FirstOrDefault(i => i.Major_Name == a[29]);

        //    var course = Constant.CourseRoom_List.FirstOrDefault(i => i.Name == a[2] && i.TeacherUID == a[25] && i.Coures_Id == a[23] && i.Calss_Id == a[24]);
        //    if (course != null)
        //    {
        //        course.Year = Convert.ToInt32(a[0]);
        //        course.Season = a[1];
        //        course.Name = a[2];
        //        course.Name = a[3];
        //        course.GradeName = a[4];
        //        course.RoomDepartmentID = a[5];

        //        course.CourseProperty = a[27];
        //        course.CourseType = a[26];
        //        course.Major_Id = major != null ? major.Id : "";
        //        course.DepartmentName = major != null ? major.Major_Name : "";
        //        course.SubDepartmentID = submajor != null ? submajor.Id : "";
        //        course.SubDepartmentName = submajor != null ? submajor.Major_Name : "";
        //        course.TeacherName = a[6];
        //        course.TeacherProperty = a[8];
        //        course.TeacherPropertyID = a[7];
        //        course.TeacherDepartmentID = a[30];
        //        course.TeacherJobTitle = a[33];
        //        course.TeacherSubDepartmentID = a[31];
        //        course.StudentCount = Convert.ToInt32(a[32]);

        //        Constant.CourseRoomService.Update(course);
        //    }
        //    else
        //    {
        //        int b = 0;
        //    }
        //}
    }

    public static void Init_SubMajor()
    {
        //foreach (var item in t)
        //{
        //    var a = item.Split('\t');

        //    var submajor = Constant.SubMajor_List.FirstOrDefault(i => i.Id == a[2]);
        //    if (submajor != null)
        //    {
        //        //submajor.PID = a[0];
        //        //submajor.PName = a[1];
        //        //submajor.Id = a[2];
        //        //submajor.Major_Name = a[3];                
        //        //Constant.SubMajorService.Update(submajor);
        //    }
        //    else
        //    {
        //        Constant.SubMajorService.Add_IncludeId(new FEModel.SubMajor()
        //        {
        //            PID = a[0] == "null" ? "" : a[0],
        //            PName = a[1] == "null" ? "" : a[1],
        //            Id = a[2] == "null" ? "" : a[2],
        //            Major_Name = a[3] == "null" ? "" : a[3],
        //            CreateTime = DateTime.Now,
        //            EditTime = DateTime.Now,
        //            CreateUID = "admin",
        //            IsDelete = 0,
        //            EditUID = "admin",
        //        });
        //    }
        //}
    }

    public static void Init_Course()
    {
        var t = File.ReadAllLines(@"E:\vs_work2\FE_Test\TextFile1.txt");
        foreach (var item in t)
        {
            var a = item.Split('\t');

            var course = Constant.Course_List.FirstOrDefault(i => i.UniqueNo == a[4]);
            if (course != null)
            {
                course.DepartMentID = a[0];
                course.DepartmentName = a[1];
                course.SubDepartmentID = a[2];
                course.SubDepartmentName = a[3];
                course.PkType = a[6];
                course.CourseProperty = a[7];
                course.TaskProperty = a[13];
                Constant.CourseService.Update(course);
            }
            else
            {
                int b = 0;
            }
        }
    }


    #region sysrole

    public static void SysRole()
    {
        //foreach (var item in Constant.Student_List)
        //{
        //    var data = Constant.Sys_RoleOfUser_List.FirstOrDefault(i => i.UniqueNo == item.UniqueNo);
        //    if(data == null)
        //    {
        //        Constant.Sys_RoleOfUserService.Add(new Sys_RoleOfUser() { UniqueNo =item.UniqueNo, CreateTime =DateTime.Now,EditTime =DateTime.Now, CreateUID="",EditUID="", IsDelete =0, Role_Id=2 });
        //    }
        //}

        foreach (var item in Constant.Student_List)
        {
            var user = Constant.UserInfo_List.FirstOrDefault(h => h.UniqueNo == item.UniqueNo);
            if (user == null)
            {
                Constant.UserInfoService.Add(new UserInfo()
                {
                    UniqueNo = item.UniqueNo,
                    Name = item.Name,
                    Address = "",
                    Birthday = DateTime.Now,
                    ClearPassword = "123456",
                    Email = "",
                    HeadPic = "",
                    IDCard = "",
                    IsEnable = 0,
                    LoginName = item.UniqueNo,
                    Major_ID = item.DepartmentID,
                    Nickname = "",
                    Password = "123456",
                    Phone = "",
                    Pic = "",
                    Remarks = "",
                    Sex = 0,
                    UserType = 2,

                    CreateTime = DateTime.Now,
                    EditTime = DateTime.Now,
                    CreateUID = "",
                    EditUID = "",
                    IsDelete = 0,
                });
            }
        }
    }

    #endregion

    #region department

    public static void departemt()
    {
        var data = (from stu in Constant.Student_List
                    join user in Constant.UserInfo_List on stu.UniqueNo equals user.UniqueNo
                    select new { stu, user }).ToList();

        var data2 = (from tea in Constant.Teacher_List
                     join user in Constant.UserInfo_List on tea.UniqueNo equals user.UniqueNo
                     select new { tea, user }).ToList();


        foreach (var item in data)
        {
            item.user.Major_ID = item.stu.DepartmentID;
            item.user.DepartmentName = item.stu.DepartmentName;
            item.user.SubDepartmentID = item.stu.SubDepartmentID;
            item.user.SubDepartmentName = item.stu.SubDepartmentName;

            Constant.UserInfoService.Update(item.user);
        }

        foreach (var item in data2)
        {
            item.user.Major_ID = item.tea.DepartmentID;
            item.user.DepartmentName = item.tea.DepartmentName;
            item.user.SubDepartmentID = item.tea.SubDepartmentID;
            item.user.SubDepartmentName = item.tea.SubDepartmentName;

            Constant.UserInfoService.Update(item.user);
        }
    }

    #endregion

    #region room

    public static void room()
    {
        //foreach (var item in Constant.CourseRoom_List)
        //{
        //    var course = Constant.Course_List.FirstOrDefault(i => i.UniqueNo == item.Coures_Id);
        //    if(course != null)
        //    {
        //        item.CouresName = course.Name;
        //        Constant.CourseRoomService.Update(item);
        //    }
        //}

    }

    #endregion

    #region cls\

    public static void Cls()
    {
        //按80数量进行分组
        var result = ListHelper.GetListGroup<Student>(Constant.Student_List, 15);

        for (int i = 0; i < result.Count; i++)
        {
            for (int j = 0; j < result[i].Count; j++)
            {
                var model = result[i][j];
                var cls = Constant.ClassInfo_List[i];
                Constant.Class_StudentInfoService.Add(new Class_StudentInfo() { UniqueNo = model.UniqueNo, Class_Id = cls.ClassNO, CreateTime = DateTime.Now, CreateUID = "admin", EditTime = DateTime.Now, EditUID = "", IsDelete = 0 });
            }

        }
    }

    #endregion
}