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
        #region 获取定期评价

        /// <summary>
        ///获取定期评价【课堂评价】
        /// </summary>
        public void Get_Eva_RegularS(HttpContext context)
        {

            JsonModelNum jsm = new JsonModelNum();
            HttpRequest Request = context.Request;
            int intSuccess = (int)errNum.Success;
            int Type = RequestHelper.int_transfer(Request, "Type");
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");
            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                var regulist = (from regu in Constant.Eva_Regular_List
                                join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                                join user in Constant.UserInfo_List on regu.CreateUID equals user.LoginName
                                join table in Constant.Eva_Table_List on regu.TableID equals table.Id
                                where regu.Type == Type
                                select new Regu_S()
                                {
                                    SectionId = section.Id,
                                    DisPlayName = section.DisPlayName,
                                    CreateName = user.Name,
                                    ReguName = regu.Name,
                                    CreateUID = regu.CreateUID,
                                    StartTime = regu.StartTime,
                                    EndTime = regu.EndTime,
                                    CreateTime = regu.CreateTime,
                                    State = "",
                                    StateType = 0,
                                    TableName = table.Name,
                                    Id = regu.Id,
                                    LookType = regu.LookType,
                                }).ToList();

                if (SectionId > 0)
                {
                    regulist = (from regu in regulist
                                where regu.SectionId == SectionId
                                select regu).ToList();

                }

                var query_last = (from an in regulist select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();

                ReguState regustate = ReguState.进行中;
                foreach (var li in query_last)
                {

                    if (li.StartTime < DateTime.Now && ((DateTime)li.EndTime).AddDays(1) > DateTime.Now)
                    {
                        regustate = ReguState.进行中;
                    }
                    else if (li.StartTime > DateTime.Now)
                    {
                        regustate = ReguState.未开始;
                    }
                    else
                    {
                        regustate = ReguState.已结束;
                    }
                    li.State = Convert.ToString(regustate);
                    li.ReguState = (int)regustate;
                }

                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)regulist.Count() / PageSize);
                jsm.RowCount = regulist.Count();

                jsonModel = JsonModel.get_jsonmodel(0, "success", regulist);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            finally
            {
                //无论后端出现什么问题，都要给前端有个通知【为防止jsonModel 为空 ,全局字段 jsonModel 特意声明之后进行初始化】
                context.Response.Write("{\"result\":" + Constant.jss.Serialize(jsm) + "}");
            }
        }

        /// <summary>
        ///获取定期评价
        /// </summary>
        public void Get_Eva_Regular(HttpContext context)
        {

            HttpRequest Request = context.Request;
            int Type = RequestHelper.int_transfer(Request, "Type");
            int SectionId = RequestHelper.int_transfer(Request, "SectionId");
            try
            {
                jsonModel = Get_Eva_RegularHelper(SectionId, Type);
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

        public static JsonModel Get_Eva_RegularHelper(int SectionId, int Type)
        {
            JsonModel model = new JsonModel();
            int intSuccess = (int)errNum.Success;
            try
            {
                var list = (from regu in Constant.Eva_Regular_List
                            where regu.Type == Type
                            join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                            select new ReguModel()
                            {
                                SectionId = section.Id,
                                Value = regu.Name,
                                DisPlayName = section.DisPlayName,
                                Id = regu.Id,
                                Study_IsEnable = section.IsEnable,
                                EndTime = section.EndTime,
                                ReguStartTime = regu.StartTime,
                                ReguEndTime = regu.EndTime,
                            }).ToList();
                foreach (var item in Constant.StudySection_List)
                {
                    var li = list.FirstOrDefault(i => i.SectionId == item.Id);
                    if (li == null)
                    {
                        list.Add(new ReguModel()
                        {
                            SectionId = item.Id,
                            Value = "",
                            DisPlayName = item.DisPlayName,
                            Id = (int?)0,
                            Study_IsEnable = item.IsEnable,
                            EndTime = item.EndTime,
                            ReguStartTime = item.StartTime,
                            ReguEndTime = item.EndTime,
                        });
                    }
                }
                if (SectionId > 0)
                {
                    list = (from li in list where li.SectionId == SectionId select li).ToList();
                }
                ReguState regustate = ReguState.进行中;
                foreach (var li in list)
                {

                    if (li.ReguStartTime < DateTime.Now && ((DateTime)li.ReguEndTime).AddDays(1) > DateTime.Now)
                    {
                        regustate = ReguState.进行中;
                    }
                    else if (li.ReguStartTime > DateTime.Now)
                    {
                        regustate = ReguState.未开始;
                    }
                    else
                    {
                        regustate = ReguState.已结束;
                    }
                    li.ReguState = (int)regustate;
                }
                list = (from li in list orderby li.EndTime descending select li).ToList();
                //返回所有表格数据
                model = JsonModel.get_jsonmodel(intSuccess, "success", list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        /// <summary>
        /// 筛选
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_Regular_Select(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            int Type = RequestHelper.int_transfer(Request, "Type");

            try
            {
                List<Eva_Regular> regulist = Constant.Eva_Regular_List;
                if (SectionID > 0)
                {
                    regulist = (from li in regulist where li.Section_Id == SectionID select li).ToList();
                }
                if (Type > 0)
                {
                    regulist = (from li in regulist where li.Type == Type select li).ToList();
                }

                var select = new
                {
                    RgList = (from li in regulist select new ReModel() { ReguId = li.Id, ReguName = li.Name }).Distinct(new ReModelComparer()).ToList(),
                };

                //返回所有表格数据
                jsonModel = JsonModelNum.GetJsonModel_o(intSuccess, "success", select);
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

        /// <summary>
        ///获取单独评价
        /// </summary>
        public void Get_Eva_RegularSingle(HttpContext context)
        {

            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                Eva_Regular regu = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                if (regu != null)
                {
                    Eva_Table table = Constant.Eva_Table_List.FirstOrDefault(t => t.Id == regu.TableID);
                    StudySection section = Constant.StudySection_List.FirstOrDefault(s => s.Id == regu.Section_Id);
                    List<Major> departments = new List<Major>();
                    List<string> departmentids = new List<string>();
                    if (regu.LookType == (int)LookType.DepartmentType && regu.DepartmentIDs != "")
                    {
                        string[] departs = Split_Hepler.str_to_stringss(regu.DepartmentIDs);
                        departments = (from d in Constant.Major_List where departs.Contains(d.Id) select d).ToList();
                        departmentids = (from d in departments select d.Id).ToList();
                    }
                    var li = new
                    {
                        regu.StartTime,
                        regu.EndTime,
                        regu.Id,
                        regu.Name,
                        regu.LookType,
                        TableName = table != null ? table.Name : "",
                        section.DisPlayName,
                        SectionID = section.Id,
                        DepartmentList = departments,
                        regu.Type,
                        regu.TableID,
                        DepartmentIdList = departmentids,
                    };
                    jsonModel = JsonModel.get_jsonmodel(0, "success", li);
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "指定的定期评价不存在");
                }
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

        #region 获取课堂评价

        /// <summary>
        /// 获取定期评价列表数据
        /// </summary>
        public void Get_Eva_RegularData_Room(HttpContext context)
        {
            HttpRequest Request = context.Request;

            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            int ReguID = RequestHelper.int_transfer(Request, "ReguID");


            string Te = RequestHelper.string_transfer(Request, "Te");
            string RP = RequestHelper.string_transfer(Request, "RP");
            string Gr = RequestHelper.string_transfer(Request, "Gr");
            string Key = RequestHelper.string_transfer(Request, "Key");

            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                jsonModel = Get_Eva_RegularData_Room_Helper(PageIndex, PageSize, SectionID, ReguID, Key, Te, RP, Gr);
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

        public static JsonModel Get_Eva_RegularData_Room_Helper(int PageIndex, int PageSize, int SectionID, int ReguID, string Key, string Te, string RP, string Gr)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                List<RegularDataRoomModel> list = (from regu in Constant.Eva_Regular_List
                                                   where regu.Type == (int)ReguType.Student
                                                   join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                                                   from room in Constant.CourseRoom_List
                                                   where (regu.DepartmentIDs.Contains(room.Major_Id)) || regu.DepartmentIDs == ""
                                                   orderby regu.EndTime descending
                                                   select new RegularDataRoomModel()
                                                   {
                                                       Num = 0,
                                                       SectionID = section.Id,
                                                       DisPlayName = section.DisPlayName,
                                                       ReguID = regu.Id,
                                                       ReguName = regu.Name,
                                                       RoomID = room.Id,
                                                       CourseID = room.Coures_Id,
                                                       CourseName = room.CouresName,
                                                       TeacherUID = room.TeacherUID,
                                                       TeacherName = room.TeacherName,
                                                       RoomDepartmentName = room.RoomDepartmentName,
                                                       GradeName = room.GradeName,
                                                       ClassName = room.ClassName,
                                                       StudentCount = room.StudentCount,
                                                       QuestionCount = 0,
                                                       QuestionAve = 0,
                                                       ScoreAve = 0,
                                                       TableID = regu.TableID,
                                                       StartTime = regu.StartTime,
                                                       EndTime = regu.EndTime,
                                                       IsOverTime = true,
                                                   }).ToList();

                var questionList = (from q in Constant.Eva_QuestionAnswer_List
                                    where q.Eva_Role == (int)ReguType.Student
                                    select q).ToList();
                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();

                    questionList = (from q in questionList
                                    where q.SectionID == SectionID
                                    select q).ToList();
                }

                if (ReguID > 0)
                {
                    list = (from li in list where li.ReguID == ReguID select li).ToList();

                    questionList = (from q in questionList
                                    where q.ReguID == ReguID
                                    select q).ToList();
                }
                if (Te != "")
                {
                    list = (from li in list where li.TeacherName == Te select li).ToList();
                }
                if (RP != "")
                {
                    list = (from li in list where li.RoomDepartmentName == RP select li).ToList();
                }
                if (Gr != "")
                {
                    list = (from li in list where li.GradeName == Gr select li).ToList();
                }

                if (Key != "")
                {
                    list = (from li in list where li.CourseName.Contains(Key) select li).ToList();
                }

                for (int i = 0; i < list.Count; i++)
                {
                    list[i].Num = i + 1;
                }

                var query_last = (from an in list select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();


                foreach (var li in query_last)
                {
                    if (li.StartTime < DateTime.Now && ((DateTime)li.EndTime).AddDays(1) > DateTime.Now)
                    {
                        li.IsOverTime = false;
                    }

                    var chilist = (from q in questionList
                                   where q.TeacherUID == li.TeacherUID
                                   select q).ToList();
                    int que_count = chilist.Count;
                    if (que_count > 0)
                    {
                        decimal que_allScore = (decimal)chilist.Sum(i => i.Score);

                        li.QuestionCount = que_count;
                        li.QuestionAve = que_count > 0 ? (decimal)Math.Round(que_count / (decimal)li.StudentCount, 2) : 0;
                        //计算平均分
                        li.ScoreAve = que_count > 0 ? (decimal)Math.Round(que_allScore / (decimal)que_count, 2) : 0;
                    }

                }
                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)list.Count() / PageSize);
                jsm.RowCount = list.Count();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }


        public void Get_Backlog(HttpContext context)
        {
            HttpRequest Request = context.Request;
            string StudentUID = RequestHelper.string_transfer(Request, "StudentUID");

            try
            {
                jsonModel = Get_Backlog_Helper(StudentUID);
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

        public static JsonModel Get_Backlog_Helper(string StudentUID)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                //List<RegularDataRoomModel> list = (from regu in Constant.Eva_Regular_List
                //                                   where regu.StartTime < DateTime.Now && ((DateTime)regu.EndTime).AddDays(1) > DateTime.Now && regu.Type == (int)ReguType.Student
                //                                   join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                //                                   from room in Constant.CourseRoom_List
                //                                   where (regu.DepartmentIDs.Contains(room.Major_Id)) || regu.DepartmentIDs == ""
                //                                   join cls in Constant.Class_StudentInfo_List on room.ClassID equals cls.Class_Id
                //                                   join stu in Constant.Student_List on cls.UniqueNo equals stu.UniqueNo
                //                                   where stu.UniqueNo == StudentUID
                //                                   join q in Constant.Eva_QuestionAnswer_List on new
                //                                   {
                //                                       ReguID = regu.Id,
                //                                       AnswerUID = stu.UniqueNo,
                //                                       TeacherUID = room.TeacherUID,
                //                                       CourseID = room.Coures_Id,
                //                                   } equals new
                //                                   {
                //                                       ReguID = q.ReguID,
                //                                       AnswerUID = q.AnswerUID,
                //                                       TeacherUID = q.TeacherUID,
                //                                       CourseID = q.CourseID,
                //                                   } into ques
                //                                   from q_ in ques.DefaultIfEmpty()
                //                                   orderby regu.EndTime
                //                                   select new RegularDataRoomModel()
                //                                   {
                //                                       Num = 0,
                //                                       SectionID = section.Id,
                //                                       DisPlayName = section.DisPlayName,
                //                                       ReguID = regu.Id,
                //                                       ReguName = regu.Name,

                //                                       CourseID = room.Coures_Id,
                //                                       CourseName = room.CouresName,
                //                                       TeacherUID = room.TeacherUID,
                //                                       TeacherName = room.TeacherName,
                //                                       RoomDepartmentName = room.RoomDepartmentName,
                //                                       GradeName = room.GradeName,
                //                                       ClassName = room.ClassName,
                //                                       StudentCount = room.StudentCount,
                //                                       QuestionCount = 0,
                //                                       QuestionAve = 0,
                //                                       ScoreAve = 0,
                //                                       TableID = regu.TableID,

                //                                       CreateTime = q_ != null ? q_.CreateTime : null,
                //                                       IsAnswer = q_ == null ? false : true,
                //                                   }).ToList();

                var list = (from li in Constant.Eva_QuestionAnswer_List
                            join regu in Constant.Eva_Regular_List on li.ReguID equals regu.Id
                            join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                            where li.AnswerUID == StudentUID
                            select
                                new RegularDataRoomModel()
                                {
                                    Num = 0,
                                    SectionID = li.SectionID,
                                    DisPlayName = section.DisPlayName,
                                    ReguID = regu.Id,
                                    ReguName = regu.Name,
                                    Id = li.Id,
                                    CourseID = li.CourseID,
                                    CourseName = li.CourseName,
                                    TeacherUID = li.TeacherUID,
                                    TeacherName = li.TeacherName,
                                    TableID = regu.TableID,
                                    CreateTime = li.CreateTime,
                                }).ToList();

                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", list);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        #endregion

        #region 获取定期评价列表数据【exp】

        /// <summary>
        /// 获取定期评价列表数据
        /// </summary>
        public void Get_Eva_RegularData(HttpContext context)
        {
            HttpRequest Request = context.Request;

            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            int ReguId = RequestHelper.int_transfer(Request, "ReguId");
            string Key = RequestHelper.string_transfer(Request, "Key");
            string SelectUID = RequestHelper.string_transfer(Request, "SelectUID");

            string Te = RequestHelper.string_transfer(Request, "Te");

            int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
            int PageSize = RequestHelper.int_transfer(Request, "PageSize");
            try
            {
                jsonModel = Get_Eva_RegularData_Helper(PageIndex, PageSize, SectionID, ReguId, Key, SelectUID, Te);
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

        public static JsonModel Get_Eva_RegularData_Helper(int PageIndex, int PageSize, int SectionID, int ReguId, string Key, string SelectUID, string Te)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                List<RegularDataModel> list = (from exp in Constant.Expert_Teacher_Course_List
                                               join teacher in Constant.Teacher_List on exp.TeacherUID equals teacher.UniqueNo
                                               join regu in Constant.Eva_Regular_List on exp.ReguId equals Convert.ToString(regu.Id)
                                               join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                                               orderby exp.CreateTime descending
                                               select new RegularDataModel()
                                               {
                                                   Num = 0,
                                                   Id = exp.Id,
                                                   TeacherName = exp.TeacherName,
                                                   TeacherUID = exp.TeacherUID,
                                                   ExpertName = exp.ExpertName,
                                                   ExpertUID = exp.ExpertUID,
                                                   Course_Name = exp.Course_Name,
                                                   CourseID = exp.CourseId,
                                                   Departent_Name = teacher.Departent_Name,
                                                   ReguName = regu.Name,
                                                   StartTime = regu.StartTime,
                                                   EndTime = regu.EndTime,
                                                   State = "",
                                                   StateType = 0,
                                                   LookType = regu.LookType,
                                                   ReguId = regu.Id,
                                                   DisPlayName = section.DisPlayName,
                                                   SectionID = section.Id,
                                               }).ToList();


                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();
                }

                if (ReguId > 0)
                {
                    list = (from li in list where li.ReguId == ReguId select li).ToList();
                }

                if (Key != "")
                {
                    list = (from li in list where li.TeacherName.Contains(Key) select li).ToList();
                }
                if (SelectUID != "")
                {
                    list = (from li in list where li.ExpertUID == SelectUID select li).ToList();
                }

                if (Te != "")
                {
                    list = (from li in list where li.TeacherUID == Te select li).ToList();
                }
                for (int i = 0; i < list.Count; i++)
                {
                    list[i].Num = i + 1;
                }

                var query_last = (from an in list select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();
                foreach (var li in query_last)
                {
                    ReguState regustate = ReguState.进行中;
                    if (li.StartTime < DateTime.Now && ((DateTime)li.EndTime).AddDays(1) > DateTime.Now)
                    {
                        regustate = ReguState.进行中;
                    }
                    else if (li.StartTime > DateTime.Now)
                    {
                        regustate = ReguState.未开始;
                    }
                    else
                    {
                        regustate = ReguState.已结束;
                    }
                    li.State = Convert.ToString(regustate);
                    li.StateType = (int)regustate;

                    li.AnswerCount = Constant.Eva_QuestionAnswer_List.Count(q => q.ReguID == li.ReguId && q.CourseID == li.CourseID);
                }
                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)list.Count() / PageSize);
                jsm.RowCount = list.Count();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        /// <summary>
        /// 获取定期评价列表数据筛选
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_RegularDataSelect(HttpContext context)
        {
            HttpRequest Request = context.Request;
            int SectionID = RequestHelper.int_transfer(Request, "SectionID");
            string SelectUID = RequestHelper.string_transfer(Request, "SelectUID");
            try
            {
                jsonModel = Get_Eva_RegularDataSelect_Helper(SectionID, SelectUID);
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

        public static JsonModel Get_Eva_RegularDataSelect_Helper(int SectionID, string SelectUID)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var list = (from exp in Constant.Expert_Teacher_Course_List
                            join teacher in Constant.Teacher_List on exp.TeacherUID equals teacher.UniqueNo
                            join regu in Constant.Eva_Regular_List on exp.ReguId equals Convert.ToString(regu.Id)
                            join section in Constant.StudySection_List on regu.Section_Id equals section.Id
                            select new
                           {
                               SectionID = section.Id,

                               ReguId = regu.Id,
                               ReguName = regu.Name,

                               TeacherUID = teacher.UniqueNo,
                               TeacherName = teacher.Name,

                               ExpertUID = exp.ExpertUID,
                               exp.Type,

                           }).ToList();

                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();
                }
                if (SelectUID != "")
                {
                    list = (from li in list where li.ExpertUID == SelectUID select li).ToList();
                }
                var select = new
                {
                    RgList = (from li in list select new ReModel() { ReguId = li.ReguId, ReguName = li.ReguName }).Distinct(new ReModelComparer()).ToList(),
                    TeList = (from li in list select new TeModel { TeacherUID = li.TeacherUID, TeacherName = li.TeacherName }).Distinct(new TeModelComparer()).ToList(),
                };

                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", select);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }

        /// <summary>
        /// 获取评价名称
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_Regular_Name(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            try
            {
                HttpRequest Request = context.Request;

                var _list = (from t in Constant.Eva_Regular_List
                             where t.StartTime < DateTime.Now
                             select new { Name = t.Name }).Distinct();
                //返回所有表格数据
                jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", _list);
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

        #region 删除定期评价

        /// <summary>
        /// 删除定期评价
        /// </summary>
        public void Delete_Eva_Regular(HttpContext context)
        {
            HttpRequest Request = context.Request;
            //指标的ID
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                jsonModel = Delete_Eva_RegularHelper(Id);
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

        public static JsonModel Delete_Eva_RegularHelper(int Id)
        {
            JsonModel model = new JsonModel();
            int intSuccess = (int)errNum.Success;
            try
            {
                //获取指定要删除的定期评价
                Eva_Regular Eva_Regular_delete = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                if (Eva_Regular_delete != null)
                {
                    var experlist_Count = Constant.Expert_Teacher_Course_List.Count(i => i.ReguId == Convert.ToString(Eva_Regular_delete.Id));
                    if (experlist_Count == 0)
                    {
                        //数据库操作成功再改缓存
                        model = Constant.Eva_RegularService.Delete((int)Eva_Regular_delete.Id);
                        if (model.errNum == intSuccess)
                        {
                            Eva_Regular_delete.IsDelete = (int)IsDelete.Delete;
                            Constant.Eva_Regular_List.Remove(Eva_Regular_delete);
                        }
                        else
                        {
                            model = JsonModel.get_jsonmodel(3, "failed", "删除失败");
                        }
                    }
                    else
                    {
                        model = JsonModel.get_jsonmodel(3, "failed", "该定期评价已分配任务");
                    }
                }
                else
                {
                    model = JsonModel.get_jsonmodel(3, "failed", "该评价不存在");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        #endregion

        #region 编辑定期评价

        /// <summary>
        /// 修改定期评价
        /// </summary>
        public void Edit_Eva_Regular(HttpContext context)
        {
            HttpRequest Request = context.Request;
            //名称 开始时间 结束时间  最大百分比 最小百分比
            string Name = RequestHelper.string_transfer(Request, "Name");
            int Id = RequestHelper.int_transfer(Request, "Id");
            DateTime StartTime = RequestHelper.DateTime_transfer(Request, "StartTime");
            DateTime EndTime = RequestHelper.DateTime_transfer(Request, "EndTime");
            byte LookType = Convert.ToByte(Request["LookType"]);
            DateTime Look_StartTime = RequestHelper.DateTime_transfer(Request, "Look_StartTime");
            DateTime Look_EndTime = RequestHelper.DateTime_transfer(Request, "Look_EndTime");
            string MaxPercent = RequestHelper.string_transfer(Request, "MaxPercent");
            string MinPercent = RequestHelper.string_transfer(Request, "MinPercent");
            string Remarks = RequestHelper.string_transfer(Request, "Remarks");
            string EditUID = RequestHelper.string_transfer(Request, "EditUID");
            int Section_Id = RequestHelper.int_transfer(Request, "Section_Id");
            int Type = RequestHelper.int_transfer(Request, "Type");
            int TableID = RequestHelper.int_transfer(Request, "TableID");
            string DepartmentIDs = RequestHelper.string_transfer(Request, "DepartmentIDs");
            bool hasAcross = false;
            try
            {
                #region 查看是否交叉

                var reguList = (from regu in Constant.Eva_Regular_List where regu.Id != Id && regu.Type == Type select regu).ToList();

                foreach (Eva_Regular regu in reguList)
                {
                    if (StartTime <= regu.StartTime && EndTime >= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                    if (StartTime >= regu.StartTime && StartTime <= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                    if (EndTime >= regu.StartTime && EndTime <= regu.EndTime)
                    {
                        hasAcross = true;
                        break;
                    }
                }

                #endregion

                if (!hasAcross)
                {
                    var section = Constant.StudySection_List.FirstOrDefault(i => i.Id == Section_Id);
                    if (section != null)
                    {
                        if (StartTime > section.StartTime && EndTime < section.EndTime)
                        {
                            #region 编辑评价

                            var reguEdit = Constant.Eva_Regular_List.FirstOrDefault(i => i.Id == Id);
                            if (reguEdit != null)
                            {
                                var regu_Clone = Constant.Clone<Eva_Regular>(reguEdit);

                                regu_Clone.Name = Name;
                                regu_Clone.StartTime = StartTime;
                                regu_Clone.EndTime = EndTime;
                                regu_Clone.LookType = LookType;
                                regu_Clone.Look_StartTime = Look_StartTime;
                                regu_Clone.Look_EndTime = Look_EndTime;
                                regu_Clone.MaxPercent = MaxPercent;
                                regu_Clone.MinPercent = MinPercent;
                                regu_Clone.Remarks = Remarks;
                                regu_Clone.EditTime = DateTime.Now;
                                regu_Clone.EditUID = EditUID;
                                regu_Clone.Type = Type;
                                regu_Clone.TableID = TableID;
                                regu_Clone.DepartmentIDs = DepartmentIDs;

                                //数据库添加
                                jsonModel = Constant.Eva_RegularService.Update(regu_Clone);
                                if (jsonModel.errNum == 0)
                                {
                                    reguEdit.Name = Name;
                                    reguEdit.StartTime = StartTime;
                                    reguEdit.EndTime = EndTime;
                                    reguEdit.LookType = LookType;
                                    reguEdit.Look_StartTime = Look_StartTime;
                                    reguEdit.Look_EndTime = Look_EndTime;
                                    reguEdit.MaxPercent = MaxPercent;
                                    reguEdit.MinPercent = MinPercent;
                                    reguEdit.Remarks = Remarks;
                                    reguEdit.EditTime = DateTime.Now;
                                    reguEdit.EditUID = EditUID;
                                    reguEdit.Type = Type;
                                    reguEdit.TableID = TableID;
                                    reguEdit.DepartmentIDs = DepartmentIDs;
                                }
                                else
                                {
                                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "编辑失败");
                                }
                            }
                            else
                            {
                                jsonModel = JsonModel.get_jsonmodel(3, "failed", "该评价不存在");
                            }

                            #endregion
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "超出了该学年学期的时间范围");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                    }
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "和已知的定期评价时间交叉");
                }
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

        #region 添加定期评价

        //上锁
        static object obj_Add_Eva_Regular = new object();
        /// <summary>
        /// 新增定期评价
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_Eva_Regular(HttpContext context)
        {
            lock (obj_Add_Eva_Regular)
            {
                HttpRequest Request = context.Request;
                //名称 开始时间 结束时间  最大百分比 最小百分比
                string Name = RequestHelper.string_transfer(Request, "Name");
                DateTime StartTime = RequestHelper.DateTime_transfer(Request, "StartTime");
                DateTime EndTime = RequestHelper.DateTime_transfer(Request, "EndTime");
                byte LookType = Convert.ToByte(Request["LookType"]);
                DateTime Look_StartTime = RequestHelper.DateTime_transfer(Request, "Look_StartTime");
                DateTime Look_EndTime = RequestHelper.DateTime_transfer(Request, "Look_EndTime");
                string MaxPercent = RequestHelper.string_transfer(Request, "MaxPercent");
                string MinPercent = RequestHelper.string_transfer(Request, "MinPercent");
                string Remarks = RequestHelper.string_transfer(Request, "Remarks");
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");
                string EditUID = RequestHelper.string_transfer(Request, "EditUID");
                int Section_Id = RequestHelper.int_transfer(Request, "Section_Id");
                int Type = RequestHelper.int_transfer(Request, "Type");
                int TableID = RequestHelper.int_transfer(Request, "TableID");

                string DepartmentIDs = RequestHelper.string_transfer(Request, "DepartmentIDs");
                bool hasAcross = false;
                try
                {
                    #region 查看是否交叉

                    var reguList = (from regu in Constant.Eva_Regular_List where regu.Type == Type select regu).ToList();

                    foreach (Eva_Regular regu in reguList)
                    {
                        if (StartTime <= regu.StartTime && EndTime >= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                        if (StartTime >= regu.StartTime && StartTime <= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                        if (EndTime >= regu.StartTime && EndTime <= regu.EndTime)
                        {
                            hasAcross = true;
                            break;
                        }
                    }

                    #endregion

                    var section = Constant.StudySection_List.FirstOrDefault(i => i.Id == Section_Id);
                    if (section != null)
                    {
                        if (StartTime > section.StartTime && EndTime < section.EndTime)
                        {
                            #region 添加评价

                            if (!hasAcross)
                            {
                                //新建定期评价
                                Eva_Regular Eva_Regular_Add = new Eva_Regular()
                                {
                                    Name = Name,
                                    Section_Id = Section_Id,
                                    StartTime = StartTime,
                                    EndTime = EndTime,
                                    LookType = LookType,
                                    Look_StartTime = Look_StartTime,
                                    Look_EndTime = Look_EndTime,
                                    MaxPercent = MaxPercent,
                                    MinPercent = MinPercent,
                                    Remarks = Remarks,
                                    CreateTime = DateTime.Now,
                                    CreateUID = CreateUID,
                                    EditTime = DateTime.Now,
                                    EditUID = EditUID,
                                    IsEnable = (int)IsEnable.Enable,
                                    IsDelete = (int)IsDelete.No_Delete,
                                    Type = Type,
                                    TableID = TableID,
                                    DepartmentIDs = DepartmentIDs,

                                };
                                //数据库添加
                                jsonModel = Constant.Eva_RegularService.Add(Eva_Regular_Add);
                                if (jsonModel.errNum == 0)
                                {
                                    //从数据库返回的ID绑定
                                    Eva_Regular_Add.Id = Convert.ToInt32(jsonModel.retData);
                                    //缓存添加
                                    Constant.Eva_Regular_List.Add(Eva_Regular_Add);
                                }
                                else
                                {
                                    jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                                }
                            }
                            else
                            {
                                jsonModel = JsonModel.get_jsonmodel(3, "failed", "和已知的定期评价时间交叉");
                            }

                            #endregion
                        }
                        else
                        {
                            jsonModel = JsonModel.get_jsonmodel(3, "failed", "超出了该学年学期的时间范围");
                        }
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(3, "failed", "添加失败");
                    }


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
        }


        #endregion

        #region 答题管理

        //上锁int score
        static object obj_Add_Eva_QuestionAnswer = new object();
        /// <summary>
        /// 新增学生答题
        /// </summary>
        /// <param name="context">当前上下文</param>
        public void Add_Eva_QuestionAnswer(HttpContext context)
        {
            lock (obj_Add_Eva_QuestionAnswer)
            {
                int intSuccess = (int)errNum.Success;
                HttpRequest Request = context.Request;

                //学年学期的ID
                int SectionID = RequestHelper.int_transfer(Request, "SectionID");
                string DisPlayName = RequestHelper.string_transfer(Request, "DisPlayName");

                int ReguID = RequestHelper.int_transfer(Request, "ReguID");
                string ReguName = RequestHelper.string_transfer(Request, "ReguName");

                //课程的ID
                string CourseID = RequestHelper.string_transfer(Request, "CourseID");
                string CourseName = RequestHelper.string_transfer(Request, "CourseName");

                //教师的ID
                string TeacherUID = RequestHelper.string_transfer(Request, "TeacherUID");
                string TeacherName = RequestHelper.string_transfer(Request, "TeacherName");

                //学生【用户唯一标识符】
                string AnswerUID = RequestHelper.string_transfer(Request, "AnswerUID");
                string AnswerName = RequestHelper.string_transfer(Request, "AnswerName");

                int TableID = RequestHelper.int_transfer(Request, "TableID");
                string TableName = RequestHelper.string_transfer(Request, "TableName");

                int State = RequestHelper.int_transfer(Request, "State");
                //得分
                decimal Score = RequestHelper.decimal_transfer(Request, "Score");
                //创建者
                string CreateUID = RequestHelper.string_transfer(Request, "CreateUID");

                int Eva_Role = RequestHelper.int_transfer(Request, "Eva_Role");

                //答题详情明细
                string List = RequestHelper.string_transfer(Request, "List");

                //表头明显
                string HeaderList = RequestHelper.string_transfer(Request, "HeaderList");

                //课程分类
                var data = (from r in Constant.CourseRel_List
                            join c in Constant.Sys_Dictionary_List on r.CourseType_Id equals c.Key
                            where c.Type == "0"
                            select new { r, c }).ToList();

                try
                {
                    var first = data.Count > 0 ? data[0] : null;

                    #region 答题
                    //学生回答任务信息表
                    Eva_QuestionAnswer Eva_QuestionAnswer = new Eva_QuestionAnswer()
                    {
                        SectionID = SectionID,
                        DisPlayName = DisPlayName,
                        ReguID = ReguID,
                        ReguName = ReguName,
                        CourseTypeID = first != null ? first.c.Key : "",
                        CourseTypeName = first != null ? first.c.Value : "",
                        CourseID = CourseID,
                        CourseName = CourseName,
                        AnswerUID = AnswerUID,
                        AnswerName = AnswerName,
                        TeacherUID = TeacherUID,
                        TeacherName = TeacherName,
                        TableID = TableID,
                        TableName = TableName,
                        Score = Score,
                        State = State,
                        Eva_Role = Eva_Role,
                        CreateUID = CreateUID,
                        CreateTime = DateTime.Now,
                        EditTime = DateTime.Now,
                        EditUID = CreateUID,
                        IsDelete = (int)IsDelete.No_Delete,
                        IsEnable = (int)IsEnable.Enable
                    };
                    jsonModel = Constant.Eva_QuestionAnswerService.Add(Eva_QuestionAnswer);
                    if (jsonModel.errNum == intSuccess)
                    {
                        Eva_QuestionAnswer.Id = Convert.ToInt32(jsonModel.retData);
                    }

                    #endregion

                    if (jsonModel.errNum == intSuccess)
                    {
                        Constant.Eva_QuestionAnswer_List.Add(Eva_QuestionAnswer);

                        #region 表头添加

                        //序列化表单详情列表
                        List<Eva_QuestionAnswer_Header> Eva_QuestionAnswer_Header_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Header>>(HeaderList);

                        //答题任务详情填充
                        foreach (Eva_QuestionAnswer_Header item in Eva_QuestionAnswer_Header_List)
                        {

                            item.QuestionID = Eva_QuestionAnswer.Id;
                            item.CreateTime = DateTime.Now;
                            item.CreateUID = AnswerUID;
                            item.EditUID = AnswerUID;
                            item.EditTime = DateTime.Now;
                            item.IsDelete = (int)IsDelete.No_Delete;
                            item.IsEnable = (int)IsEnable.Enable;
                            //数据库插入
                            JsonModel jsm = Constant.Eva_QuestionAnswer_HeaderService.Add(item);
                            //插入成功入缓存
                            if (jsm.errNum == intSuccess)
                            {
                                item.Id = Convert.ToInt32(jsm.retData);
                                Constant.Eva_QuestionAnswer_Header_List.Add(item);
                            }
                        }

                        #endregion

                        #region 答题详情


                        //序列化表单详情列表
                        List<Eva_QuestionAnswer_Detail> Eva_QuestionAnswer_Detail_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Detail>>(List);

                        //答题任务详情填充
                        foreach (Eva_QuestionAnswer_Detail item in Eva_QuestionAnswer_Detail_List)
                        {
                            item.SectionID = SectionID;
                            item.DisPlayName = DisPlayName;
                            item.ReguID = ReguID;
                            item.ReguName = ReguName;
                            item.TeacherUID = TeacherUID;
                            item.TeacherName = TeacherName;
                            item.CourseTypeID = Eva_QuestionAnswer.CourseTypeID;
                            item.CourseTypeName = Eva_QuestionAnswer.CourseTypeName;
                            item.CourseID = CourseID;
                            item.CourseName = CourseName;
                            item.AnswerUID = AnswerUID;
                            item.AnswerName = AnswerName;
                            item.QuestionID = Eva_QuestionAnswer.Id;
                            item.TableID = TableID;
                            item.TableName = TableName;
                            item.Eva_Role = Eva_Role;

                            item.State = State;
                            item.CreateTime = DateTime.Now;
                            item.CreateUID = AnswerUID;
                            item.EditUID = AnswerUID;
                            item.EditTime = DateTime.Now;
                            item.IsDelete = (int)IsDelete.No_Delete;
                            item.IsEnable = (int)IsEnable.Enable;
                            //数据库插入
                            JsonModel jsm = Constant.Eva_QuestionAnswer_DetailService.Add(item);
                            //插入成功入缓存
                            if (jsm.errNum == intSuccess)
                            {
                                item.Id = Convert.ToInt32(jsm.retData);
                                Constant.Eva_QuestionAnswer_Detail_List.Add(item);
                            }
                        }

                        #endregion
                    }
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
        }

        public void Edit_Eva_QuestionAnswer(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            int State = RequestHelper.int_transfer(Request, "State");
            //得分
            decimal Score = RequestHelper.decimal_transfer(Request, "Score");
            //答题详情明细
            string List = RequestHelper.string_transfer(Request, "List");
            //表头明显
            string HeaderList = RequestHelper.string_transfer(Request, "HeaderList");

            try
            {
                Eva_QuestionAnswer Eva_QuestionAnswer = Constant.Eva_QuestionAnswer_List.FirstOrDefault(q => q.Id == Id);
                List<Eva_QuestionAnswer_Header> headerList = (from h in Constant.Eva_QuestionAnswer_Header_List where h.QuestionID == Id select h).ToList();
                List<Eva_QuestionAnswer_Detail> detailList = (from q in Constant.Eva_QuestionAnswer_Detail_List where q.QuestionID == Id select q).ToList();
                Eva_QuestionAnswer Eva_QuestionAnswerClone = Constant.Clone(Eva_QuestionAnswer);
                Eva_QuestionAnswerClone.EditTime = DateTime.Now;
                Eva_QuestionAnswerClone.State = State;
                Eva_QuestionAnswerClone.Score = Score;
                jsonModel = Constant.Eva_QuestionAnswerService.Update(Eva_QuestionAnswerClone);

                if (jsonModel.errNum == intSuccess)
                {
                    Eva_QuestionAnswer.EditTime = DateTime.Now;
                    Eva_QuestionAnswer.State = State;
                    Eva_QuestionAnswer.Score = Score;

                    #region 表头添加

                    //序列化表单详情列表
                    List<Eva_QuestionAnswer_Header> Eva_QuestionAnswer_Header_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Header>>(HeaderList);

                    //答题任务详情填充
                    foreach (Eva_QuestionAnswer_Header item in Eva_QuestionAnswer_Header_List)
                    {
                        Eva_QuestionAnswer_Header detail = headerList.FirstOrDefault(i => i.Id == item.Id);
                        if (detail != null)
                        {
                            Eva_QuestionAnswer_Header detailClone = Constant.Clone(detail);
                            detailClone.Value = item.Value;
                            detailClone.ValueID = item.ValueID;
                            detailClone.EditTime = DateTime.Now;
                            var jsm = Constant.Eva_QuestionAnswer_HeaderService.Update(detailClone);
                            if (jsm.errNum == 0)
                            {
                                detail.Value = item.Value;
                                detail.ValueID = item.ValueID;
                                detail.EditTime = DateTime.Now;
                            }
                        }
                    }

                    #endregion

                    #region 答题详情


                    //序列化表单详情列表
                    List<Eva_QuestionAnswer_Detail> Eva_QuestionAnswer_Detail_List = JsonConvert.DeserializeObject<List<Eva_QuestionAnswer_Detail>>(List);

                    //答题任务详情填充
                    foreach (Eva_QuestionAnswer_Detail item in Eva_QuestionAnswer_Detail_List)
                    {
                        Eva_QuestionAnswer_Detail detail = detailList.FirstOrDefault(i => i.TableDetailID == item.TableDetailID);
                        if (detail != null)
                        {
                            Eva_QuestionAnswer_Detail detailClone = Constant.Clone(detail);
                            detailClone.Answer = item.Answer;
                            detailClone.Score = item.Score;
                            detailClone.State = State;
                            detailClone.EditTime = DateTime.Now;
                            var jsm = Constant.Eva_QuestionAnswer_DetailService.Update(detailClone);
                            if (jsm.errNum == 0)
                            {
                                detail.Answer = item.Answer;
                                detail.Score = item.Score;
                                detail.State = State;
                                detail.EditTime = DateTime.Now;
                            }
                        }
                    }

                    #endregion
                }
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

        /// <summary>
        /// 状态变更
        /// </summary>
        /// <param name="context"></param>
        public void Change_Eva_QuestionAnswer_State(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            int intFailed = (int)errNum.Failed;
            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            int State = RequestHelper.int_transfer(Request, "State");
            try
            {
                Eva_QuestionAnswer answer = Constant.Eva_QuestionAnswer_List.FirstOrDefault(i => i.Id == Id);
                if (answer != null)
                {
                    Eva_QuestionAnswer answerClone = Constant.Clone(answer);
                    answerClone.State = State;
                    jsonModel = Constant.Eva_QuestionAnswerService.Update(answerClone);
                    if (jsonModel.errNum == intSuccess)
                    {
                        answer.State = State;
                        List<Eva_QuestionAnswer_Detail> details = (from d in Constant.Eva_QuestionAnswer_Detail_List where d.QuestionID == Id select d).ToList();
                        foreach (var item in details)
                        {
                            Eva_QuestionAnswer_Detail detailClone = Constant.Clone(item);
                            detailClone.State = State;
                            var jsm = Constant.Eva_QuestionAnswer_DetailService.Update(detailClone);
                            if (jsm.errNum == 0)
                            {
                                item.State = State;
                            }
                        }

                    }
                }
                else
                {
                    jsonModel = JsonModel.get_jsonmodel(intFailed, "failed", "操作失败");
                }

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


        /// <summary>
        /// 删除答题
        /// </summary>
        /// <param name="context"></param>
        public void Remove_Eva_QuestionAnswer(HttpContext context)
        {
            int intSuccess = (int)errNum.Success;
            HttpRequest Request = context.Request;
            int Id = RequestHelper.int_transfer(Request, "Id");
            try
            {
                jsonModel = Constant.Eva_QuestionAnswerService.Delete(Id);
                if (jsonModel.errNum == intSuccess)
                {
                    Constant.Eva_QuestionAnswer_List.RemoveAll(i => i.Id == Id);

                    var header_ids = (from h in Constant.Eva_QuestionAnswer_Header_List where h.QuestionID == Id select Convert.ToString(h.Id)).ToArray();
                    var jsm = Constant.Eva_QuestionAnswer_HeaderService.DeleteBatch(header_ids);
                    if (jsm.errNum == 0)
                    {
                        Constant.Eva_QuestionAnswer_Header_List.RemoveAll(i => i.QuestionID == Id);
                    }

                    var detail_ids = (from d in Constant.Eva_QuestionAnswer_Detail_List where d.QuestionID == Id select Convert.ToString(d.Id)).ToArray();
                    var jsm2 = Constant.Eva_QuestionAnswer_DetailService.DeleteBatch(detail_ids);
                    if (jsm2.errNum == 0)
                    {
                        Constant.Eva_QuestionAnswer_Detail_List.RemoveAll(i => i.QuestionID == Id);
                    }
                }
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


        /// <summary>
        /// 获取答题列表
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_QuestionAnswer(HttpContext context)
        {
            lock (obj_Add_Eva_QuestionAnswer)
            {

                HttpRequest Request = context.Request;

                //学年学期的ID
                int SectionID = RequestHelper.int_transfer(Request, "SectionID");
                string DepartmentID = RequestHelper.string_transfer(Request, "DepartmentID");
                //课程的ID
                string Key = RequestHelper.string_transfer(Request, "Key");
                int Mode = RequestHelper.int_transfer(Request, "Mode");

                int TableID = RequestHelper.int_transfer(Request, "TableID");
                string AnswerUID = RequestHelper.string_transfer(Request, "AnswerUID");

                int PageIndex = RequestHelper.int_transfer(Request, "PageIndex");
                int PageSize = RequestHelper.int_transfer(Request, "PageSize");
                try
                {
                    ModeType modeType = (ModeType)Mode;
                    jsonModel = Get_Eva_QuestionAnswer_Helper(PageIndex, PageSize, SectionID, DepartmentID, Key, TableID, AnswerUID, modeType);
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
        }

        /// <summary>
        /// 获取答题列表
        /// </summary>
        /// <param name="context"></param>
        public static JsonModel Get_Eva_QuestionAnswer_Helper(int PageIndex, int PageSize, int SectionID, string DepartmentID, string Key, int TableID, string AnswerUID, ModeType modeType)
        {
            int intSuccess = (int)errNum.Success;
            JsonModelNum jsm = new JsonModelNum();
            try
            {
                var list = (from q in Constant.Eva_QuestionAnswer_List
                            join u in Constant.UserInfo_List on q.TeacherUID equals u.UniqueNo
                            join d in Constant.Major_List on u.Major_ID equals d.Id
                            select new Eva_QuestionModel()
                            {
                                Id = q.Id,
                                SectionID = q.SectionID,
                                DisPlayName = q.DisPlayName,
                                TeacherUID = q.TeacherUID,
                                TeacherName = q.TeacherName,
                                CourseID = q.CourseID,
                                CourseName = q.CourseName,
                                DepartmentID = d.Id,
                                DepartmentName = d.Major_Name,
                                TableID = q.TableID,
                                TableName = q.TableName,
                                State = q.State,
                                Score = q.Score,
                                Num = 0,
                                ReguID = q.ReguID,
                                ReguName = q.ReguName,
                                AnswerUID = q.AnswerUID,
                                AnswerName = q.AnswerName,
                            }).ToList();

                if (SectionID > 0)
                {
                    list = (from li in list where li.SectionID == SectionID select li).ToList();
                }
                if (DepartmentID != "")
                {
                    list = (from li in list where li.DepartmentID == DepartmentID select li).ToList();
                }
                if (TableID > 0)
                {
                    list = (from li in list where li.TableID == TableID select li).ToList();
                }
                if (AnswerUID != "")
                {
                    list = (from li in list where li.AnswerUID == AnswerUID select li).ToList();
                }

                switch (modeType)
                {
                    case ModeType.Record:
                        if (Key != "")
                        {
                            list = (from li in list where li.CourseName.Contains(Key) || li.TeacherName.Contains(Key) select li).ToList();
                        }
                        break;
                    case ModeType.Check:
                        list = (from li in list where li.State == (int)QueState.Submited select li).ToList();
                        if (Key != "")
                        {
                            list = (from li in list where li.CourseName.Contains(Key) || li.TeacherName.Contains(Key) || li.AnswerName.Contains(Key) select li).ToList();
                        }
                        break;
                    case ModeType.Look:
                        break;
                    default:
                        break;
                }



                for (int i = 0; i < list.Count; i++)
                {
                    list[i].Num = i + 1;
                }

                var query_last = (from an in list select an).Skip((PageIndex - 1) * PageSize).Take(PageSize).ToList();
                //返回所有表格数据
                jsm = JsonModelNum.GetJsonModel_o(intSuccess, "success", query_last);
                jsm.PageIndex = PageIndex;
                jsm.PageSize = PageSize;
                jsm.PageCount = (int)Math.Ceiling((double)list.Count() / PageSize);
                jsm.RowCount = list.Count();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return jsm;
        }


        /// <summary>
        /// 获取答题列表
        /// </summary>
        /// <param name="context"></param>
        public void Get_Eva_QuestionAnswerDetail(HttpContext context)
        {
            lock (obj_Add_Eva_QuestionAnswer)
            {

                HttpRequest Request = context.Request;
                int intSuccess = (int)errNum.Success;
                int intFailed = (int)errNum.Failed;
                //学年学期的ID
                int Id = RequestHelper.int_transfer(Request, "Id");

                try
                {
                    Eva_QuestionAnswer question = Constant.Eva_QuestionAnswer_List.FirstOrDefault(i => i.Id == Id);
                    if (question != null)
                    {
                        List<Eva_QuestionAnswer_Detail> list = (from detail in Constant.Eva_QuestionAnswer_Detail_List where detail.QuestionID == question.Id select detail).ToList();
                        List<Eva_QuestionAnswer_Header> headerList = (from header in Constant.Eva_QuestionAnswer_Header_List where header.QuestionID == question.Id select header).ToList();
                        var data = new
                        {
                            HeaderList = (from h in headerList orderby h.Id select new { h.CustomCode, h.Name, h.ValueID, h.Value, h.Id }),
                            DetailList = (from li in list select new { li.Answer, li.TableDetailID, li.QuestionType, li.Score }),
                            TableName = question.TableName,
                            Score = question.Score,
                        };
                        jsonModel = JsonModel.get_jsonmodel(intSuccess, "success", data);
                    }
                    else
                    {
                        jsonModel = JsonModel.get_jsonmodel(intFailed, "failed", "该答题不存在");
                    }

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
        }

        #endregion

    }
}