using FEHandler.Eva_Manage;
using FEModel;
using FEModel.Entity;
using FEModel.Enum;
using FEUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FEHandler.SysClass
{
    /// <summary>
    /// ClassInfoHandler 的摘要说明
    /// </summary>
    public class ClassInfoHandler : IHttpHandler
    {
        #region 字段

        JsonModel jsonModel = new JsonModel();

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        #endregion

        #region 中心入口

        public void ProcessRequest(HttpContext context)
        {
            HttpRequest Request = context.Request;
            string func = RequestHelper.string_transfer(Request, "func");
            try
            {
                switch (func)
                {
                    //获取教学安排信息
                    case "GetClassInfo": GetClassInfo(context); break;
                    //获取教学安排筛选
                    case "GetClassInfoSelect": GetClassInfoSelect(context); break;

                    //获取学年学期
                    case "Get_StudySection_List": Get_StudySection_List(context); break;
                    default:
                        jsonModel = JsonModel.get_jsonmodel(5, "没有此方法", "");
                        context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
                        break;
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                jsonModel = JsonModel.get_jsonmodel(7, "出现异常,请通知管理员", "");
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion

        #region 获取学年学期

        public void Get_StudySection_List(HttpContext context)
        {
            try
            {
                HttpRequest Request = context.Request;
                int intSuccess = (int)errNum.Success;

                List<StudySection> StudySection_List = Constant.StudySection_List;

                //
                var query = from StudySection_ in StudySection_List
                            select new
                            {
                                //年度
                                Academic = StudySection_.Academic,
                                //级别
                                Semester = StudySection_.Semester,
                                DisPlayName = StudySection_.DisPlayName,
                            };
                Dictionary<object, object> map_Academic = new Dictionary<object, object>();
                Dictionary<object, object> map_Semester = new Dictionary<object, object>();
                Dictionary<object, object> map_DisPlayName = new Dictionary<object, object>();
                foreach (var i in query)
                {
                    if (!map_Academic.ContainsKey(i.Academic))
                    {
                        map_Academic.Add(i.Academic, 1);
                    };
                    if (!map_Semester.ContainsKey(i.Semester))
                    {
                        map_Semester.Add(i.Semester, 1);
                    };
                    if (!map_DisPlayName.ContainsKey(i.DisPlayName))
                    {
                        map_DisPlayName.Add(i.DisPlayName, 1);
                    };
                }
                Dictionary<string, object> remap = new Dictionary<string, object>();
                remap.Add("Academic", map_Academic.Keys);
                remap.Add("Semester", map_Semester.Keys);
                remap.Add("DisPlayName", map_DisPlayName.Keys);
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", remap);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        #endregion

        #region 获取教学安排信息

        public void GetClassInfo(HttpContext context)
        {
            HttpRequest request = context.Request;
            int PageIndex = RequestHelper.int_transfer(request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(request, "PageSize");

            int SectionID = RequestHelper.int_transfer(request, "SectionID");
            string DP = RequestHelper.string_transfer(request, "DP");
            string CT = RequestHelper.string_transfer(request, "CT");
            string CP = RequestHelper.string_transfer(request, "CP");
            string TD = RequestHelper.string_transfer(request, "TD");
            string TN = RequestHelper.string_transfer(request, "TN");
            string MD = RequestHelper.string_transfer(request, "MD");
            string GD = RequestHelper.string_transfer(request, "GD");
            string CN = RequestHelper.string_transfer(request, "CN");
            string Key = RequestHelper.string_transfer(request, "Key");


            SortType S_DP = (SortType)RequestHelper.int_transfer(request, "S_DP");
            SortType S_CN = (SortType)RequestHelper.int_transfer(request, "S_CN");
            SortType S_CT = (SortType)RequestHelper.int_transfer(request, "S_CT");
            SortType S_CP = (SortType)RequestHelper.int_transfer(request, "S_CP");
            SortType S_TD = (SortType)RequestHelper.int_transfer(request, "S_TD");
            SortType S_TN = (SortType)RequestHelper.int_transfer(request, "S_TN");

            SortType S_MD = (SortType)RequestHelper.int_transfer(request, "S_MD");
            SortType S_GD = (SortType)RequestHelper.int_transfer(request, "S_GD");
            SortType S_CLS = (SortType)RequestHelper.int_transfer(request, "S_CLS");
            SortType S_TJ = (SortType)RequestHelper.int_transfer(request, "S_TJ");
            SortType S_BR = (SortType)RequestHelper.int_transfer(request, "S_BR");
            SortType S_SY = (SortType)RequestHelper.int_transfer(request, "S_SY");

            string DepartmentName = RequestHelper.string_transfer(request, "DepartmentName");

            int ClassModeltype = RequestHelper.int_transfer(request, "ClassModelType");
            ClassModelType ClassModelType = (ClassModelType)ClassModeltype;

            int BirthdayS = RequestHelper.int_transfer(request, "BirthdayS");
            int BirthdayE = RequestHelper.int_transfer(request, "BirthdayE");

            int SchoolS = RequestHelper.int_transfer(request, "SchoolS");
            int SchoolE = RequestHelper.int_transfer(request, "SchoolE");

            try
            {
                jsonModel = GetClassInfo_Helper(PageIndex, PageSize, SectionID, DP, CT, CP, TD, TN, MD, GD,
                    CN, Key, ClassModelType, BirthdayS, BirthdayE, SchoolS, SchoolE,
                    S_DP, S_CN, S_CT, S_CP, S_TD, S_TN, S_MD, S_GD, S_CLS, S_TJ, S_BR, S_SY, DepartmentName);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModelNum GetClassInfo_Helper(int PageIndex, int PageSize, int SectionID, string DP, string CT, string CP, string TD,
            string TN, string MD, string GD, string CN, string Key, ClassModelType ClassModelType, int BirthdayS, int BirthdayE, int SchoolS, int SchoolE,
            SortType S_DP, SortType S_CN, SortType S_CT, SortType S_CP, SortType S_TD, SortType S_TN,
            SortType S_MD, SortType S_GD, SortType S_CLS, SortType S_TJ, SortType S_BR, SortType S_SY, string DepartmentName)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                List<Course> Course_List = Constant.Course_List;

                List<CourseRel> CourseRel_List = Constant.CourseRel_List;
                List<Sys_Dictionary> Sys_Dictionary_List = Constant.Sys_Dictionary_List;
                  List<CourseRoom> CourseRoom_List = Constant.CourseRoom_List;
                List<StudySection> StudySection_List = Constant.StudySection_List;

                var list = (from cref in CourseRel_List
                            join dic in Sys_Dictionary_List on cref.CourseType_Id equals dic.Key
                            join sdy in StudySection_List on dic.SectionId equals sdy.Id
                            where cref.StudySection_Id == sdy.Id
                            select new { SectionID = sdy.Id,CourseID = cref.Course_Id ,dic.Value}).ToList();


                var query = (from CourseRoom_ in CourseRoom_List
                             join Course_ in Course_List on CourseRoom_.Coures_Id equals Course_.UniqueNo
                             join StudySection_ in StudySection_List on CourseRoom_.StudySection_Id equals StudySection_.Id
                             join li in list on new { SectionID = StudySection_.Id, CourseID = Course_.UniqueNo } equals new { SectionID = li.SectionID, CourseID = li.CourseID} into lis
                             from li_ in lis.DefaultIfEmpty()

                             select new ClassModel()
                             {
                                 CourseTypeDic =li_!=null? li_.Value:"",
                                 //年度
                                 Academic = StudySection_.Academic,
                                 //级别
                                 SectionID = StudySection_.Id,
                                 //学年学期
                                 DisPlayName = StudySection_.DisPlayName,
                                 //课堂名称
                                 Course_Name = Course_.Name,
                                 //班
                                 ClassName = CourseRoom_.ClassName,
                                 //年级
                                 GradeInfo_Name = CourseRoom_.GradeName,
                                 //教师姓名
                                 Teacher_Name = CourseRoom_.TeacherName,
                                 //开课部门
                                 DepartmentName = Course_.DepartmentName,
                                 //课程类型
                                 CourseType = CourseRoom_.CourseType,
                                 //课程性质
                                 CourseProperty = Course_.CourseProperty,
                                 //教师部门
                                 TeacherDepartmentName = CourseRoom_.TeacherDepartmentName,
                                 //专业部门
                                 CourseDepartmentName = CourseRoom_.DepartmentName,
                                 RoomDepartmentName = CourseRoom_.RoomDepartmentName,

                                 TeacherJobTitle = CourseRoom_.TeacherJobTitle,
                                 TeacherBirthday = CourseRoom_.TeacherBirthday,
                                 TeacherSchooldate = CourseRoom_.TeacherSchooldate,
                                 CourseID = CourseRoom_.Coures_Id,
                                 ClassID = CourseRoom_.ClassID,
                                 TeacherUID = CourseRoom_.TeacherUID,
                                 Id = CourseRoom_.UniqueNo,
                                 //序号
                                 Num = 0,
                             });
                query = GetClassInfoNormalHelper(SectionID, DP, CT, CP, TD, TN, MD, GD, CN, Key, DepartmentName, query);

                switch (ClassModelType)
                {
                    case ClassModelType.CourseRoom:

                        break;
                    case ClassModelType.DisExpertTask:
                        query = (from q in query where q.TeacherBirthday >= BirthdayS && q.TeacherBirthday <= BirthdayE && q.TeacherSchooldate >= SchoolS && q.TeacherSchooldate <= SchoolE select q);
                        break;
                    default:
                        break;
                }

                query = GetClassInfoSortHelper(S_DP, S_CN, S_CT, S_CP, S_TD, S_TN, S_MD, S_GD, S_CLS, S_TJ, S_BR, S_SY, query);

                var queryList = query.ToList();
                int count = 1;
                queryList.ForEach(i =>
                {
                    i.Num += count;
                    count++;
                });

                var query_last = (from an in queryList select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();
                foreach (var li in query_last)
                {                    
                    li.TableCount = (from r in Constant.CourseRel_List
                                     where r.Course_Id == li.CourseID && r.StudySection_Id == li.SectionID
                                     join t in Constant.Eva_CourseType_Table_List on new { CourseTypeId = r.CourseType_Id, r.StudySection_Id } equals new { CourseTypeId = t.CourseTypeId, t.StudySection_Id }
                                     select r).ToList().Count();
                }
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)query.Count() / PageSize);
                jsm.RowCount = query.Count();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        private static IEnumerable<ClassModel> GetClassInfoSortHelper(SortType S_DP, SortType S_CN, SortType S_CT, SortType S_CP, SortType S_TD, SortType S_TN, SortType S_MD, SortType S_GD, SortType S_CLS, SortType S_TJ, SortType S_BR, SortType S_SY, IEnumerable<ClassModel> query)
        {
            try
            {
                if (S_DP != SortType.normal)
                {
                    query = S_DP == SortType.desc ? (from q in query orderby q.DepartmentName descending select q)
                   : (from q in query orderby q.DepartmentName ascending select q);
                }

                if (S_CN != SortType.normal)
                {
                    query = S_CN == SortType.desc ? (from q in query orderby q.Course_Name descending select q)
                   : (from q in query orderby q.Course_Name ascending select q);
                }
                if (S_CT != SortType.normal)
                {
                    query = S_DP == SortType.desc ? (from q in query orderby q.CourseType descending select q)
                   : (from q in query orderby q.CourseType ascending select q);
                }
                if (S_CP != SortType.normal)
                {
                    query = S_DP == SortType.desc ? (from q in query orderby q.CourseProperty descending select q)
                   : (from q in query orderby q.CourseProperty ascending select q);
                }
                if (S_TD != SortType.normal)
                {
                    query = S_DP == SortType.desc ? (from q in query orderby q.TeacherDepartmentName descending select q)
                   : (from q in query orderby q.TeacherDepartmentName ascending select q);
                }
                if (S_TN != SortType.normal)
                {
                    query = S_DP == SortType.desc ? (from q in query orderby q.Teacher_Name descending select q)
                   : (from q in query orderby q.Teacher_Name ascending select q);
                }

                //, , , , , 
                if (S_MD != SortType.normal)
                {
                    query = S_MD == SortType.desc ? (from q in query orderby q.RoomDepartmentName descending select q)
                   : (from q in query orderby q.RoomDepartmentName ascending select q);
                }
                if (S_GD != SortType.normal)
                {
                    query = S_GD == SortType.desc ? (from q in query orderby q.GradeInfo_Name descending select q)
                   : (from q in query orderby q.GradeInfo_Name ascending select q);
                }
                if (S_CLS != SortType.normal)
                {
                    query = S_CLS == SortType.desc ? (from q in query orderby q.ClassName descending select q)
                   : (from q in query orderby q.ClassName ascending select q);
                }
                if (S_TJ != SortType.normal)
                {
                    query = S_TJ == SortType.desc ? (from q in query orderby q.TeacherJobTitle descending select q)
                   : (from q in query orderby q.DepartmentName ascending select q);
                }
                if (S_BR != SortType.normal)
                {
                    query = S_BR == SortType.desc ? (from q in query orderby q.TeacherBirthday descending select q)
                   : (from q in query orderby q.TeacherBirthday ascending select q);
                }
                if (S_SY != SortType.normal)
                {
                    query = S_DP == SortType.desc ? (from q in query orderby q.TeacherSchooldate descending select q)
                   : (from q in query orderby q.TeacherSchooldate ascending select q);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return query;
        }

        private static IEnumerable<ClassModel> GetClassInfoNormalHelper(int SectionID, string DP, string CT, string CP, string TD, string TN, string MD, string GD, string CN, string Key, string DepartmentName, IEnumerable<ClassModel> query)
        {
            try
            {
                if (SectionID > 0)
                {
                    query = (from q in query where q.SectionID == SectionID select q);
                }
                if (DP != "")
                {
                    query = (from q in query where q.DepartmentName == DP select q);
                }
                if (CT != "")
                {
                    query = (from q in query where q.CourseType == CT select q);
                }
                if (CP != "")
                {
                    query = (from q in query where q.CourseProperty == CP select q);
                }
                if (TD != "")
                {
                    query = (from q in query where q.TeacherDepartmentName == TD select q);
                }
                if (TN != "")
                {
                    query = (from q in query where q.TeacherUID == TN select q);
                }
                if (MD != "")
                {
                    query = (from q in query where q.CourseDepartmentName == MD select q);
                }
                if (GD != "")
                {
                    query = (from q in query where q.GradeInfo_Name == GD select q);
                }
                if (CN != "")
                {
                    query = (from q in query where q.ClassName == CN select q);
                }

                if (Key != "")
                {
                    query = (from q in query where q.Course_Name.Contains(Key) select q);
                }

                if(DepartmentName!= "")
                {
                    query = (from q in query where q.TeacherDepartmentName == DepartmentName select q);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return query;
        }

        #endregion

        #region 获取教学安排筛选

        public void GetClassInfoSelect(HttpContext context)
        {
            HttpRequest request = context.Request;
            int SectionID = RequestHelper.int_transfer(request, "SectionID");
            string TeacherUID = RequestHelper.string_transfer(request, "TeacherUID");
            string CourseID = RequestHelper.string_transfer(request, "CourseID");

            string DepartmentName = RequestHelper.string_transfer(request, "DepartmentName");
            try
            {
                jsonModel = GetClassInfoSelect_Helper(SectionID, TeacherUID, CourseID, DepartmentName);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsonModel) + "}");
            }
        }

        public static JsonModelNum GetClassInfoSelect_Helper(int SectionID, string TeacherUID, string CourseID, string DepartmentName)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                List<Course> Course_List = Constant.Course_List;
                List<CourseRoom> CourseRoom_List = Constant.CourseRoom_List;
                List<StudySection> StudySection_List = Constant.StudySection_List;

                var query = (from CourseRoom_ in CourseRoom_List
                             join Course_ in Course_List on CourseRoom_.Coures_Id equals Course_.UniqueNo
                             join StudySection_ in StudySection_List on CourseRoom_.StudySection_Id equals StudySection_.Id
                             select new ClassModel()
                             {
                                 Id = CourseRoom_.UniqueNo,
                                 SectionID = StudySection_.Id,
                                 //年度
                                 Academic = StudySection_.Academic,
                                 //级别
                                 Semester = StudySection_.Semester,
                                 //学年学期
                                 DisPlayName = StudySection_.DisPlayName,
                                 //课堂名称
                                 Course_Name = Course_.Name,
                                 //班
                                 ClassName = CourseRoom_.ClassName,
                                 //年级
                                 GradeInfo_Name = CourseRoom_.GradeName,
                                 //教师姓名
                                 Teacher_Name = CourseRoom_.TeacherName,
                                 //开课部门
                                 DepartmentName = Course_.DepartmentName,
                                 //课程类型
                                 CourseType = CourseRoom_.CourseType,
                                 //课程性质
                                 CourseProperty = Course_.CourseProperty,
                                 //教师部门
                                 TeacherDepartmentName = CourseRoom_.TeacherDepartmentName,
                                 //专业部门
                                 CourseDepartmentName = CourseRoom_.DepartmentName,

                                 RoomDepartmentName = CourseRoom_.RoomDepartmentName,

                                 TeacherUID = CourseRoom_.TeacherUID,
                                 CourseID = CourseRoom_.Coures_Id,
                                 ClassID = CourseRoom_.ClassID,

                                 //序号
                                 Num = 0,
                             }).ToList();
                if (SectionID > 0)
                {
                    query = (from q in query where q.SectionID == SectionID select q).ToList();
                }
                if (TeacherUID != "")
                {
                    query = (from q in query where q.TeacherUID == TeacherUID select q).ToList();
                }
                if (CourseID != "")
                {
                    query = (from q in query where q.CourseID == CourseID select q).ToList();
                }

                if (DepartmentName != "")
                {
                    query = (from q in query where q.DepartmentName == DepartmentName select q).ToList();
                }

                var data = new
                {
                    DPList = (from qe in query where qe.DepartmentName != "" select qe.DepartmentName).Distinct().ToList(),
                    CTList = (from qe in query where qe.CourseType != "" select qe.CourseType).Distinct().ToList(),
                    CPList = (from qe in query where qe.CourseProperty != "" select qe.CourseProperty).Distinct().ToList(),
                    TDList = (from qe in query where qe.TeacherDepartmentName != "" select qe.TeacherDepartmentName).Distinct().ToList(),
                    TNList = (from qe in query where qe.Teacher_Name != "" select new TNModel() {TeacherUID = qe.TeacherUID, TeacherName = qe.Teacher_Name, TeacherDepartmentName =qe.TeacherDepartmentName }).Distinct(new  TNModelComparer()).ToList(),
                    MDList = (from qe in query where qe.CourseDepartmentName != "" select qe.CourseDepartmentName).Distinct().ToList(),
                    GDList = (from qe in query where qe.GradeInfo_Name != "" select qe.GradeInfo_Name).Distinct().ToList(),
                    CNList = (from qe in query where qe.ClassName != "" select qe.ClassName).Distinct().ToList(),
                    RPList = (from qe in query where qe.RoomDepartmentName != "" select qe.RoomDepartmentName).Distinct().ToList(),
                    ClsList = (from qe in query where qe.ClassName != "" select new ClsModel() { ClassID = qe.ClassID, ClassName = qe.ClassName }).Distinct(new ClsModelComparer()).ToList(),
                    CCList = (from qe in query where qe.CourseID != "" && qe.ClassID != "" select new CCModel {Id =qe.Id, ClassID = qe.ClassID, CourseID = qe.CourseID, ClassName = qe.ClassName, Course_Name = qe.Course_Name }).Distinct(new CCModelComparer()).ToList(),
                };

                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", data);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        #endregion

    }
}