using FEBLL;
using FEModel;
using FEUtility;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;

namespace FEHandler.Eva_Manage
{
    partial class Eva_ManageHandler
    {    

        #region  教师-课堂-学生

        /// <summary>
        /// 获取所有当前教师所教学生
        /// </summary>
        public static List<Class_StudentInfo> Get_Students_Common(string TeacherUID, Eva_Task task)
        {
            List<Class_StudentInfo> student_cls_list = null;
            try
            {
                //获取所有当前教师所教学生
                student_cls_list = (from t in Constant.Teacher_List
                                    //指定老师
                                    where t.UniqueNo == TeacherUID
                                    //课堂
                                    join c in Constant.CourseRoom_List on t.UniqueNo equals c.TeacherUID
                                    where task.Class_Id.Contains(c.ClassID)
                                    //班级
                                    join cl in Constant.Class_StudentInfo_List on c.ClassID equals cl.Class_Id
                                    //获取所有学生ID 
                                    select cl).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }

            return student_cls_list;
        }

        public static List<Class_StudentInfo> Get_Students_Common_ByCourse(string TeacherUID, string Course_Id)
        {
            List<Class_StudentInfo> student_cls_list = null;
            try
            {
                //获取所有当前教师所教学生
                student_cls_list = (from t in Constant.Teacher_List
                                    //指定老师
                                    where t.UniqueNo == TeacherUID
                                    //课堂
                                    join c in Constant.CourseRoom_List on t.UniqueNo equals c.TeacherUID
                                    where c.Coures_Id == Course_Id
                                    //班级
                                    join cl in Constant.Class_StudentInfo_List on c.ClassID equals cl.Class_Id
                                    //获取所有学生ID 
                                    select cl).ToList(); ;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }

            return student_cls_list;
        }

        #endregion

        #region  教师-课堂-学生-专业

        /// <summary>
        /// 获取所有当前教师所教学生
        /// </summary>
        public static List<C_T> Get_Students(string TeacherUID)
        {
            List<C_T> student_cls_list = null;
            try
            {
                //获取所有当前教师所教学生
                student_cls_list = (from t in Constant.Teacher_List
                                    //指定老师
                                    where t.UniqueNo == TeacherUID
                                    //课堂
                                    join c in Constant.CourseRoom_List on t.UniqueNo equals c.TeacherUID
                                    //班级
                                    join cs in Constant.ClassInfo_List on c.ClassID equals cs.ClassNO
                                    join cl in Constant.Class_StudentInfo_List on c.ClassID equals cl.Class_Id

                                    join stu in Constant.Student_List on cl.UniqueNo equals stu.UniqueNo
                                    join user in Constant.UserInfo_List on stu.UniqueNo equals user.UniqueNo
                                    join major in Constant.Major_List on t.Major_ID equals major.Id

                                    //获取所有学生ID 
                                    select new C_T()
                                    {
                                        user = user,
                                        major = major,
                                        stu = stu,
                                        cs = cs,
                                    }).ToList();


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }

            return student_cls_list;
        }

        /// <summary>
        /// 获取所有当前教师所教学生【指定班级】
        /// </summary>
        public static List<C_T> Get_Students_ContainsClassInfo(string TeacherUID, Eva_Task task)
        {
            List<C_T> student_cls_list = null;
            try
            {
                //获取所有当前教师所教学生
                student_cls_list = (from t in Constant.Teacher_List
                                    //指定老师
                                    where t.UniqueNo == TeacherUID
                                    //课堂
                                    join c in Constant.CourseRoom_List on t.UniqueNo equals c.TeacherUID
                                    //班级
                                    join cs in Constant.ClassInfo_List on c.ClassID equals cs.ClassNO
                                    where task.Class_Id.Contains(cs.ClassNO)
                                    join cl in Constant.Class_StudentInfo_List on c.ClassID equals cl.Class_Id

                                    join stu in Constant.Student_List on cl.UniqueNo equals stu.UniqueNo
                                    join user in Constant.UserInfo_List on stu.UniqueNo equals user.UniqueNo
                                    join major in Constant.Major_List on t.Major_ID equals major.Id

                                    //获取所有学生ID 
                                    select new C_T()
                                    {
                                        user = user,
                                        major = major,
                                        stu = stu,
                                        cs = cs,
                                    }).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }

            return student_cls_list;
        }

        /// <summary>
        /// 获取所有当前教师所教学生【指定班级】
        /// </summary>
        public static List<C_T> Get_Students_All()
        {
            List<C_T> student_cls_list = null;
            try
            {
                //获取所有当前教师所教学生
                student_cls_list = ( //班级
                                    from cs in Constant.ClassInfo_List
                                    join cl in Constant.Class_StudentInfo_List on cs.ClassNO equals cl.Class_Id
                                    join stu in Constant.Student_List on cl.UniqueNo equals stu.UniqueNo
                                    join user in Constant.UserInfo_List on stu.UniqueNo equals user.UniqueNo
                                    join major in Constant.Major_List on stu.Major_Id equals major.Id

                                    //获取所有学生ID 
                                    select new C_T()
                                    {
                                        user = user,
                                        major = major,
                                        stu = stu,
                                        cs = cs,
                                    }).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }

            return student_cls_list;
        }

