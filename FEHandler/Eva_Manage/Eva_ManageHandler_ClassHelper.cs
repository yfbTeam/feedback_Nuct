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
    partial class Eva_ManageHandler : IHttpHandler
    {
    }


    #region 定期评价获取model 类

    public class Regu_Student_Model
    {
        public string EvaName { get; set; }

        public int? SectionId { get; set; }

        public string SectionName { get; set; }

        public string EvaType { get; set; }

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public int Table_Id { get; set; }

        public int EvaId { get; set; }

        public string TeacherUID { get; set; }

        public string CourseName { get; set; }

        public string TeaName { get; set; }

        public string SourType { get; set; }

        public int EvaCount { get; set; }

        public string AveScore { get; set; }
    }


    #endregion

    #region 教师定期评价详情类

    public class Score_Model
    {
        public Eva_TableDetail t { get; set; }

        public double person_score { get; set; }

        public double college_score { get; set; }
        public double school_score { get; set; }

        /// <summary>
        /// 实际答题人数
        /// </summary>
        public int self_teacher_count { get; set; }

        /// <summary>
        /// 学校答题数量
        /// </summary>
        public int self_college_count { get; set; }
    }


    public class Feed_Anony_Model
    {
        public int Eva_TableDetailId { get; set; }

        public string TeacherUID { get; set; }

        public List<Feed_Anony_Model_Answer> Feed_Anony_Model_Answer_List { get; set; }

    }

    public class Feed_Anony_Model_Answer
    {
        public int AnswerId { get; set; }

        public DateTime CreateTime { get; set; }
        public string Answer { get; set; }
        public string StudentUID { get; set; }
        public int isExit { get; set; }
    }

    #endregion

    #region 表格设计类使用

    public class eva
    {
        public Eva_Table Eva_Table { get; set; }
        public Eva_Task Eva_Task { get; set; }
        public List<eva_detail> eva_detail_list { get; set; }
    }

    public class eva_detail
    {
        public string indicator_type_tname { get; set; }
        public string indicator_type_tid { get; set; }
        public IEnumerable<Eva_TableDetail> indicator_list { get; set; }
    }



    /// <summary>
    /// 学生已回答则查看【学生页面】
    /// </summary>
    public class eva_Answer
    {
        public Eva_Table Eva_Table { get; set; }
        public List<eva_detail_answer> eva_detail_list { get; set; }

        public List<eva_detail_answer> eva_detail_list_2 { get; set; }
    }

    public class eva_detail_answer
    {
        public string indicator_type_tname { get; set; }
        public string indicator_type_tid { get; set; }
        public List<Eva_TableDetail> indicator_list { get; set; }

        public List<Eva_QuestionAnswer_Detail> answer_detail_list { get; set; }


    }

    public class Table_CourseType
    {
        public string Course_Key { get; set; }

        public string Course_Value { get; set; }

        public List<Eva_Table> Eva_Table_List { get; set; }

        public int Eva_Role { get; set; }
    }




    /// <summary>
    /// 定期表格设计用
    /// </summary>
    public class Table_A
    {
        /// <summary>
        /// 教学内容
        /// </summary>
        public string indicator_type_tname { get; set; }
        /// <summary>
        /// Indicator_type_tid
        /// </summary>
        public long indicator_type_tid { get; set; }

        public string indicator_type_value { get; set; }

        /// <summary>
        /// Indicator_list
        /// </summary>
        public List<indicator_list> indicator_list { get; set; }
    }


    public class head_value
    {
        public string id { get; set; }
        public string description { get; set; }
        public string name { get; set; }

        public string Code { get; set; }

        public string CustomCode { get; set; }
    }

    public class lisss
    {
        public int Num { get; set; }
        public string t_Id { get; set; }
        public string title { get; set; }

        public string name { get; set; }
    }

    /// <summary>
    /// 表格设计用
    /// </summary>
    public class indicator_list
    {
        /// <summary>
        /// Id
        /// </summary>
        public long Id { get; set; }

        public decimal OptionF_S_Max { get; set; }

        /// <summary>
        /// 教师对学生要求严格。
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// IndicatorType_Id
        /// </summary>
        public long IndicatorType_Id { get; set; }

        public string IndicatorType_Name { get; set; }

        /// <summary>
        /// QuesType_Id
        /// </summary>
        public long QuesType_Id { get; set; }
        /// <summary>
        /// 优
        /// </summary>
        public string OptionA { get; set; }
        /// <summary>
        /// 良
        /// </summary>
        public string OptionB { get; set; }
        /// <summary>
        /// 中
        /// </summary>
        public string OptionC { get; set; }
        /// <summary>
        /// 差
        /// </summary>
        public string OptionD { get; set; }
        /// <summary>
        /// 很差
        /// </summary>
        public string OptionE { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string OptionF { get; set; }
        /// <summary>
        /// UseTimes
        /// </summary>
        public long UseTimes { get; set; }
        /// <summary>
        /// 理论课（专家用）
        /// </summary>
        public string Remarks { get; set; }
        /// <summary>
        /// 2017001
        /// </summary>
        public string CreateUID { get; set; }
        /// <summary>
        /// /Date(1489547328447)/
        /// </summary>
        public string CreateTime { get; set; }
        /// <summary>
        /// 001
        /// </summary>
        public string EditUID { get; set; }
        /// <summary>
        /// /Date(1489547328447)/
        /// </summary>
        public string EditTime { get; set; }
        /// <summary>
        /// IsEnable
        /// </summary>
        public long IsEnable { get; set; }
        /// <summary>
        /// IsDelete
        /// </summary>
        public long IsDelete { get; set; }
        /// <summary>
        /// Flg
        /// </summary>
        public long flg { get; set; }
        /// <summary>
        /// 1
        /// </summary>
        public string OptionA_S { get; set; }
        /// <summary>
        /// 2
        /// </summary>
        public string OptionB_S { get; set; }
        /// <summary>
        /// 3
        /// </summary>
        public string OptionC_S { get; set; }
        /// <summary>
        /// 3
        /// </summary>
        public string OptionD_S { get; set; }
        /// <summary>
        /// 3
        /// </summary>
        public string OptionE_S { get; set; }

        /// <summary>
        /// 3
        /// </summary>
        public string OptionF_S { get; set; }

        /// <summary>
        /// 101
        /// </summary>
        public string Sort { get; set; }

        public int RootID { get; set; }

        public string Root { get; set; }

        public int Table_Id { get; set; }
    }


    #endregion

    #region 表格设计用【新】

    public class Table_View
    {
        public string Name { get; set; }
        public int IsScore { get; set; }

        public int IsEnable { get; set; }

        public int Table_Id { get; set; }

        List<Table_Header> table_Header_List = new List<Table_Header>();
        /// <summary>
        /// 表头
        /// </summary>
        public List<Table_Header> Table_Header_List
        {
            get { return table_Header_List; }
            set { table_Header_List = value; }
        }

        List<Table_Detail_Dic> table_Detail_Dic_List = new List<Table_Detail_Dic>();
        /// <summary>
        /// 表格详情
        /// </summary>
        public List<Table_Detail_Dic> Table_Detail_Dic_List
        {
            get { return table_Detail_Dic_List; }
            set { table_Detail_Dic_List = value; }
        }

        public object Info { get; set; }
    }

    public class Table_Header
    {
        public int Id { get; set; }
        public string Header { get; set; }
        public int Sort { get; set; }

        public string CustomCode { get; set; }

        public string Value { get; set; }

        public int Type { get; set; }
    }
    public class Table_Detail_Dic
    {
        public string Root { get; set; }

        public List<Eva_TableDetail_S> Eva_TableDetail_List { get; set; }
    }

    public class Eva_TableDetail_S
    {
        /// <summary>
        /// 
        /// </summary>
        public int? Id { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Root { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Type { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public int? Eva_table_Id { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public int? Indicator_Id { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public int? QuesType_Id { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public int? IndicatorType_Id { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string IndicatorType_Name { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string OptionA { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string OptionB { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string OptionC { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string OptionD { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string OptionE { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string OptionF { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public decimal? OptionA_S { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public decimal? OptionB_S { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public decimal? OptionC_S { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public decimal? OptionD_S { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public decimal? OptionE_S { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public decimal? OptionF_S { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public int? Sort { get; set; }

        public decimal? OptionF_S_Max { get; set; }

        public int? RootID { get; set; }
    }


    #endregion

    #region 定期评价使用

    /// <summary>
    /// 定期评价获取【带detail】
    /// </summary>
    public class Eva_Regular_Custom
    {
        public Eva_Regular Eva_Regular { get; set; }

        public IEnumerable<object> objectList = null;

        public UserInfo UserInfo { get; set; }
    }



    #endregion

    #region 即时扫码使用

    //带即时扫码，+ 教师信息【用户信息】
    public class Ime_Model
    {
        public Eva_Task Eva_Task { get; set; }

        public UserInfo UserInfo { get; set; }

        public bool is_answer { get; set; }

        public int answer_count { get; set; }
        public double ave_score { get; set; }



        public double answer_percent { get; set; }
    }

    #endregion




    #region 即时扫码

    public class Eva_Common_Model
    {

        //定期评价名称
        public string regu_Name { get; set; }
        public string teacher_Name { get; set; }
        //类型【定期评价,即时评价，扫描评价】
        public int type { get; set; }
        //类型【定期评价,即时评价，扫描评价】名称
        public string type_Name { get; set; }


        //定期评价ID
        public int dis_Id { get; set; }
        //课程标识符
        public string course_UniqueNo { get; set; }

        //教师Id
        public int teacher_Id { get; set; }

        public string teacher_Unique { get; set; }

        public DateTime eva_regu_CreatTime { get; set; }

        /// <summary>
        /// 结束时间
        /// </summary>
        //public DateTime EndTime { get; set; }

        //表格Id
        public int table_Id { get; set; }

        public int task_Id { get; set; }

        //课程名称
        public string course_Name { get; set; }
        /// <summary>
        /// 学期ID
        /// </summary>
        public int section_Id { get; set; }

        /// <summary>
        /// 是否已评价
        /// </summary>
        public bool is_answer { get; set; }
    }


    //详情
    public class SellModel_Common
    {
        //public UserInfo user { get; set; }

        //public Student student { get; set; }

        //public CourseRoom room { get; set; }

        public Eva_Task task { get; set; }

        public Teacher teacher { get; set; }
        //获取该分配表的指定表格设计，然后取出指标库类型【集合】
        public List<int> list { get; set; }
        //表格设计里的每一道题【试卷里的所有题】
        public List<List<Score_Model>> TList { get; set; }


        //同上【教学反馈】
        public List<int> list2 { get; set; }
        //同上【教学反馈】
        public List<List<Score_Model>> TList2 { get; set; }

        public List<string> name_list { get; set; }

        public List<double> score_list { get; set; }

        public List<Feed_Anony_Model> feed_anony_model_list { get; set; }
    }

    #endregion




    #region 普通应用

    public class SimpleModel
    {
        public CourseRoom room { get; set; }
        public Course course { get; set; }
        public CourseRel courseref { get; set; }
        public Teacher teacher { get; set; }
        public UserInfo user { get; set; }
        public ClassInfo cls { get; set; }

        public string expertName { get; set; }
        public string ExpertUID { get; set; }

        public Major major { get; set; }
    }

    public class Sel_Model
    {
        public Sys_Dictionary dic { get; set; }

        public Eva_Table table { get; set; }
    }

    #endregion


    #region 数据合并


    class CourseRoomComparer : EqualityComparer<CourseRoom>
    {
        public override bool Equals(CourseRoom x, CourseRoom y)
        {
            return x.TeacherUID == y.TeacherUID && x.Coures_Id == y.Coures_Id;
        }
        public override int GetHashCode(CourseRoom obj)
        {
            return obj.TeacherUID.GetHashCode();
        }
    }



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

    class T_C_Model_ChildComparer : EqualityComparer<T_C_Model_Child>
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

    class DepartmentSelectComparer : EqualityComparer<DepartmentSelect>
    {
        public override bool Equals(DepartmentSelect x, DepartmentSelect y)
        {
            return x.DepartMentID == y.DepartMentID;
        }
        public override int GetHashCode(DepartmentSelect obj)
        {
            return obj.DepartMentID.GetHashCode();
        }
    }

    #endregion

    #region Task_Answer

    class Eva_Answer_Model_T
    {
        /// <summary>
        /// 学生评价集合
        /// </summary>
        public List<Eva_Answer_Model> List = new List<Eva_Answer_Model>();

        public byte IsScore = 0;

        int noAnswerCount = 0;

        public int NoAnswerCount
        {
            get { return noAnswerCount; }
            set { noAnswerCount = value; }
        }

        int haswerCount = 0;

        public int HaswerCount
        {
            get { return haswerCount; }
            set { haswerCount = value; }
        }
    }

    class Eva_Answer_Model
    {
        public string StuNo { get; set; }

        public string Major_Name { get; set; }

        public string Name { get; set; }

        public string Class_Name { get; set; }

        public DateTime CreateTime { get; set; }

        public double Score { get; set; }

        public int IsAnswer { get; set; }

    }

    class Eva_Task_Answer_Model
    {
        public DateTime CreateTime { get; set; }
        public string UniqueNo { get; set; }
        public double Score { get; set; }


    }

    #endregion


    #region new

    public class C_T
    {
        public UserInfo user { get; set; }

        public Major major { get; set; }

        public ClassInfo cs { get; set; }

        public Student stu { get; set; }
    }


    public class teacher_course_Model
    {
        public UserInfo user { get; set; }

        public Major major { get; set; }

        public CourseRoom room { get; set; }

        public Course course { get; set; }

        public CourseRel courseref { get; set; }

        public Teacher teacher { get; set; }
    }

    public class student_course_Model
    {
        public UserInfo user { get; set; }


        public CourseRoom room { get; set; }

        public Course course { get; set; }

        public CourseRel courseref { get; set; }

        public Teacher teacher { get; set; }

        public Student student { get; set; }

        public Class_StudentInfo cls { get; set; }

        public UserInfo user2 { get; set; }
    }


    public class ReguModel
    {
        public int? SectionId { get; set; }

        public string Value { get; set; }

        public string DisPlayName { get; set; }

        public int? Id { get; set; }

        public byte? Study_IsEnable { get; set; }

        public DateTime? EndTime { get; set; }

        public int ReguState { get; set; }



        public DateTime? ReguStartTime { get; set; }

        public DateTime? ReguEndTime { get; set; }
    }


    public class Regu_S
    {

        public int? SectionId { get; set; }

        public string DisPlayName { get; set; }

        public string CreateName { get; set; }

        public string ReguName { get; set; }

        public string CreateUID { get; set; }

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public DateTime? CreateTime { get; set; }

        public string State { get; set; }

        public int StateType { get; set; }

        public string TableName { get; set; }

        public int? Id { get; set; }

        public byte? LookType { get; set; }

        public int ReguState { get; set; }
    }

    public class DepartmentSelect
    {

        public string DepartMentID { get; set; }

        public string DepartmentName { get; set; }
    }

    public class CourseSection
    {

        public int? SectionId { get; set; }

        public int? Sort { get; set; }

        public string Value { get; set; }

        public string Type { get; set; }

        public string DisPlayName { get; set; }

        public DateTime? CreateTime { get; set; }

        public DateTime? StartTime { get; set; }

        public DateTime? EndTime { get; set; }

        public int? Id { get; set; }

        public string Key { get; set; }

        public int? Pid { get; set; }

        public byte? Study_IsEnable { get; set; }

        public byte? IsEnable { get; set; }

        public int ReguState { get; set; }

        public string State { get; set; }
    }

    class ClassModel
    {
        public string Academic { get; set; }

        public string Semester { get; set; }

        public string DisPlayName { get; set; }

        public string Course_Name { get; set; }


        public string GradeInfo_Name { get; set; }

        public string Teacher_Name { get; set; }

    

        public int Num { get; set; }

        public string DepartmentName { get; set; }

        public string CourseType { get; set; }

        public string CourseProperty { get; set; }

        public string TeacherDepartmentName { get; set; }

      

        public string ClassName { get; set; }

        public string CourseDepartmentName { get; set; }

        public int? SectionID { get; set; }

        public string TeacherUID { get; set; }

        public string CourseID { get; set; }

        public string ClassID { get; set; }

        public string RoomDepartmentName { get; set; }
    }

    public class ReModel
    {

        public string ReguName { get; set; }

        public int? ReguId { get; set; }
    }

    class ReModelComparer : EqualityComparer<ReModel>
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

    public class TeModel
    {

        public string TeacherUID { get; set; }

        public string TeacherName { get; set; }
    }

    class TeModelComparer : EqualityComparer<TeModel>
    {
        public override bool Equals(TeModel x, TeModel y)
        {
            return x.TeacherUID == y.TeacherUID;
        }
        public override int GetHashCode(TeModel obj)
        {
            return obj.TeacherUID.GetHashCode();
        }
    }

    public class ClsModel
    {
        public string ClassID { get; set; }

        public string ClassName { get; set; }

        public string Major_ID { get; set; }
    }

    class ClsModelComparer : EqualityComparer<ClsModel>
    {
        public override bool Equals(ClsModel x, ClsModel y)
        {
            return x.ClassID == y.ClassID;
        }
        public override int GetHashCode(ClsModel obj)
        {
            return obj.ClassID.GetHashCode();
        }
    }



    public class DPModel
    {
        public string Major_ID { get; set; }

        public string DepartmentName { get; set; }

    
    }

    class DPModelComparer : EqualityComparer<DPModel>
    {
        public override bool Equals(DPModel x, DPModel y)
        {
            return x.Major_ID == y.Major_ID;
        }
        public override int GetHashCode(DPModel obj)
        {
            return obj.Major_ID.GetHashCode();
        }
    }

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
    }

    public class Eva_QuestionModel
    {

        public int? SectionID { get; set; }

        public string DisPlayName { get; set; }

        public string TeacherUID { get; set; }

        public string TeacherName { get; set; }

        public string CourseID { get; set; }

        public string CourseName { get; set; }

        public string DepartmentID { get; set; }

        public string DepartmentName { get; set; }

        public int? TableID { get; set; }

        public string TableName { get; set; }

        public int? State { get; set; }

        public decimal? Score { get; set; }

        public int Num { get; set; }

        public int? ReguID { get; set; }

        public string ReguName { get; set; }

        public string AnswerUID { get; set; }

        public string AnswerName { get; set; }

        public int? Id { get; set; }
    }

    class Eva_TableComparer : EqualityComparer<Eva_Table>
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


    #endregion


}

#region 枚举类

enum IsSued
{
    //未下发
    No = 1,
    //已下发
    Yes = 0,
}

enum IsAnswer
{
    //未回答
    No = 1,
    //已回答
    Yes = 0,
}

enum LookType
{
    AllSchool = 0,
    DepartmentType = 1,
}


enum IsScore
{
    //记分
    Yes = 0,
    //未记分
    No = 1,
}

enum IsPublish
{
    //发布
    Yes = 0,
    //未发布
    No = 1,
}

enum IsEnable
{
    //启用
    Enable = 0,
    //未启用
    DisEnable = 1,
}

enum IsDelete
{
    //未删除状态
    No_Delete = 0,
    //删除状态
    Delete = 1,
}

enum IndicatorType_Type
{
    //普通指标类型
    Common = 0,
    //教学反馈
    Edu_Back = 1,
}



enum ReguType
{  
    Expert = 1,   
    Student = 2,

}

enum errNum
{
    //调用成功
    Success = 0,
    Failed = 3,
}



public enum ModeType
{
    Record = 1,
    Check = 2,
    Look = 3,

}

public enum QueState
{
    Saved = 1,
    Submited = 2,
    Checked = 3,
}

enum Dictionary_Type
{
    //普通课程类型
    Common_Course_Type = 0,

    //教学信息员
    Edu_Course_Type = 1,

    //院系领导
    Leader_Course_Type = 2,
}


enum TableDetail_Type
{

    //表格设计
    Table = 1,

    //评价任务
    Check = 2,
}


enum ReguState
{
    未开始 = 1,
    进行中 = 2,
    已结束 = 3,
}

#endregion