        #endregion

        #region 教师--课程

        public static List<teacher_course_Model> Teacher_Course_ByTeacher(string TeacherUID)
        {
            List<teacher_course_Model> teacher_course = null;
            try
            {

                teacher_course = (from teacher in Constant.Teacher_List
                                  where teacher.UniqueNo == TeacherUID
                                  join user in Constant.UserInfo_List on teacher.UniqueNo.Trim() equals user.UniqueNo.Trim()
                                  //课堂                      
                                  join room in Constant.CourseRoom_List.ToList().Distinct(new CourseRoomComparer()) on teacher.UniqueNo.Trim() equals room.TeacherUID.Trim()
                                  //课程
                                  join course in Constant.Course_List on room.Coures_Id.Trim() equals course.UniqueNo.Trim()
                                  join courseref in Constant.CourseRel_List on course.UniqueNo.Trim() equals courseref.Course_Id.Trim()

                                  select new teacher_course_Model()
                                  {
                                      room = room,
                                      course = course,
                                      courseref = courseref,
                                      teacher = teacher,
                                      user = user,
                                  }).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return teacher_course;
        }

        #endregion

        #region 教师-调查与测评   【合班的数据】

        public static List<Ime_Model> Teacher_Task()
        {
            List<Ime_Model> teacher_task = null;
            try
            {
                teacher_task = (from e in Constant.Eva_Task_List
                                where e.IsPublish == (int)IsPublish.Yes
                                join user in Constant.UserInfo_List on e.TeacherUID equals user.UniqueNo
                                select new Ime_Model
                                {
                                    Eva_Task = e,
                                    UserInfo = user,
                                }).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return teacher_task;
        }

        public static List<Ime_Model> Teacher_Task_ByTeacher(string TeacherUID, List<Eva_Task> ts_List)
        {
            List<Ime_Model> teacher_task = null;
            try
            {
                teacher_task = (from e in ts_List
                                where e.TeacherUID == TeacherUID
                                join user in Constant.UserInfo_List on e.TeacherUID equals user.UniqueNo
                                select new Ime_Model
                                {
                                    Eva_Task = e,
                                    UserInfo = user,
                                    answer_percent = 0,
                                    is_answer = Constant.Eva_TaskAnswer_List.Count(i => i.Task_Id == e.Id) > 0 ? true : false
                                }).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return teacher_task;
        }

        public static List<Ime_Model> Teacher_Task_ByTime(string StudentUID)
        {
            List<Ime_Model> teacher_task = null;
            try
            {
                teacher_task = (from e in Constant.Eva_Task_List
                                where e.StartTime != null && e.EndTime != null && (DateTime)e.StartTime < DateTime.Now && (DateTime)e.EndTime > DateTime.Now
                                join user in Constant.UserInfo_List on e.TeacherUID equals user.UniqueNo
                                select new Ime_Model
                                {
                                    Eva_Task = e,
                                    UserInfo = user,
                                    is_answer = Constant.Eva_TaskAnswer_List.Count(i => i.CreateUID == StudentUID && i.Task_Id == e.Table_Id) > 0 ? true : false
                                }).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return teacher_task;
        }



        #endregion

        

        #region 学生-教师


        /// <summary>
        /// 获取当前学生的所有授课老师
        /// </summary>
        public static List<UserInfo> Get_Teacher_List(string StudentUID)
        {
            List<UserInfo> teacher_List = null;
            try
            {
                //获取所有当前教师所教学生
                teacher_List = (from s in Constant.Class_StudentInfo_List
                                where s.UniqueNo == StudentUID
                                join c in Constant.CourseRoom_List on s.Class_Id equals c.ClassID
                                join t in Constant.Teacher_List on c.TeacherUID equals t.UniqueNo
                                join u in Constant.UserInfo_List on t.UniqueNo equals u.UniqueNo

                                orderby t.UniqueNo
                                select u).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }

            return teacher_List;
        }

        public static List<Teacher> Get_Teacher_List2(string StudentUID)
        {
            List<Teacher> teacher_List = null;
            try
            {
                //获取所有当前教师所教学生
                teacher_List = (from s in Constant.Class_StudentInfo_List
                                where s.UniqueNo == StudentUID
                                join c in Constant.CourseRoom_List on s.Class_Id equals c.ClassID
                                join t in Constant.Teacher_List on c.TeacherUID equals t.UniqueNo
                                orderby t.UniqueNo
                                select t).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }

            return teacher_List;
        }

        #endregion

     

        #region 学生-课程

        public static List<student_course_Model> Student_Course(string StudentUID)
        {
            List<student_course_Model> student_course = null;
            try
            {
                student_course = (from student in Constant.Student_List
                                  where student.UniqueNo.Trim() == StudentUID.Trim()
                                  join user in Constant.UserInfo_List on student.UniqueNo equals user.UniqueNo
                                  //课堂
                                  join cls in Constant.Class_StudentInfo_List on student.UniqueNo equals cls.UniqueNo
                                  join room in Constant.CourseRoom_List on cls.Class_Id equals room.ClassID

                                  //教师
                                  join teacher in Constant.Teacher_List on room.TeacherUID equals teacher.UniqueNo
                                  join user2 in Constant.UserInfo_List on teacher.UniqueNo equals user2.UniqueNo
                                  //课程
                                  join course in Constant.Course_List on room.Coures_Id equals course.UniqueNo
                                  join courseref in Constant.CourseRel_List on course.UniqueNo equals courseref.Course_Id

                                  select new student_course_Model()
                                  {
                                      user = user,
                                      student = student,
                                      cls = cls,
                                      room = room,
                                      course = course,
                                      courseref = courseref,
                                      teacher = teacher,
                                      user2 = user2,
                                  }).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return student_course;
        }

        #endregion

        #region 学生-班级 【获取当前学生的班级】

        public static List<ClassInfo> Student_ClassInfo(string StudentUID)
        {
            List<ClassInfo> student_classInfo = null;
            try
            {
                student_classInfo = (from cls in Constant.Class_StudentInfo_List
                                     where cls.UniqueNo == StudentUID
                                     join c in Constant.ClassInfo_List on cls.Class_Id equals c.ClassNO
                                     select c).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return student_classInfo;
        }

        #endregion


        #region 课堂信息-班级

        public static List<ClassInfo> Course_ClassInfo_ByTeacher(string TeacherUID)
        {
            List<ClassInfo> student_classInfo = null;
            try
            {
                student_classInfo = (from c in Constant.CourseRoom_List
                                     where c.TeacherUID == TeacherUID
                                     join s in Constant.ClassInfo_List on c.ClassID equals s.ClassNO
                                     orderby s.Id
                                     select s).Distinct().ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return student_classInfo;
        }

        #endregion

        #region 试卷详题-答题

        public static object TableDetail_TaskAnswerByIndicatorType_Id(List<Eva_TableDetail> collection, int? IndicatorType_Id, List<Eva_TaskAnswer> ans_list)
        {
            object tableDetail_taskAnswer = null;
            try
            {
                tableDetail_taskAnswer = (from cl in collection
                                          where cl.IndicatorType_Id == IndicatorType_Id
                                          join ans_s in ans_list on cl.Id equals ans_s.TableDetail_Id into temp
                                          from tt in temp.DefaultIfEmpty()
                                          orderby cl.Sort
                                          select new
                                          {
                                              Ques = cl,
                                              Answer = tt != null ? tt.Answer : "",
                                              Score = tt != null ? tt.Score : 0
                                          });



            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return tableDetail_taskAnswer;
        }

        public static object TableDetail_TaskAnswer(List<Eva_TableDetail> collection, List<Eva_TaskAnswer> ans_list)
        {
            object tableDetail_taskAnswer = null;
            try
            {
                tableDetail_taskAnswer = (from cl in collection
                                          join ans_s in ans_list on cl.Id equals ans_s.TableDetail_Id into temp
                                          from tt in temp.DefaultIfEmpty()
                                          orderby cl.Sort
                                          select new
                                          {
                                              Ques = cl,
                                              Answer = tt != null ? tt.Answer : "",
                                              Score = tt != null ? tt.Score : 0
                                          }).ToList();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return tableDetail_taskAnswer;
        }

        #endregion     

       

     
        
        #region 表格引用次数添加

        public void TableUsingAdd(int? Table_Id)
        {
            try
            {
                //获取表的引用，减少引用次数
                Eva_Table table = Constant.Eva_Table_List.FirstOrDefault(t => Table_Id == t.Id);
                if (table != null)
                {
                    //克隆该表格
                    Eva_Table table_clone = Constant.Clone<Eva_Table>(table);
                    table_clone.UseTimes += 1;
                    JsonModel m3 = Constant.Eva_TableService.Update(table_clone);
                    if (m3.errNum == 0)
                    {
                        table.UseTimes += 1;
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        #endregion

        #region 表格引用次数减少

        public void TableUsingReduce(int? Table_Id)
        {
            try
            {
                //获取表的引用，减少引用次数
                Eva_Table table = Constant.Eva_Table_List.FirstOrDefault(t => Table_Id == t.Id);
                if (table != null)
                {
                    //克隆该表格
                    Eva_Table table_clone = Constant.Clone<Eva_Table>(table);
                    table_clone.UseTimes -= 1;
                    JsonModel m3 = Constant.Eva_TableService.Update(table_clone);
                    if (m3.errNum == 0)
                    {
                        table.UseTimes -= 1;
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
        }

        #endregion
    }
}